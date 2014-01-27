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

@interface GidrEventViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, weak) id refreshController;
@property (nonatomic, strong) NSDate* lastUpdate;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIManagedDocument *document;

@end
