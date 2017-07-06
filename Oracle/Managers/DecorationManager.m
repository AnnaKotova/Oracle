//
//  DecorationManager.m
//  Oracle
//
//  Created by Ann Kotova on 7/6/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "DecorationManager.h"

@implementation DecorationManager

+ (DecorationManager *)sharedManager
{
    static DecorationManager * decorationManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        decorationManager = [[DecorationManager alloc] init];
    });
    return decorationManager;
}

+ (UIFont *)mainFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PFHellenicaSerifPro-Bold" size:size];
}

+ (UIColor *)mainTextColor
{
    return [UIColor whiteColor];
}
@end
