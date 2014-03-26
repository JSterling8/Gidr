//
//  GidrSearchViewController.h
//  Gidr
//
//  Created by Joseph Duffy on 09/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GidrSearchParameters.h"

@interface GidrSearchViewController : UIViewController <UITextFieldDelegate>{
    NSString *searchString;
}

- (IBAction)searchButtonPressed:(UIButton *)sender;

@end
