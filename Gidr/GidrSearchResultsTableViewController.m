//
//  GidrSearchResultsTableViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Developed by Jonathan Sterling 09/02/2014 to date.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrSearchResultsTableViewController.h"
#import "GidrEventViewController.h"
#import "GidrEventsMapper.h"
#import "Venue.h"

@interface GidrSearchResultsTableViewController ()

@property (nonatomic, strong) GidrEvent *selectedEvent;
@property (nonatomic, strong) GidrEventsMapper *eventsMapper;
@property (nonatomic, strong) NSArray *results;

@end

@implementation GidrSearchResultsTableViewController

@synthesize searchString;
@synthesize searchLabel;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchLabel setText:self.searchString];
    self.navigationItem.title = searchString;
}

- (void)viewDidLoad
{
    self.tableView.dataSource = self;
    
    [super viewDidLoad];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(name contains[c] \"%@\") OR (descriptionText contains[c] \"%@\")", self.searchString, self.searchString]]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate"
                                                                     ascending:YES];

    fetchRequest.sortDescriptors = @[sortDescriptor];
    [fetchRequest setFetchBatchSize:20];
    NSError *error = nil;
    self.results = [self.context executeFetchRequest:fetchRequest error:&error];
}

- (NSManagedObjectContext *)context
{
    if (_context == nil){
        _context = [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _context;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.results.count;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    GidrEvent *event = [self.results objectAtIndex:indexPath.row];
    [cell.textLabel setText:event.name];
    [cell.detailTextLabel setText:event.venue.name];
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GidrEventCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the segue to the devent details view
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
