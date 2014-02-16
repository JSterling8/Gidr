//
//  GidrEventViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 26/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GidrEvent.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "GidrAppDelegate.h"

@interface GidrDiscoverViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
