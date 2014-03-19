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
@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *DescriptionText;
@property (weak, nonatomic) IBOutlet UILabel *StartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *EndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *StartDLabel;
@property (weak, nonatomic) IBOutlet UILabel *EndDLabel;
@property (weak, nonatomic) IBOutlet UITextView *URLLabel;
@property (weak, nonatomic) IBOutlet UILabel *VenueLabel;
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
    [self.CategoryLabel setText:self.event.category];
    [self.DescriptionText setText:self.event.descriptionText];
    [self.VenueLabel setText:self.event.venue.name];
    
    NSString *newCountryString =[self.event.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.URLLabel setText:newCountryString];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    
    NSString *stringFromStartDate = [formatter stringFromDate:self.event.startDate];
    
    NSString *stringFromEndDate = [formatter stringFromDate:self.event.endDate];

    [self.StartDLabel setText:stringFromStartDate];
    [self.EndDLabel setText:stringFromEndDate];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(methodThatShowsSheet)];
    
    self.navigationItem.rightBarButtonItem = actionButton;
	// Do any additional setup after loading the view.
}

- (void)methodThatShowsSheet
{
    NSArray *itemsToShare = @[@"Check out this awesome event I found!", [NSURL URLWithString:self.event.url]];
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
