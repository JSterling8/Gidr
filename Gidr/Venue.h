//
//  Venue.h
//  Gidr
//
//  Created by Joseph Duffy on 12/03/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GidrEvent;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * county;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * postCode;
@property (nonatomic, retain) NSSet *events;
@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addEventsObject:(GidrEvent *)value;
- (void)removeEventsObject:(GidrEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
