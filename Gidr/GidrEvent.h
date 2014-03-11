//
//  GidrEvent.h
//  Gidr
//
//  Created by Administrator on 11/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GidrEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * lowerPrice;
@property (nonatomic, retain) NSNumber * upperPrice;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * ebr;
@property (nonatomic, retain) NSString * category;

@end
