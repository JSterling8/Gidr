//
//  GidrDiscoverLogic.m
//  Gidr
//
//  Created by Administrator on 12/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrDiscoverLogic.h"

@interface GidrDiscoverLogic ()
    
@property float total;

@end


@implementation GidrDiscoverLogic

@synthesize percentages;

- (void)calculateCategoryPercentages
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.percentages = [[NSMutableDictionary alloc]initWithCapacity:[self.categories count]];
    
    
    self.total = 0;
    
    for (NSString *category in [self categories]) {
        [self.percentages setObject:[NSNumber numberWithFloat:[userDefaults floatForKey:category]] forKey:category];
        self.total += [userDefaults floatForKey:category];
    }
 }

- (void)printPercentages {
    for(id key in percentages) {
        NSMutableString *string = (NSMutableString *)key;
        [string appendString:@": "];
        
        [string appendString:[NSString stringWithFormat:@"%@", [percentages objectForKey:key]]];
        NSString *immutableString = [NSString stringWithString:string];

    
        // NSLog(NSLog(@"%@", immutableString));
    }
}

- (NSMutableDictionary*)percentages{
    if (!percentages){
        percentages = [[NSMutableDictionary alloc]initWithCapacity:[self.categories count]];
    }
    
    return percentages;
}

- (NSArray *)categories
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



@end
