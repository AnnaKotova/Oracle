//
//  From1to99Manager.h
//  Oracle
//
//  Created by Ann Kotova on 8/29/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern int const kEmptyCellIndicator;

extern NSString * const kPossibleStepCurrentLabelX;
extern NSString * const kPossibleStepCurrentLabelY;
extern NSString * const kPossibleStepPreviousLabelX;
extern NSString * const kPossibleStepPreviousLabelY;

typedef NS_ENUM(NSUInteger, MovingIndex)
{
    MovingIndexX,
    MovingIndexY
};

@interface From1to99Manager : NSObject

@property(readonly) NSUInteger cellAmountOnWidth;
@property(readonly) NSUInteger cellAmountOnHeigth;
@property NSMutableArray * numbersArray;
@property int currentStepNumber;

- (void)resetManager;
- (void)saveManagerState;
- (BOOL)successRestoreSavedState;

- (void)goToNextStep;
- (void)setPlayFieldSizeForLettersCount:(NSUInteger)lettercount dateOfBirthday:(NSDate *)date;
- (BOOL)checkAccordanceOfCellsWithIndexX:(int)currentIndexX
                                  indexY:(int)currentIndexY
                  previousSelectedIndexX:(int)previousSelectedIndexX
                  previousSelectedIndexY:(int)previousSelectedIndexY;
- (NSDictionary * )possibleStepIndexesDictionary;
- (NSInteger)sumLeftoverNumbers;

@end
