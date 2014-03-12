//
//  GidrEventsMapper.h
//  Gidr
//
//  Created by Joseph Duffy on 28/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GidrEvent.h"
#import <Parse/Parse.h>

@interface GidrEventsMapper : NSObject

- (GidrEvent *)addEvent:(PFObject *)event;

- (GidrEvent *)getEventWithId:(NSString *)id;

- (BOOL)updateEvent:(PFObject *)event;

- (BOOL)deleteEvent:(GidrEvent*)event;

@end
