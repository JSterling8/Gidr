//
//  GidrEventViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 26/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrEventViewController.h"

@interface GidrEventViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) GidrEventsController *eventsController;

@end

@implementation GidrEventViewController

- (void)viewDidLoad
{
    self.tableView.dataSource = self;

    [super viewDidLoad];

    GidrAppDelegate *appDelegate = (GidrAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.ViewController = self;

    // Configure Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull To Refresh Events"];
    [refreshControl addTarget:self action:@selector(refreshEvents:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    // The below 2 lines seem to fix an issue with the title overlaying the refresh indicator
    // This was taken from: http://stackoverflow.com/a/20797655/657676
    // Not doing this in another thread just makes with refresh indicator look weird. Stupid iOS is stupid. *walks off in a huff*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
        [self.refreshControl endRefreshing];
    });
    // Don't refresh on load, for testing
//    [self.refreshControl beginRefreshing];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
//    [self loadEventsFromParse];
}

- (void)refreshEvents:(id)sender
{
    // Set the text to let the user know we're refreshing the events
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    // Load the events from Parse.com
    // This also resets the title and stops the loading indicator
    [self loadEventsFromParse];
}

- (void)loadEventsFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"GidrEvent"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate = [userDefaults valueForKey:@"lastUpdate"];
    NSLog(@"Last Updated: %@", lastUpdate);
    if (lastUpdate != nil) {
        // An update has already occured, so only get new objects
        [query whereKey:@"updatedAt" greaterThanOrEqualTo:lastUpdate];
    }
    // Only get the events in the future
    [query whereKey:@"date" greaterThanOrEqualTo:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *loadedEvents, NSError *error) {
        if (!error) {
            // The find succeeded
            [userDefaults setValue:[NSDate date] forKey:@"lastUpdate"];
            [userDefaults synchronize];
            NSLog(@"Loaded %lu new events", (unsigned long)loadedEvents.count);
            if (loadedEvents.count > 0) {
                // New events found
                for (PFObject *loadedEvent in loadedEvents) {
                    GidrEvent* localEvent = [self.eventsController getEventWithId:loadedEvent.objectId];
                    if (localEvent != nil && [localEvent.id isEqualToString:loadedEvent.objectId]) {
                        // Update this event, rather than add it
                        [self.eventsController updateEventWithId:loadedEvent.objectId andName:loadedEvent[@"name"] andLocation:loadedEvent[@"location"] andDate:loadedEvent[@"date"]];
                    } else {
                        // Event wasn't udpated, so add it
                        [self.eventsController addEventWithId:loadedEvent.objectId andName:loadedEvent[@"name"] andLocation:loadedEvent[@"location"] andDate:loadedEvent[@"date"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Stop the cell being in the "selected" state
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = false;
    GidrEvent *event = [self.eventsController objectAtIndexPath:indexPath];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:event.name message:[NSString stringWithFormat:@"My location is: %@. And my Id: %@", event.location, event.id] delegate:nil cancelButtonTitle:@"Thanks For That" otherButtonTitles:nil];

    // Display Alert Message
    [messageAlert show];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // This just deletes all the labels, but leaves the cells :@
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GidrEventsController *)eventsController
{
    if (_eventsController == nil) {
        _eventsController = [[GidrEventsController alloc] init];
    }
    return _eventsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.eventsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.eventsController sections] objectAtIndex:section] numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GidrEvent *event = [self.eventsController objectAtIndexPath:indexPath];
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

// The below are just copy/paste methods that Apple provide
// Most of it is from http://www.raywenderlich.com/999/core-data-tutorial-for-ios-how-to-use-nsfetchedresultscontroller

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
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
@end
