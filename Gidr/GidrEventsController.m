//
//  GidrEventsController.m
//  Gidr
//
//  Created by Joseph Duffy on 27/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrEventsController.h"

@implementation GidrEventsController

- (void)addEventWithId:(NSString*)id andName:(NSString*)name andLocation:(NSString*)location andDate:(NSDate*) date
{
    // Create a new managed object
    GidrEvent *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];
    [newEvent setValue:id forKey:@"id"];
    [newEvent setValue:name forKey:@"name"];
    [newEvent setValue:location forKey:@"location"];
    [newEvent setValue:date forKey:@"date"];

    NSError *error;
    // Save the object to persistent store
    if (![self.context save:&error]) {
        NSLog(@"Error adding event with name: %@: %@ %@", name, error, [error localizedDescription]);
    } else {
        NSLog(@"Added event with name: %@", name);
    }
}

- (GidrEvent*)getEventWithId:(NSString*)id
{
    // TODO: This should jsut fetch one results, not an array and then get the first result
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", id];
    NSArray *events = [self.context executeFetchRequest:fetchRequest error:nil];
    if (events.count == 1) {
        return [events objectAtIndex:0];
    } else {
        return nil;
    }
}

- (BOOL)updateEventWithId:(NSString*)id andName:(NSString*)name andLocation:(NSString*)location andDate:(NSDate*) date
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"any id = %@", id];
    NSArray *events = [self.context executeFetchRequest:fetchRequest error:nil];
    if (events.count == 1) {
        GidrEvent *event = [events objectAtIndex:0];
        event.name = name;
        event.location = location;
        event.date = date;
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Error updating event with name: %@: %@ %@", name, error, [error localizedDescription]);
            return false;
        } else {
            NSLog(@"Updated event with name: %@", name);
            return true;
        }
        return true;
    } else {
        return false;
    }
}

- (void)deleteEvent:(GidrEvent*)event
{
    NSString *name = event.name;
    [self.context deleteObject:event];

    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Error updating event with name: %@: %@ %@", name, error, [error localizedDescription]);
        return;
    } else {
        NSLog(@"Deleted event with name: %@", name);
    }
}

- (void)deleteAllEvents
{
    NSArray *events = [self.fetchedResultsController fetchedObjects];
    for (GidrEvent *event in events) {
        [self deleteEvent:event];
    }
    // Set the last update to never, since we now have no events! :(
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"lastUpdate"];
    [userDefaults synchronize];
}

- (id)objectAtIndexPath:indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

// Lazy Instantiations

- (NSManagedObjectContext *)context
{
    return [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] context];
    if (_context == nil) {
        _context = [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] context];
    }
    return _context;
}

- (NSFetchedResultsController *)fetchedResultsController {
    return [(GidrAppDelegate *)[[UIApplication sharedApplication] delegate] fetchedResultsController];
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                         ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:20];
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                         initWithFetchRequest:fetchRequest
                                         managedObjectContext:self.context
                                         sectionNameKeyPath:nil
                                         cacheName:@"Event"];
        _fetchedResultsController.delegate = self;
        NSError *error;
        [_fetchedResultsController performFetch:&error];

    }
    return _fetchedResultsController;
}

- (NSArray *)sections
{
    return [self.fetchedResultsController sections];
}

@end
