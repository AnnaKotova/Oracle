//
//  NSStringExtension.m
//  Oracle
//
//  Created by Ann Kotova on 12/7/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "NSStringExtension.h"

@implementation NSString (NSStringExtension)

+ (NSString *)UUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    NSString * uuidString = CFBridgingRelease(CFUUIDCreateString(NULL, uuidRef));
    CFRelease(uuidRef);
    return uuidString;
}

@end
