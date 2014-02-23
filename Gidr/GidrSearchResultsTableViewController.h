//
//  GidrSearchResultsTableViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GidrSearchResultsTableViewController : UITableViewController {
    NSString *searchString;
    UILabel *searchLabel;
}

@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) IBOutlet UILabel *searchLabel;

@end
