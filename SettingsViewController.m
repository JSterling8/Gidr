//
//  SettingsViewController.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 14/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "SettingsViewController.h"
@interface SettingsViewController()
@property (weak, nonatomic) IBOutlet UISwitch *changeOption;
@property (weak, nonatomic) IBOutlet UIScrollView *settingsScrollView;

@end

@implementation SettingsViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _settingsScrollView.contentSize=CGSizeMake(0, 250);
    _settingsScrollView.contentInset=UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0);
    [_settingsScrollView setContentOffset:CGPointMake(0,250)];}



@end
