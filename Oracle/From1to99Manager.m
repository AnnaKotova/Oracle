//
//  From1to99Manager.m
//  Oracle
//
//  Created by Ann Kotova on 8/29/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import "From1to99Manager.h"

int const kEmptyCellIndicator = -1;
NSString * const kPossibleStepCurrentLabelX = @"currentLabelХ";
NSString * const kPossibleStepCurrentLabelY = @"currentLabelY";
NSString * const kPossibleStepPreviousLabelX = @"previousLabelХ";
NSString * const kPossibleStepPreviousLabelY = @"previousLabelY";

@implementation From1to99Manager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _numbersArray = [NSMutableArray array];
    }
    return self;
}

- (void)setPlayFieldSizeLetterCount:(NSUInteger)lettercount
{
    _cellAmountOnWidth = lettercount;
    
    //countOfNumbers = 9 + 9 * (9 * 2 + 1); // 1 to 99 without 0
    float countOfNumbers = 9 + 5 * (9 * 2 + 1); // 1 to 59 without 0
    float width = _cellAmountOnWidth;
    _cellAmountOnHeigth = ceil(countOfNumbers / width);
    
    [self _createNumbersArray];
}

- (BOOL)checkAccordanceOfCellsWithIndexX:(int)currentIndexX
                                  indexY:(int)currentIndexY
                  previousSelectedIndexX:(int)previousSelectedIndexX
                  previousSelectedIndexY:(int)previousSelectedIndexY
{
    BOOL cellCompliesCondition = NO;
    
    NSNumber * previousNumber = _numbersArray[previousSelectedIndexY][previousSelectedIndexX];
    NSNumber * currentNumber = _numbersArray[currentIndexY][currentIndexX];
    
    int movingPreviousIndex;
    int movingCurrentIndex;
    MovingIndex movingIndex;
    
    if (currentIndexX == previousSelectedIndexX)
    {
        movingPreviousIndex = previousSelectedIndexY;
        movingCurrentIndex = currentIndexY;
        movingIndex = MovingIndexY;
    }
    else if (currentIndexY == previousSelectedIndexY)
    {
        movingPreviousIndex = previousSelectedIndexX;
        movingCurrentIndex = currentIndexX;
        movingIndex = MovingIndexX;
    }
    else
    {
        return cellCompliesCondition;
    }
    
    int step = (movingPreviousIndex - movingCurrentIndex) > 0 ? 1 : -1;
    int index = movingCurrentIndex;
    
    while(index != movingPreviousIndex)
    {
        index = index + step;
        if(index == movingPreviousIndex)
        {
            cellCompliesCondition = ((previousNumber.intValue == currentNumber.intValue)
                                     || ((previousNumber.intValue + currentNumber.intValue) == 10));
            if (cellCompliesCondition)
            {
                _numbersArray[previousSelectedIndexY][previousSelectedIndexX] = @(kEmptyCellIndicator);
                _numbersArray[currentIndexY][currentIndexX] = @(kEmptyCellIndicator);
            }
        }
        else
        {
            NSNumber * tempNumber;
            switch (movingIndex)
            {
                case MovingIndexX:
                    tempNumber = _numbersArray[currentIndexY][index];
                    break;
                case MovingIndexY:
                    tempNumber = _numbersArray[index][currentIndexX];
                    break;
            }
            
            if (tempNumber.intValue != kEmptyCellIndicator) break;
        }
    }
    
    return cellCompliesCondition;
}

- (NSDictionary * )possibleStepIndexesDictionary
{
    NSDictionary * indexesDictionaryForPossibleStep;
    int i = 0;
    int j = 1;
    BOOL findPossibleStep = NO;
    //NSLog(@"_manager.cellAmountOnHeigth = %i, _manager.cellAmountOnWidth = %i", _manager.cellAmountOnHeigth, _manager.cellAmountOnWidth);
    /// move on row
    while(i < _cellAmountOnHeigth)
    {
        j = 1;
        while (j < _cellAmountOnWidth)
        {
            indexesDictionaryForPossibleStep = [self _indexesDictionaryForPossibleStepForIndexX:i indexY:j movingIndex:MovingIndexX];
            findPossibleStep = (indexesDictionaryForPossibleStep.count > 0);
            if(findPossibleStep)
            {
                break;
            }
            
            j++;
        }
        if (findPossibleStep)
        {
            break;
        }
        i++;
    }
    
    if (findPossibleStep)
    {
        return indexesDictionaryForPossibleStep;
    }
    
    /// move on colume
    i = 1;
    while(i < _cellAmountOnHeigth)
    {
        j = 0;
        while (j < _cellAmountOnWidth)
        {
            indexesDictionaryForPossibleStep = [self _indexesDictionaryForPossibleStepForIndexX:i indexY:j movingIndex:MovingIndexY];
            findPossibleStep = (indexesDictionaryForPossibleStep.count > 0);

            if(findPossibleStep)
            {
                break;
            }
            j++;
        }
        if (findPossibleStep)
        {
            break;
        }
        i++;
    }
    return indexesDictionaryForPossibleStep;
}

