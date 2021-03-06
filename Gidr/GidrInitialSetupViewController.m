//
//  GidrInitialSetupViewController.m
//  Gidr
//
//  Created by Joseph Duffy on 02/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrInitialSetupViewController.h"
#import "GidrUISlider.h"

@interface GidrInitialSetupViewController ()

- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic) BOOL hasFinishedSetup;

@property (nonatomic, strong) UILabel *welcomeLabel;

@property (nonatomic, strong) NSMutableDictionary *categorySliders;

@end

@implementation GidrInitialSetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat height = 0.0;
	// Do any additional setup after loading the view.
    self.hasFinishedSetup = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenSetup"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Create the scroll view
    CGFloat scrollViewHeight = self.view.frame.size.height - /* Device height */
                               self.navigationController.navigationBar.frame.size.height - /* Navigation var height */
                               [UIApplication sharedApplication].statusBarFrame.size.height; /* Status bar height */
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollViewHeight)];
    if (self.hasFinishedSetup) {
        self.title = @"Modify Interests";
        self.cancelButton.title = @"Save";
    } else {
        [self setInitialInterestValues];
        self.title = @"Welcome To Gidr";
        self.cancelButton.title = @"Done";
        self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        self.welcomeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.welcomeLabel.numberOfLines = 5;
        // This breaks things, but should help with dynamic text?
//        [self.welcomeLabel sizeToFit];
        self.welcomeLabel.text = @"Please set how strongly you are interested in the following categories. By default, they are all of equal importance.";
        self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:self.welcomeLabel];
        height += self.welcomeLabel.bounds.size.height;
    }
    UIButton *slidersToZeroButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    slidersToZeroButton.frame = CGRectMake(0, height+10, self.view.bounds.size.width, 20);
    [slidersToZeroButton setTitle:@"Reset All To Zero" forState:UIControlStateNormal];
    slidersToZeroButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [slidersToZeroButton addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:slidersToZeroButton];
    height += slidersToZeroButton.bounds.size.height;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *category in [[self class] categories]) {
        // Create the label for the slider
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height+20, self.view.bounds.size.width, 60)];
        label.text = category;
        [label setTextAlignment:NSTextAlignmentCenter];
        [scrollView addSubview:label];
        height += label.bounds.size.height;
        // Create the slider
        GidrUISlider *slider = [[GidrUISlider alloc] initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, 20)];
        // Set the maximum value first, or setting the value will mess it all up since the default maximum is 1.0
        slider.maximumValue = 100.0;
        // Set the value to the value stored in the user defaults
        slider.value = [userDefaults floatForKey:category];
        [self.categorySliders setObject:slider forKey:category];
        [scrollView addSubview:slider];
        height += slider.bounds.size.height;
    }
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    [self.view addSubview:scrollView];
}

- (void)resetButtonPressed
{
    [[[UIAlertView alloc] initWithTitle:@"Reset All To Zero?" message:@"This will move all the sliders to the left, giving each category a value of 0" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Reset all to zero
        for (NSString *category in [[self class] categories]) {
            ((UISlider *)[self.categorySliders objectForKey:category]).value = 0.0;
        }
    }
}

- (void)setInitialInterestValues
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *category in [[self class] categories]) {
        [userDefaults setFloat:50.0 forKey:category];
    }
    [userDefaults synchronize];
}

+ (NSArray *)categories
{
    return @[@"Business/Finance/Sales",
             @"Classes/Workshops",
             @"Comedy",
             @"Conferences/Seminars",
             @"Conventions/Tradeshows/Expos",
             @"Endurance",
             @"Festivals/Fairs",
             @"Food/Wine",
             @"Fundraising/Charities/Giving",
             @"Movies/Film",
             @"Music/Concerts",
             @"Networking/Clubs/Associations",
             @"Outdoors/Recreation",
             @"Performing Arts",
             @"Religion/Spirituality",
             @"Schools/Reunions/Alumni",
             @"Social Events/Mixers",
             @"Sports",
             @"Travel"];
}

- (NSMutableDictionary *)categorySliders
{
    if (_categorySliders == nil) {
        _categorySliders = [[NSMutableDictionary alloc] init];
    }
    return _categorySliders;
}

- (IBAction)cancelButtonAction:(UIBarButtonItem *)sender
{
    // Save the input values
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *category in [[self class] categories]) {
        [userDefaults setFloat:((UISlider *)[self.categorySliders objectForKey:category]).value forKey:category];
    }
    // Set the initial setup as completed
    [userDefaults setBool:YES forKey:@"hasSeenSetup"];
    [userDefaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
