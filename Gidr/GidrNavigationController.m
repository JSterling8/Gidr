//
//  GidrNavigationController.m
//  Gidr
//
//  Created by Joseph Duffy on 16/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrNavigationController.h"

@implementation GidrNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    UIColor *blueColor = [UIColor colorWithRed:52.0/255.0 green:79.0/255.0 blue:180.0/255.0 alpha:1.0];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0+
        // This will set the navigation and top bar to be the same colour and be all iOS7-y
        // Reference: http://stackoverflow.com/a/19029973/657676
        // Set the tint to be blue
        self.navigationBar.barTintColor = blueColor;
        // Set the back arrows to be white
        //TODO: Make this non-white
        self.navigationBar.tintColor = [UIColor whiteColor];
        // Set the bar to be translucent
        self.navigationBar.translucent = YES;
        // Set the title text to be white
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        // Tell the system to check for the required status bar style
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        // iOS < 7.0
        // Just sets the navigation bar, which we might not want to do?
        self.navigationBar.tintColor = blueColor;
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
