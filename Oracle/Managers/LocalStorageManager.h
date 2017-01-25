//
//  LocalStorageManager.h
//  Oracle
//
//  Created by Ann Kotova on 12/12/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LocalStorageManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;

+ (LocalStorageManager *)sharedManager;
- (void)saveContext;
- (void)removeObject:(NSManagedObject*)managedObject inContext:(NSManagedObjectContext*)context;

@end
