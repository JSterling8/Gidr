//
//  GidrSettingsViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 27/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GidrEventsController.h"

@interface GidrSettingsViewController : UITableViewController

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *rows;
@property (strong, nonatomic) GidrEventsController *eventsController;

@end
