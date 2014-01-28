//
//  GidrAppDelegate.h
//  Gidr
//
//  Created by Joseph Duffy on 26/01/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GidrAppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate> {
    NSManagedObjectModel *managedObjectModel;
//    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIViewController *ViewController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSString *)applicationDocumentsDirectory;

@end
