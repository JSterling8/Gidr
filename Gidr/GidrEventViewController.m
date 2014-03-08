//
//  GidrEventViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 28/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrEventViewController.h"

@interface GidrEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

@implementation GidrEventViewController

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
    [self.eventNameLabel setText:self.event.name];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(methodThatShowsSheet)];
    self.navigationItem.rightBarButtonItem = actionButton;
	// Do any additional setup after loading the view.
}

- (void)methodThatShowsSheet
{
    NSArray *itemsToShare = @[@"Check out this awesome event I found!", [NSURL URLWithString:@"http://placeholder.url"]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
