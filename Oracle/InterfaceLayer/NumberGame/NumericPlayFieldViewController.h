//
//  NumericPlayFieldViewController.h
//  Oracle
//
//  Created by Ann Kotova on 1/12/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class NumericPlayFieldViewController;

@protocol NumericPlayFieldViewControllerDelegate <NSObject>

- (void)numericPlayFieldViewControllerSaveResultWithKey:(NSInteger)key;

@end

@interface NumericPlayFieldViewController : BaseViewController

@property id<NumericPlayFieldViewControllerDelegate> delegate;
@property (assign) BOOL needToSaveManagerState;

- (instancetype)initWithNameString:(NSString *)nameString dateOfBirthday:(NSDate *)date;
- (void)saveManagerStateIdNeeded;

@end
