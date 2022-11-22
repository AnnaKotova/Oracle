//
//  NSFileManagerExtension.m
//  Oracle
//
//  Created by Ann Kotova on 12/7/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "NSFileManagerExtension.h"

@implementation NSFileManager (Directories)

/** Returns the path to the application's documents directory. */
+ (NSString *)_applicationDocumentsDirectory
{
    static dispatch_once_t onceToken;
    static NSString * basePath = nil;
    dispatch_once(&onceToken, ^
                  {
                      NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                      basePath = paths.firstObject;
                  });
    
    return basePath;
}

- (NSString *)applicationDocumentsDirectory
{
    return [[self class] _applicationDocumentsDirectory];
}

- (NSString *)imagesDirectory
{
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"images"];
}

@end
