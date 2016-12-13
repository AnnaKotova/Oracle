//
//  History.m
//  Oracle
//
//  Created by Ann Kotova on 12/1/16.
//  Copyright © 2016 Bmuse. All rights reserved.
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

+ (instancetype)createNoteInHistory
{
    NSManagedObjectContext * context = [LocalStorageManager sharedManager].managedObjectContext;
    
    NSString * className = NSStringFromClass([self class]);
    History * instance = (History*)[NSEntityDescription insertNewObjectForEntityForName:className
                                                                 inManagedObjectContext:context];
    return instance;
}

@end

