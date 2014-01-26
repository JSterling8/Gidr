//
//  EventViewController.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 13/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *eventScrollView;

@end

@implementation EventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _eventScrollView.contentSize=CGSizeMake(0, 460);
    _eventScrollView.contentInset=UIEdgeInsetsMake(64.0, 0.0, 44.0, 0.0);
    [_eventScrollView setContentOffset:CGPointMake(0,0)];}

- (IBAction)attending:(UIButton *)sender {
    sender.highlighted = YES;
}
@end
