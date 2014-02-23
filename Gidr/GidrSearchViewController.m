//
//  GidrSearchViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrSearchViewController.h"
#import "GidrSearchResultsTableViewController.h"

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
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonPressed:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"SearchResultsSegue" sender:self];
    
    
    GidrSearchResultsTableViewController *tempView = [[GidrSearchResultsTableViewController alloc] init];
    [tempView setSearchString:self.searchString];
    
    [self.navigationController pushViewController:tempView animated:YES];
    
}



@end
