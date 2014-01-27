//
//  GidrEventViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 26/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrEventViewController.h"

@interface GidrEventViewController ()

@end

@implementation GidrEventViewController

- (void)loadEventsFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"GidrEvent"];
    if (_lastUpdate != nil) {
        // An update has already occured, so only get new objects
        [query whereKey:@"updatedAt" greaterThanOrEqualTo:_lastUpdate];
    }
    // Only get the events in the future
    [query whereKey:@"date" greaterThanOrEqualTo:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *loadedEvents, NSError *error) {
        if (!error) {
            // The find succeeded
            _lastUpdate = [NSDate date];
            NSLog(@"Loaded %lu new events", loadedEvents.count);
            if (loadedEvents.count > 0) {
                // New events found
                for (PFObject *loadedEvent in loadedEvents) {
                    // This causes a crash, because the context is off?
                    GidrEvent* localEvent = [self getEventWithId:loadedEvent.objectId];
                    if (localEvent != nil && [localEvent.id isEqualToString:loadedEvent.objectId]) {
                        // Update this event, rather than add it
                        [self updateEventWithId:loadedEvent.objectId andName:loadedEvent[@"name"] andLocation:loadedEvent[@"location"] andDate:loadedEvent[@"date"]];
                    } else {
                        // Event wasn't udpated, so add it
                        [self addEventWithId:loadedEvent.objectId andName:loadedEvent[@"name"] andLocation:loadedEvent[@"location"] andDate:loadedEvent[@"date"]];
                    }
                }
            }
            [self.refreshControl endRefreshing];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull To Refresh Events"];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)refresh:(id)sender
{
    // Set the text to let the user know we're refreshing the events
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    // Load the events from Parse.com
    // This also resets the title and stops the loading indicator
    [self loadEventsFromParse];
}

- (void)addEventWithId:(NSString*)id andName:(NSString*)name andLocation:(NSString*)location andDate:(NSDate*) date
{
    NSLog(@"Adding an event");
    // Create a new managed object
    GidrEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];
    [newEvent setValue:id forKey:@"id"];
    [newEvent setValue:name forKey:@"name"];
    [newEvent setValue:location forKey:@"location"];
    [newEvent setValue:date forKey:@"date"];

    NSError *error;
    // Save the object to persistent store
    if (![self.context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        NSLog(@"Added event with name: %@", name);
    }
}

- (GidrEvent*)getEventWithId:(NSString*)id
{
    // TODO: This should jsut fetch one results, not an array and then get the first result
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", id];
    NSArray *events = [self.context executeFetchRequest:fetchRequest error:nil];
    if (events.count == 1) {
        return [events objectAtIndex:0];
    } else {
        return nil;
    }
}

- (BOOL)updateEventWithId:(NSString*)id andName:(NSString*)name andLocation:(NSString*)location andDate:(NSDate*) date
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", id];
    NSArray *events = [self.context executeFetchRequest:fetchRequest error:nil];
    if (events.count == 1) {
        GidrEvent *event = [events objectAtIndex:0];
        event.name = name;
        event.location = location;
        event.date = date;
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Can't Update event with name: %@: %@ %@", name, error, [error localizedDescription]);
            return false;
        } else {
            NSLog(@"Updated event with name: %@", name);
            return true;
        }
        return true;
    } else {
        return false;
    }
}

- (void)deleteEvent:(GidrEvent*)event
{
    NSString *name = event.name;
    [self.context deleteObject:event];

    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    } else {
        NSLog(@"Deleted event with name: %@", name);
    }
}

- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    self.context = [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return _context;
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                  ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                  managedObjectContext:self.context
                                   sectionNameKeyPath:nil
                                           cacheName:@"Event"];
    _fetchedResultsController.delegate = self;
    NSError *error;
    [_fetchedResultsController performFetch:&error];
    
    return _fetchedResultsController;
}

- (void)deleteAllEvents
{
    NSArray *events = [self.fetchedResultsController fetchedObjects];
    for (GidrEvent *event in events) {
        [self deleteEvent:event];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.dataSource = self;

    [super viewDidLoad];

    // Configure Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull To Refresh Events"];
    // Configure View Controller
    [self setRefreshControl:self.refreshControl];
    // Delete all events
//    [self deleteAllEvents];
    // Start the refreshing in another thread
    // Doing this on another thread leads to some... interesting UI quirks
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        [self.refreshControl beginRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
        [self loadEventsFromParse];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GidrEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *name = event.name;
    NSString *location = event.location;
    [cell.textLabel setText:name];
    [cell.detailTextLabel setText:location];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GidrEventCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

// The below are just copy/paste from methods that Apple provide

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end