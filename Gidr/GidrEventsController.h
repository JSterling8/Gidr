//
//  GidrEventsController.h
//  Gidr
//
//  Created by Joseph Duffy on 27/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GidrEvent.h"
#import <CoreData/CoreData.h>
#import "GidrAppDelegate.h"

@interface GidrEventsController : NSObject <NSFetchedResultsControllerDelegate>

- (void)addEventWithId:(NSString*)id andName:(NSString*)name andLocation:(NSString*)location andDate:(NSDate*) date;
- (GidrEvent*)getEventWithId:(NSString*)id;
- (BOOL)updateEventWithId:(NSString*)id andName:(NSString*)name andLocation:(NSString*)location andDate:(NSDate*) date;
- (void)deleteEvent:(GidrEvent*)event;
- (void)deleteAllEvents;
- (NSArray *)sections;
- (id)objectAtIndexPath:indexPath;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
