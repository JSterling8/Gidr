//
//  GidrSettingsTableControllerViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrSettingsTableControllerViewController.h"
#import "GidrEventsMapper.h"
#import "GidrEvent.h"
#import "GidrAppDelegate.h"

@interface GidrSettingsTableControllerViewController ()

@property (nonatomic, weak) NSArray *tableSections;
@property (nonatomic, strong) GidrEventsMapper *eventsMapper;

@end

@implementation GidrSettingsTableControllerViewController

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
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableSections objectAtIndex:section ] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the UITableViewCell object from the storyboard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    // Get the title for the requested row
    NSString *rowTitle = [self getRowAtIndexPath:indexPath];
    // Set the text for the reqested row to be the name of the row
    cell.textLabel.text = rowTitle;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Interests";
    } else if (section == 1) {
        return @"Local Data Settings";
    }
    return @"Unknown Column Name";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowTitle = [self getRowAtIndexPath:indexPath];
    if ([rowTitle isEqualToString:@"Delete local events"]) {
        // Ask the user if they with to delete the local events
        [[[UIAlertView alloc] initWithTitle:@"Delete all events?" message:@"Deleting all local events will wipe the events database and require all events to re-downloaded" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
    } else if ([rowTitle isEqualToString:@"Modify Interests"]) {
        [self performSegueWithIdentifier:@"SettingsToInterestsView" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Coming Soon..." message:@"This option has not been implemented yet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Alert Viee delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Delete all events?"] && buttonIndex == 1) {
        // Delete the stored local events
        // Get the app delegate
        GidrAppDelegate *delegate = (GidrAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:delegate.managedObjectContext];
        [request setEntity:entityDescription];
        NSError *error;
        NSArray *events = [delegate.managedObjectContext executeFetchRequest:request error:&error];
        if (error == nil && events != nil) {
            for (GidrEvent *event in events) {
                [self.eventsMapper deleteEvent:event];
            }
            // Set the last update to never, since we now have no events! :(
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:nil forKey:@"lastUpdate"];
            [userDefaults synchronize];
        }
    }
}

#pragma mark Table view data methods

- (NSString *)getRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [self.tableSections objectAtIndex:indexPath.section];
    return [section objectAtIndex:indexPath.row];
}

#pragma mark Setter and getter methods

- (NSArray *)tableSections
{
    NSArray *userAccountSection = @[@"Modify Interests"];
    NSArray *localDataSection = @[@"Delete interests", @"Delete local events", @"Delete all local data"];
    NSArray *sections = @[userAccountSection,
                         localDataSection];
    return sections;
}

- (GidrEventsMapper *)eventsMapper
{
    if (_eventsMapper == nil) {
        _eventsMapper = [[GidrEventsMapper alloc] init];
    }
    return _eventsMapper;
}

@end