- (NSInteger)sumLeftoverNumbers
{
    __block NSInteger sum = 0;
    [_numbersArray enumerateObjectsUsingBlock:^(NSArray  *_Nonnull numberArray, NSUInteger idx, BOOL * _Nonnull stop) {
       // NSLog(@"%@", obj);
         [numberArray enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
             if (number.intValue != kEmptyCellIndicator)
             {
                 sum += number.intValue;
             }
         }];
    }];
    return sum;
}

#pragma mark - private methods
- (void)_createNumbersArray
{
    [_numbersArray removeAllObjects];
    int counter = 1;
    int maxCounter = 60;//100
    int tempNumber = 0;
    
    for (int j = 0; j < _cellAmountOnHeigth; j++)
    {
        _numbersArray[j] = [NSMutableArray array];
        for (int i = 0; i < _cellAmountOnWidth; i++)
        {
            if (counter == maxCounter)
            {
                _numbersArray[j][i] = @(kEmptyCellIndicator);
            }
            else
            {
                int currentNumber = tempNumber;
                
                if (currentNumber > 0)
                {
                    tempNumber = 0;
                }
                else
                {
                    currentNumber = counter;
                    CGFloat tens = currentNumber / 10;
                    if (tens > 0)
                    {
                        currentNumber = tens;
                        tempNumber = counter % 10;
                    }
                }
                
                _numbersArray[j][i] = [NSNumber numberWithInt:currentNumber];
                
                if (tempNumber == 0)
                {
                    counter++;
                }
            }
        }
        
        //        if (counter == 100)
        //        {
        //            break;
        //        }
    }
}

- (NSDictionary *)_indexesDictionaryForPossibleStepForIndexX:(int)i indexY:(int)j movingIndex:(MovingIndex)movingIndex
{
    BOOL findPossibleStep = NO;
    NSMutableDictionary * indexesDictionary = [NSMutableDictionary dictionary];
    
    NSNumber * currentNumber = _numbersArray[i][j];
    
    if (currentNumber.intValue != kEmptyCellIndicator)
    {
        int previousIndex;
        NSNumber * previousNumber;
        
        switch (movingIndex)
        {
            case MovingIndexX: /// move on row
            {
                previousIndex = j - 1;
                previousNumber = _numbersArray[i][previousIndex];
            }
                break;
            case MovingIndexY: /// move on colume
            {
                previousIndex = i - 1;
                previousNumber = _numbersArray[previousIndex][j];
            }
                break;
        }
        
        /// find not empty cell
        while(previousIndex > 0)
        {
            if (previousNumber.intValue == kEmptyCellIndicator)
            {
                previousIndex--;
                switch (movingIndex)
                {
                    case MovingIndexX: /// move on row
                    {
                        previousNumber = _numbersArray[i][previousIndex];
                    }
                        break;
                    case MovingIndexY: /// move on colume
                    {
                        previousNumber = _numbersArray[previousIndex][j];
                    }
                        break;
                }
            }
            else
            {
                break;
            }
        }
        
        if ((currentNumber == previousNumber || currentNumber.intValue + previousNumber.intValue == 10) && currentNumber.intValue != kEmptyCellIndicator)
        {
            [indexesDictionary setObject:[NSNumber numberWithInt:i] forKey:kPossibleStepCurrentLabelX];
            [indexesDictionary setObject:[NSNumber numberWithInt:j] forKey:kPossibleStepCurrentLabelY];
            
            switch (movingIndex)
            {
                case MovingIndexX: /// move on row
                {
                    [indexesDictionary setObject:[NSNumber numberWithInt:i] forKey:kPossibleStepPreviousLabelX];
                    [indexesDictionary setObject:[NSNumber numberWithInt:previousIndex] forKey:kPossibleStepPreviousLabelY];
                }
                    break;
                case MovingIndexY: /// move on colume
                {
                    [indexesDictionary setObject:[NSNumber numberWithInt:previousIndex] forKey:kPossibleStepPreviousLabelX];
                    [indexesDictionary setObject:[NSNumber numberWithInt:j] forKey:kPossibleStepPreviousLabelY];
                }
                    break;
            }
            
            findPossibleStep = YES;
        }
    }
    return indexesDictionary;
}

@end
