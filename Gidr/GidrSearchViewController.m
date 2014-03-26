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
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) GidrSearchParameters *searchParams;
@property (weak, nonatomic) IBOutlet UITextField *startDateTF;
@property (weak, nonatomic) IBOutlet UITextField *endDateTF;
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
@property (weak, nonatomic) IBOutlet UITextField *radiusTF;



@end

@implementation GidrSearchViewController

@synthesize searchString;
// @synthesize searchParams;
// @synthesize startDateTF;
// @synthesize endDateTF;
// @synthesize categoryTF;
// @synthesize priceTF;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (GidrSearchParameters *)searchParams{
    if (_searchParams == nil) {
        _searchParams = [[GidrSearchParameters alloc] init];
    }
    return _searchParams;
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
    
    self.searchStringTF.returnKeyType = UIReturnKeyDone;
    self.startDateTF.returnKeyType = UIReturnKeyDone;
    
    self.endDateTF.returnKeyType = UIReturnKeyDone;
    self.categoryTF.returnKeyType = UIReturnKeyDone;
    self.radiusTF.returnKeyType = UIReturnKeyDone;

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

- (IBAction)enterStartDate:(UITextField *) textField {
    [self dismissKeyboard];
    
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDate *currentDate = [NSDate date];
        NSDate *endDate = [NSDate distantFuture];
        NSDateComponents *comps = [[NSDateComponents alloc] init] ;
        [comps setYear:-0];
        NSDate *maximumDate = [calendar dateByAddingComponents:comps toDate:endDate options:0];
        [comps setYear:0];
        NSDate *minimumDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [datePicker setMaximumDate:maximumDate];
        [datePicker setMinimumDate:minimumDate];
        datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = datePicker;
    
    //[textField becomeFirstResponder];
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
    //if ([textField text ] == [self.startDateTF text] || [textField text] == [self.endDateTF text])
    // if (textField == self.startDateTF)
    /*{
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDate *currentDate = [NSDate date];
        NSDate *endDate = [NSDate distantFuture];
        NSDateComponents *comps = [[NSDateComponents alloc] init] ;
        [comps setYear:-0];
        NSDate *maximumDate = [calendar dateByAddingComponents:comps toDate:endDate options:0];
        [comps setYear:0];
        NSDate *minimumDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [datePicker setMaximumDate:maximumDate];
        [datePicker setMinimumDate:minimumDate];
        datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = datePicker;
    }*/
//}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultsSegue"]) {
        self.searchParams.searchTerms = [self.searchStringTF text];
        self.searchParams.startDate = [self.startDateTF text];
        self.searchParams.endDate = [self.endDateTF text];
        self.searchParams.category = [self.categoryTF text];
        //NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        //[f setNumberStyle:NSNumberFormatterDecimalStyle];
        //self.searchParams.price = [f numberFromString:[self.priceTF text]];
        
        GidrSearchResultsTableViewController *results = (GidrSearchResultsTableViewController *)segue.destinationViewController;
        results.searchParams = self.searchParams;
        results.searchString = self.searchString;

    }
}
@end
