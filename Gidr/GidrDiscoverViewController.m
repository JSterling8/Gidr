//
//  GidrEventViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 26/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrDiscoverViewController.h"
#import "GidrEventViewController.h"
#import "GidrEventsMapper.h"
#import "GidrDiscoverLogic.h"
#import "Venue.h"

@interface GidrDiscoverViewController ()

@property (nonatomic, strong) GidrEvent *selectedEvent;
@property (nonatomic, strong) GidrEventsMapper *eventsMapper;
@property (nonatomic, strong) GidrDiscoverLogic *discoverLogic;

@end

@implementation GidrDiscoverViewController

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
    // Start the refreshing in another thread
    // Doing this on another thread leads to some... interesting UI quirks
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    [self loadEventsFromParse];
    //    });
    self.discoverLogic = [[GidrDiscoverLogic alloc] init];
    [self.discoverLogic calculateCategoryPercentages];
}

- (void)loadEventsFromParse
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate = [userDefaults valueForKey:@"lastUpdate"];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query includeKey:@"Venue"];
    if (lastUpdate != nil) {
        // An update has already occured, so only get new objects
        [query whereKey:@"updatedAt" greaterThanOrEqualTo:lastUpdate];
    }
    // Only get the events in the future
    NSDate *currentDate = [NSDate date];
    [query whereKey:@"startDate" greaterThanOrEqualTo:currentDate];

    [query findObjectsInBackgroundWithBlock:^(NSArray *loadedEvents, NSError *error) {
        if (!error) {
            // The find succeeded
            [userDefaults setValue:currentDate forKey:@"lastUpdate"];
            [userDefaults synchronize];
            if (loadedEvents.count > 0) {
                // New events found
                for (PFObject *loadedEvent in loadedEvents) {
                    // This causes a crash, because the context is off?
                    GidrEvent* localEvent = [self.eventsMapper getEventWithId:loadedEvent.objectId];
                    if (localEvent != nil && [localEvent.id isEqualToString:loadedEvent.objectId]) {
                        // Update this event, rather than add it
                        [self.eventsMapper updateEvent:loadedEvent];
                    } else {
                        // Event wasn't udpated, so add it
                        [self.eventsMapper addEvent:loadedEvent];
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

- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    _context = [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return _context;
}

- (NSFetchedResultsController *)fetchedResultsController
{

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate"
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GidrEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:event.name]; 
    [cell.detailTextLabel setText:event.venue.name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GidrEventCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the segue to the event details view
    self.selectedEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"EventViewSegue" sender:self];
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventViewSegue"]) {
        GidrEventViewController *viewController = (GidrEventViewController *)[segue destinationViewController];
        viewController.event = self.selectedEvent;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark Getters

- (GidrEventsMapper *)eventsMapper
{
    if (_eventsMapper == nil) {
        _eventsMapper = [[GidrEventsMapper alloc] init];
    }
    return _eventsMapper;
}

@end
