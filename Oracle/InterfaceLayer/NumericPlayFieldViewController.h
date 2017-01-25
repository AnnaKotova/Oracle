//
//  NumericPlayFieldViewController.h
//  Oracle
//
//  Created by Ann Kotova on 1/12/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumericPlayFieldViewController;

@protocol NumericPlayFieldViewControllerDelegate <NSObject>

- (void)numericPlayFieldViewControllerSaveResultWithKey:(NSInteger)key;

@end

@interface NumericPlayFieldViewController : UIViewController

@property id<NumericPlayFieldViewControllerDelegate> delegate;

- (instancetype)initWithNameString:(NSString *)nameString dateOfBirthday:(NSDate *)date;

@end
