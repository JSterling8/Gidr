//
//  GidrSearchParameters.h
//  Gidr
//
//  Created by Administrator on 18/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GidrSearchParameters : NSObject

@property (nonatomic, retain) NSString *searchTerms;
@property (nonatomic, retain) NSString *date;
@property NSNumber *price;
@property (nonatomic, retain) NSString *category;

@end
