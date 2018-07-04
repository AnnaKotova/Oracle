//
//  AppearanceManager.m
//  1 to 99
//
//  Created by Anna Kotova on 7/27/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

//colors hex http://color.romanuke.com/tsvetovaya-palitra-2154/
//#193f6e dark  [UIColor colorWithRed:25.0f/255.0f green:63.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
//#3b6ba5 firstColor [UIColor colorWithRed:59.0f/255.0f green:107.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
//#72a5d3 secondColor [UIColor colorWithRed:114.0f/255.0f green:165.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
//#b1d3e3 lightMainBackgroundColor [UIColor colorWithRed:177.0f/255.0f green:211.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
//#e1ebec mainBackgroundColor [UIColor colorWithRed:225.0f/255.0f green:235.0f/255.0f blue:236.0f/255.0f alpha:1.0f];


#import <UIKit/UIKit.h>
#import "AppearanceManager.h"

@implementation AppearanceManager
{
    CGFloat _fontSize;
}

+ (AppearanceManager *)sharedManager
{
    static AppearanceManager * sharedAppearanceManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedAppearanceManager = [AppearanceManager new];
    });
    return sharedAppearanceManager;
}

+ (UIColor *)mainBackgroundColor
{
    return [UIColor colorWithRed:225.0f/255.0f green:235.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
}

+ (UIColor *)lightMainBackgroundColor
{
    return [[self class] lightMainBackgroundColorWithAlpha:1.0f];
}

+ (UIColor *)lightMainBackgroundColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:177.0f/255.0f green:211.0f/255.0f blue:227.0f/255.0f alpha:alpha];
}

+ (UIColor *)dackColor
{
    return [UIColor colorWithRed:25.0f/255.0f green:63.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
}

+ (UIColor *)secondColor
{
    return [UIColor colorWithRed:114.0f/255.0f green:165.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
}

+ (UIColor *)firstColor
{
    return [UIColor colorWithRed:59.0f/255.0f green:107.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
}

+ (UIColor *)cellEnableColor
{
    return [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
}

- (UIFont *)appFont
{
    if (!_fontSize)
    {
        _fontSize = 18.0f;
    }
    return [[self class] appFontWithSize:_fontSize];
}

+ (UIFont *)appFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"PFHellenicaSerifPro-Bold" size:size];//ChalkboardSE-Regular //AppleSDGothicNeo-SemiBold
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[AppearanceManager mainBackgroundColor] forState:UIControlStateNormal];
    button.titleLabel.font = [self appFont];
    [button setBackgroundColor:[[self class] dackColor]];
    button.layer.cornerRadius = 5;
    return button;
}

- (void)configInterfaceAppearance:(CGRect)frame
{
    CGFloat selfWidth = CGRectGetWidth(frame);
    CGFloat selfHeight = CGRectGetHeight(frame);
    
    CGFloat smallerSide;
    CGFloat biggestSide;
    if (selfWidth > selfHeight) //landscape
    {
        smallerSide = selfHeight;
        biggestSide = selfWidth;
    }
    else
    {
        smallerSide = selfWidth;
        biggestSide = selfHeight;
    }
    
    CGFloat buttonsWidth = biggestSide * 0.22;
    CGFloat textFieldsHeight = smallerSide * 0.08;//biggestSide * 0.07;
    CGFloat textFieldsWidth = biggestSide * 3 / 4;
    CGFloat fontSize = (textFieldsHeight * 0.4 > 24 ? 24 : textFieldsHeight * 0.4);
    
    _buttonsWidth = buttonsWidth;
    _buttonsHeight = (textFieldsHeight > 60 ? 60 : textFieldsHeight);
    _textFieldsWidth = textFieldsWidth;
    _textFieldsHeight = textFieldsHeight;
    _fontSize = fontSize;
    _smallButtonsWidth = smallerSide * 0.3;
}

+ (UIColor *)cellBackgroundColorAtNormalState
{
    return [[self class] lightMainBackgroundColor];
}

+ (UIColor *)cellBackgroundColorAtSelectedState
{
    return [[self class] firstColor];
}
@end
