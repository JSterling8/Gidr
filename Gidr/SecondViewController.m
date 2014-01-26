//
//  SecondViewController.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 13/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myEventsScrollView;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"My Events";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _myEventsScrollView.contentSize=CGSizeMake(0, 560);
    _myEventsScrollView.contentInset=UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0);
    [_myEventsScrollView setContentOffset:CGPointMake(0,-64)];
}



@end
