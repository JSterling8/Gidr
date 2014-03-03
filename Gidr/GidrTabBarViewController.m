//
//  GidrTabBarViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 02/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrTabBarViewController.h"

@interface GidrTabBarViewController ()

@end

@implementation GidrTabBarViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenSetup"]) {
        [self performSegueWithIdentifier:@"InitialSetupSegue" sender:self];
    }
}

@end
