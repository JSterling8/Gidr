//
//  GidrSearchViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrSearchViewController.h"
#import "GidrSearchResultsTableViewController.h"
#import "GidrEventsMapper.h"

@interface GidrSearchViewController ()

@property (strong, nonatomic) IBOutlet UITextField *searchStringTF;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;


@end

@implementation GidrSearchViewController

@synthesize searchString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonPush:(UIButton *)sender
{
    _testLabel.text = _searchStringTF.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.searchStringTF.delegate = self;
    // Create the gesture recognizer for dismissing the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.searchString = [textField text];
    [self dismissKeyboard];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonPressed:(UIButton *)sender
{
    self.searchString = self.searchStringTF.text;
    [self dismissKeyboard];
    [self performSegueWithIdentifier:@"SearchResultsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultsSegue"]) {
        GidrSearchResultsTableViewController *results = (GidrSearchResultsTableViewController *)segue.destinationViewController;
        results.searchString = self.searchString;
    }
}
@end
