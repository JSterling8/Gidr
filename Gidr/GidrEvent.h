//
//  GidrEvent.h
//  Gidr
//
//  Created by Joseph Duffy on 12/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue;

@interface GidrEvent : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Venue *venue;

@end
