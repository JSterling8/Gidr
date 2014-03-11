//
//  GidrEvent.h
//  Gidr
//
//  Created by Joseph Duffy on 28/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GidrEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * ebr;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * logo;
@property double lowerPrice;
@property double upperPrice;
@property (nonatomic, retain) NSString * url;
@end
