//
//  GidrSearchViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GidrSearchViewController : UIViewController <UITextFieldDelegate>{
    NSString *searchString;
}


@property (nonatomic, retain) NSString *searchString;

- (IBAction)searchButtonPressed:(UIButton *)sender;

@end
