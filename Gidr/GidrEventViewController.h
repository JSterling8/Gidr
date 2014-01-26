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

@interface GidrEventViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, weak) id refreshController;
@property (nonatomic, strong) NSDate* lastUpdate;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end
