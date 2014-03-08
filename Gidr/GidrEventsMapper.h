//
//  GidrEventsMapper.h
//  Gidr
//
//  Created by Joseph Duffy on 28/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GidrEvent.h"

@interface GidrEventsMapper : NSObject

- (GidrEvent *)addEventWithId:(NSString*)id name:(NSString*)name location:(NSString*)location date:(NSDate*)date;

- (GidrEvent *)getEventWithId:(NSString *)id;

- (BOOL)updateEventWithId:(NSString*)id name:(NSString*)name location:(NSString*)location date:(NSDate*)date;

- (BOOL)deleteEvent:(GidrEvent*)event;

@end
