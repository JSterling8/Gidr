//
//  GidrEventsMapper.m
//  Gidr
//
//  Created by Joseph Duffy on 28/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrEventsMapper.h"
#import "GidrAppDelegate.h"

@interface GidrEventsMapper ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation GidrEventsMapper

/**
 Adds a new event to the Core Data store
 @param id The unique id for the new event
 @param name The display name for the event
 @param location The location for the event
 @param date The date of the event
 @return The newly created GidrEvent object, or nil if the event failed to be created
 */
- (GidrEvent *)addEventWithId:(NSString*)id name:(NSString*)name location:(NSString*)location date:(NSDate*)date
{
    // Create a new managed object
    GidrEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    newEvent.id = id;
    newEvent.name = name;
    newEvent.location = location;
    newEvent.date = date;

    NSError *error;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error adding event named \"%@\": %@ %@", name, error, [error localizedDescription]);
        return nil;
    }
    return newEvent;
}

/**
 Get the event from the Core Data store that has the provided id
 @param id The ID of the event to retrieve
 @return The event object retrieved from Core Data, or nil if no event in found with the provided id
 */
- (GidrEvent*)getEventWithId:(NSString*)id
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", id];
    NSArray *events = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    assert(events.count < 2);
    // Using last object will return either:
    // 1. The event in the array; or
    // 2. nil, if no events were found
    return [events lastObject];
}

/**
 Update an event in the Core Data store
 @param id The unique ID of the event to update
 @param name The new name for the event
 @param location The new location for the event
 @param date The new data for the event
 @return YES on success, otherwise NO
 */
- (BOOL)updateEventWithId:(NSString*)id name:(NSString*)name location:(NSString*)location date:(NSDate*)date;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", id];
    NSArray *events = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if (events.count == 1) {
        GidrEvent *event = [events objectAtIndex:0];
        event.name = name;
        event.location = location;
        event.date = date;
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error updating event with name: %@: %@ %@", name, error, [error localizedDescription]);
            return false;
        }
        return true;
    } else {
        return false;
    }
}

/**
 Delete the provided event from the Core Data store
 @param event The event to be deleted
 @return YES on success, otherwise NO
 */
- (BOOL)deleteEvent:(GidrEvent*)event
{
    NSString *name = event.name;
    [self.managedObjectContext deleteObject:event];

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error updating event with name: %@: %@ %@", name, error, [error localizedDescription]);
        return NO;
    }
    return YES;
}

/**
 Get the managed object context from the app delegate
 @return The managed object context
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = ((GidrAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return _managedObjectContext;
}

@end