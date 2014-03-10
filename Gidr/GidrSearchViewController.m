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
@property (nonatomic, strong) GidrEventsMapper *eventsMapper;


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
- (IBAction)buttonPush:(UIButton *)sender {
    _testLabel.text = _searchStringTF.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.searchStringTF.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchStringTF resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.searchString = [textField text];
    [self.searchStringTF resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonPressed:(UIButton *)sender {
    searchString = self.searchStringTF.text;
    [self.searchStringTF resignFirstResponder];
    [self performSegueWithIdentifier:@"SearchResultsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultsSegue"]) {
        GidrSearchResultsTableViewController *results = (GidrSearchResultsTableViewController *)segue.destinationViewController;
        results.searchString = self.searchString;
    }
}

- (GidrEventsMapper *)eventsMapper
{
    if (_eventsMapper == nil) {
        _eventsMapper = [[GidrEventsMapper alloc] init];
    }
    return _eventsMapper;
}


@end
