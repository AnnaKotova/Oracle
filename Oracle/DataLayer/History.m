//
//  History.m
//  Oracle
//
//  Created by Ann Kotova on 12/1/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "History.h"
#import "LocalStorageManager.h"

@implementation History

@dynamic identifier;
@dynamic date;
@dynamic name;
@dynamic note;
@dynamic resultKey;
@dynamic imagePath;
@dynamic birthdayDate;

+ (instancetype)createNoteInHistory
{
    NSManagedObjectContext * context = [LocalStorageManager sharedManager].managedObjectContext;
    
    NSString * className = NSStringFromClass([self class]);
    History * instance = (History*)[NSEntityDescription insertNewObjectForEntityForName:className
                                                                 inManagedObjectContext:context];
    instance.identifier = [[NSUUID UUID] UUIDString];
    return instance;
}

+ (NSArray *)allHistory
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
//    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"url == %@",webURL.absoluteString];
//    [request setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * result = [[LocalStorageManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@"ERROR: %@", [error description]);
    }
    
    return result;
}
@end

