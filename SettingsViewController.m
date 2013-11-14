//
//  SettingsViewController.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 14/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    checked = NO;
}
- (IBAction)checkTheBox:(id)sender {
    
    if (!checked) {
        [sender setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    
    else if (checked) {
        [sender setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
    
}

@end
