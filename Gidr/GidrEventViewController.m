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
                NSMutableArray *newEvents = [NSMutableArray arrayWithCapacity:(_events.count + loadedEvents.count)];
                [newEvents addObjectsFromArray:_events];
                for (PFObject *loadedEvent in loadedEvents) {
                    BOOL eventUpdated = false;
                    GidrEvent *newEvent = [[GidrEvent alloc] init];
                    newEvent.id = loadedEvent.objectId;
                    newEvent.name = loadedEvent[@"name"];
                    newEvent.location = loadedEvent[@"location"];
                    newEvent.date = loadedEvent[@"date"];
                    for (int i = 0; i < newEvents.count; i++) {
                        GidrEvent *localEvent = [newEvents objectAtIndex:i];
                        if ([localEvent.id isEqualToString:newEvent.id]) {
                            // Update this object, rather than add it
                            [newEvents removeObjectAtIndex:i];
                            [newEvents addObject:newEvent];
                            eventUpdated = true;
                            NSLog(@"Updated event with name: %@", newEvent.name);
                            // End the first for loop
                            break;
                        }
                    }
                    if (!eventUpdated) {
                        // Event wasn't udpated, so add it
                        [newEvents addObject:newEvent];
                        NSLog(@"Added event with name: %@", newEvent.name);
                    }
                }
                // Sort the events by ascending date order
                NSArray *sortedEvents = [newEvents sortedArrayUsingComparator:^NSComparisonResult(GidrEvent *firstEvent, GidrEvent *secondEvent) {
                    BOOL ascending = true;
                    if (ascending) {
                        return [firstEvent.date compare:secondEvent.date];
                    } else {
                        return [secondEvent.date compare:firstEvent.date];
                    }
                }];
                _events = [sortedEvents mutableCopy];
                [self.tableView reloadData];
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
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    [self loadEventsFromParse];
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
    // Start the refreshing in another thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        [self.refreshControl beginRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
        [self loadEventsFromParse];
    });
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GidrEventCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    GidrEvent *event = [_events objectAtIndex:indexPath.row];
    NSString *name = event.name;
    NSString *location = event.location;
    [cell.textLabel setText:name];
    [cell.detailTextLabel setText:location];
    return cell;
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
