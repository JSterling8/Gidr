//
//  GidrInitialSetupViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 02/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GidrInitialSetupViewController : UIViewController <UIAlertViewDelegate>

/**
 Get all the categories for the user's personal interests
 @return An NSArray of all the categories options for the user to provide an interest level
 */
+ (NSArray *)categories;

- (void)resetButtonPressed;

@end

