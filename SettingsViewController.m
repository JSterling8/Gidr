//
//  SettingsViewController.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 14/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (IBAction)boxChecked:(id)sender {
    
    if (!_checkbox) {
        [sender setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        _checkbox = YES;
    }
    
    else if (_checkbox) {
        [sender setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        _checkbox = NO;
    }
    
}
@end
