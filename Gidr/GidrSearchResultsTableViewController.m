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


@interface GidrSearchResultsTableViewController ()

@property (nonatomic, strong) GidrEvent *selectedEvent;
@property (nonatomic, strong) GidrEventsMapper *eventsMapper;


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



- (NSManagedObjectContext *)context
{
    if (_context == nil){
        _context = [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
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

/*
 * Rest of methods should be in this file
 */

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GidrEventCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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


- (GidrEventsMapper *)eventsMapper
{
    if (_eventsMapper == nil) {
        _eventsMapper = [[GidrEventsMapper alloc] init];
    }
    return _eventsMapper;
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

@end
