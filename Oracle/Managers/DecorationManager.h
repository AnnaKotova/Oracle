//
//  DecorationManager.h
//  Oracle
//
//  Created by Ann Kotova on 7/6/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import <UIKit/UIKit.h>

static UIFont * _InfoFont() { return [UIFont fontWithName:@"PFHellenicaSerifPro-Light" size:17]; }
static UIFont * _BoldFont() { return [UIFont fontWithName:@"PFHellenicaSerifPro-Bold" size:17]; }

@interface DecorationManager : NSObject

+ (DecorationManager *)sharedManager;

+ (UIFont *)mainFontWithSize:(CGFloat)size;
+ (UIColor *)mainTextColor;

@end
