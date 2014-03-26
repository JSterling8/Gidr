//
//  GidrEventsMapper.m
//  Gidr
//
//  Created by Joseph Duffy on 28/02/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrEventsMapper.h"
#import "GidrAppDelegate.h"
#import "Venue.h"

@interface GidrEventsMapper ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation GidrEventsMapper

- (GidrEvent *)addEvent:(PFObject *)event
{
    // Create a new managed object
    GidrEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    newEvent.id = event.objectId;
    newEvent.name = event[@"name"];
    newEvent.startDate = event[@"startDate"];
    newEvent.endDate = event[@"endDate"];
    newEvent.category = event[@"category"];
    newEvent.descriptionText = event[@"description"];
    if (event[@"logo"] != [NSNull null]) {
        newEvent.logo = event[@"logo"];
    }
    if (event[@"url"] != [NSNull null]) {
        newEvent.url = event[@"url"];
    }
    PFObject* venue = event[@"Venue"];
    [venue fetchIfNeeded];
    Venue *newVenue = [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
    newVenue.name = venue[@"name"];
    newVenue.line1 = venue[@"line1"];
    newVenue.line2 = venue[@"line2"];
    newVenue.city = venue[@"city"];
    newVenue.county = venue[@"county"];
    newVenue.country = venue[@"country"];
    newVenue.postCode = venue[@"postCode"];
    newEvent.venue = newVenue;
    NSError *error;
    // Save the object to persistent store
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        return newEvent;
    }
    return nil;
}

- (GidrEvent*)getEventWithId:(NSString*)id
{
    // TODO: This should just fetch one results, not an array and then get the first result
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    NSArray *events = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if (events.count == 1) {
        return [events objectAtIndex:0];
    } else {
        return nil;
    }
}

- (BOOL)updateEvent:(PFObject *)event
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", event.objectId];
    NSArray *events = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    assert(events.count == 1);
    GidrEvent *updatedEvent = [events objectAtIndex:0];
    updatedEvent.id = event.objectId;
    updatedEvent.name = event[@"name"];
    updatedEvent.startDate = event[@"startDate"];
    updatedEvent.endDate = event[@"endDate"];
    updatedEvent.category = event[@"category"];
    updatedEvent.descriptionText = event[@"description"];
    if (event[@"logo"] != [NSNull null]) {
        updatedEvent.logo = event[@"logo"];
    }
    if (event[@"url"] != [NSNull null]) {
        updatedEvent.url = event[@"url"];
    }
    PFObject* venue = event[@"Venue"];
    [venue fetchIfNeeded];
    Venue *updatedVenue = updatedEvent.venue;
    updatedVenue.name = venue[@"name"];
    updatedVenue.line1 = venue[@"line1"];
    updatedVenue.line2 = venue[@"line2"];
    updatedVenue.city = venue[@"city"];
    updatedVenue.county = venue[@"county"];
    updatedVenue.country = venue[@"country"];
    updatedVenue.postCode = venue[@"postCode"];
    updatedEvent.venue = updatedVenue;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Update event with name: %@: %@ %@", event[@"name"], error, [error localizedDescription]);
    } else {
        return YES;
    }
    return NO;
}

- (BOOL)deleteEvent:(GidrEvent *)event
{
    [self.managedObjectContext deleteObject:event];

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
    } else {
        return YES;
    }
    return NO;
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