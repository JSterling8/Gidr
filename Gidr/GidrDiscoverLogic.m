//
//  GidrDiscoverLogic.m
//  Gidr
//
//  Created by Administrator on 12/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrDiscoverLogic.h"
#import "GidrInitialSetupViewController.h"

@interface GidrDiscoverLogic ()
    
@property float total;

@end


@implementation GidrDiscoverLogic

- (NSDictionary *)calculateCategoryPercentages
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.percentages = [[NSMutableDictionary alloc]initWithCapacity:[self.categories count]];
    
    
    self.total = 0;
    
    for (NSString *category in [self categories]) {
        [self.percentages setObject:[NSNumber numberWithFloat:[userDefaults floatForKey:category]] forKey:category];
        self.total += [userDefaults floatForKey:category];
    }

    NSMutableDictionary *tempPerentages = [[NSMutableDictionary alloc] init];
    for (NSString *category in self.percentages) {
        float temp = [(NSNumber *)[self.percentages objectForKey:category] floatValue]/self.total;
        [tempPerentages setObject:[NSNumber numberWithFloat:temp] forKey:category];
    }
    self.percentages = tempPerentages;
    return self.percentages;
}

- (NSMutableDictionary *)percentages
{
    if (!_percentages) {
        _percentages = [[NSMutableDictionary alloc]initWithCapacity:[self.categories count]];
    }
    
    return _percentages;
}

- (NSArray *)categories
{
    return [GidrInitialSetupViewController categories];
}



@end
