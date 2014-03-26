//
//  GidrDiscoverLogic.h
//  Gidr
//
//  Created by Administrator on 12/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GidrDiscoverLogic : NSObject

@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSMutableDictionary* percentages;

-(NSDictionary *)calculateCategoryPercentages;

@end
