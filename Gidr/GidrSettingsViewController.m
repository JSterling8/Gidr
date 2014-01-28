//
//  GidrSettingsViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 27/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrSettingsViewController.h"

@implementation GidrSettingsViewController

- (void)viewDidLoad
{
    self.tableView.dataSource = self;
//    _rows = [[NSDictionary alloc] init];
    NSMutableDictionary *mainSection = [[NSMutableDictionary alloc] init];
    NSArray *rows = @[@"Option 1", @"Option 2"];
    [mainSection setValue:rows forKey:@"rows"];
    [mainSection setValue:@"Main Settings" forKey:@"title"];

    NSMutableDictionary *scarySection = [[NSMutableDictionary alloc] init];
    rows = @[@"Delete All Data", @"???"];
    [scarySection setValue:rows forKey:@"rows"];
    [scarySection setValue:@"The Scary Stuff" forKey:@"title"];

    _sections = @[mainSection, scarySection];
    [super viewDidLoad];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Test Title";
    return [[self.sections objectAtIndex:section] objectForKey:@"title"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GidrSettingsCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionIndex = indexPath.section;
    NSDictionary *section = [_sections objectAtIndex:sectionIndex];
    NSString *name = [[section objectForKey:@"rows"] objectAtIndex:indexPath.row];
//    NSString *name = @"Test Name";
    [cell.textLabel setText:name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = [_sections objectAtIndex:indexPath.section];
    NSString *name = [[section objectForKey:@"rows"] objectAtIndex:indexPath.row];
    if ([name isEqualToString:@"Delete All Data"]) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Delete All Data?" message:@"This will erase all locally stored events" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

        // Display Alert Message
        [messageAlert show];
    } else if ([name isEqualToString:@"???"]) {
        UIAlertView *messageAlert = [[UIAlertView alloc]
                                     initWithTitle:@"BOO!" message:@"Did I scare you?" delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:nil];

        // Display Alert Message
        [messageAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"]) {
        // Delete ALL the events!
        [self.eventsController deleteAllEvents];
    }
}

- (GidrEventsController *)eventsController
{
    if (_eventsController != nil) {
        return _eventsController;
    }
    self.eventsController = [[GidrEventsController alloc] init];
    return _eventsController;
}

@end
