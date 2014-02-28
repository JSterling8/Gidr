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

/**
 Adds a new event to the Core Data store
 @param id The unique id for the new event
 @param name The display name for the event
 @param location The location for the event
 @param date The date of the event
 @return The newly created GidrEvent object, or nil if the event failed to be created
 */
- (GidrEvent *)addEventWithId:(NSString*)id name:(NSString*)name location:(NSString*)location date:(NSDate*)date;

/**
 Get the event from the Core Data store that has the provided id
 @param id The ID of the event to retrieve
 @return The event object retrieved from Core Data, or nil if no event in found with the provided id
 */
- (GidrEvent *)getEventWithId:(NSString *)id;

/**
 Update an event in the Core Data store
 @param id The unique ID of the event to update
 @param name The new name for the event
 @param location The new location for the event
 @param date The new data for the event
 @return YES on success, otherwise NO
 */
- (BOOL)updateEventWithId:(NSString*)id name:(NSString*)name location:(NSString*)location date:(NSDate*)date;

/**
 Delete the provided event from the Core Data store
 @param event The event to be deleted
 @return YES on success, otherwise NO
 */
- (BOOL)deleteEvent:(GidrEvent*)event;

@end
