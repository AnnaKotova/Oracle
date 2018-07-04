//
//  AppearanceManager.h
//  1 to 99
//
//  Created by Anna Kotova on 7/27/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppearanceManager : NSObject

+ (AppearanceManager *)sharedManager;

+ (UIColor *)mainBackgroundColor;
+ (UIColor *)lightMainBackgroundColor;
+ (UIColor *)lightMainBackgroundColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)dackColor;
+ (UIColor *)firstColor;
+ (UIColor *)secondColor;

+ (UIColor *)cellEnableColor;

+ (UIFont *)appFontWithSize:(CGFloat)size;

- (UIFont *)appFont;

- (UIButton *)buttonWithTitle:(NSString *)title;
- (void)configInterfaceAppearance:(CGRect)frame;

//cells background colors
+ (UIColor *)cellBackgroundColorAtNormalState;
+ (UIColor *)cellBackgroundColorAtSelectedState;

@property (readonly) CGFloat buttonsWidth;
@property (readonly) CGFloat buttonsHeight;
@property (readonly) CGFloat smallButtonsWidth;
@property (readonly) CGFloat textFieldsHeight;
@property (readonly) CGFloat textFieldsWidth;

@end
