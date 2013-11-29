//
//  FirstViewController.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 13/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *eventButtons;
@property (weak, nonatomic) IBOutlet UIScrollView *discoverScrollView;

@end

@implementation FirstViewController
- (IBAction)goToEvent:(UIButton *)sender {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     self.title = @"Discover";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _discoverScrollView.contentSize=CGSizeMake(0, 560);
    _discoverScrollView.contentInset=UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0);
    [_discoverScrollView setContentOffset:CGPointMake(0,-44)];
}



@end
