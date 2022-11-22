//
//  DecorationManager.h
//  Oracle
//
//  Created by Ann Kotova on 7/6/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorationManager : NSObject

+ (DecorationManager *)sharedManager;

+ (UIFont *)mainFontWithSize:(CGFloat)size;
+ (UIColor *)mainTextColor;

@end
