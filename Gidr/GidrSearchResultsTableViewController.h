//
//  GidrSearchResultsTableViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Developed by Jonathan Sterling 09/02/2014 to date.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GidrEvent.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "GidrAppDelegate.h"

@interface GidrSearchResultsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
  
    NSString *searchString;
    UILabel *searchLabel;
}

@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) IBOutlet UILabel *searchLabel;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
