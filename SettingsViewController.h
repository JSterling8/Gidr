//
//  SettingsViewController.h
//  Gidr
//
//  Created by J.Sterling U1276062 on 14/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsViewController : UIViewController
@property BOOL checkbox;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkboxes;
- (IBAction)boxChecked:(UIButton *)sender;

@end
