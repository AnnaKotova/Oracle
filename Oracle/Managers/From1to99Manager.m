//
//  From1to99Manager.m
//  Oracle
//
//  Created by Ann Kotova on 8/29/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "From1to99Manager.h"

int const kEmptyCellIndicator = -1;
NSString * const kPossibleStepCurrentLabelX = @"currentLabelХ";
NSString * const kPossibleStepCurrentLabelY = @"currentLabelY";
NSString * const kPossibleStepPreviousLabelX = @"previousLabelХ";
NSString * const kPossibleStepPreviousLabelY = @"previousLabelY";

NSString * const kNumbersArrayKey = @"numbersArrayKey";
NSString * const kCellAmountOnWidthKey = @"cellAmountOnWidthKey";
NSString * const kCurrentStep = @"currentStepKey";
NSString * const kSavedGameIsExist = @"savedGameIsExistKey";

@implementation From1to99Manager
{
    NSArray * _dateArray;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _numbersArray = [NSMutableArray array];
        _currentStepNumber = 1;
    }
    return self;
}

- (void)setPlayFieldSizeForLettersCount:(NSUInteger)lettercount dateOfBirthday:(NSDate *)date
{
    _cellAmountOnWidth = lettercount;
    
    //countOfNumbers = 9 + 9 * (9 * 2 + 1) + _dateArray.count; // 1 to 99 without 0
    //countOfNumbers = 9 + 5 * (9 * 2 + 1) + _dateArray.count; // 1 to 59 without 0
    _dateArray = (date ? [self _arrayFromDate:date] : nil);
    float countOfNumbers = 9 + 2 * (9 * 2 + 1) + _dateArray.count; // 1 to 29 without 0
    _cellAmountOnHeigth = ceil(countOfNumbers / (float)_cellAmountOnWidth);
    
    [self _createNumbersArray];
}

- (void)resetManager
{
    _currentStepNumber = 1;
    
    float countOfNumbers = 9 + 2 * (9 * 2 + 1) + _dateArray.count; // 1 to 29 without 0
    _cellAmountOnHeigth = ceil(countOfNumbers / (float)_cellAmountOnWidth);

    [self _createNumbersArray];
}

# pragma mark - User Defaults
- (void)saveManagerState
{
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kSavedGameIsExist];
    [[NSUserDefaults standardUserDefaults] setObject:_numbersArray forKey:kNumbersArrayKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(_cellAmountOnWidth) forKey:kCellAmountOnWidthKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(_currentStepNumber) forKey:kCurrentStep];
}

- (void)_removeSavedManagerState
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNumbersArrayKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCellAmountOnWidthKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentStep];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSavedGameIsExist];
}

- (BOOL)successRestoreSavedState
{
    BOOL result = YES;
    NSArray * savedArray = [[NSUserDefaults standardUserDefaults] objectForKey:kNumbersArrayKey]; //usedDefaults return an immutable
    int countOfNumbers = 0;
    NSMutableArray * mutableCopy = [NSMutableArray array];
    int index = 0;
    for (NSArray * array in savedArray)
    {
        mutableCopy[index] = [array mutableCopy];
        countOfNumbers = countOfNumbers + (int)array.count;
        index++;
    }
    _numbersArray = mutableCopy;
    _cellAmountOnWidth = [[[NSUserDefaults standardUserDefaults] objectForKey:kCellAmountOnWidthKey] integerValue];
    _cellAmountOnHeigth = ceil(countOfNumbers / (float)_cellAmountOnWidth);
    _currentStepNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentStep] intValue];
    if (_numbersArray == nil
        || _cellAmountOnWidth == 0
        || _cellAmountOnHeigth == 0)
    {
        [self _removeSavedManagerState];
        result = NO;
    }
    return result;
}

# pragma mark
- (void)goToNextStep
{
    _currentStepNumber ++;
    [self _rewriteNumbersArray];
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
    int maxCounter = 30;//60;//100
    int tempNumber = 0;
    
    int dateCounter = 0;
    for (int j = 0; j < _cellAmountOnHeigth; j++)
    {
        _numbersArray[j] = [NSMutableArray array];
        for (int i = 0; i < _cellAmountOnWidth; i++)
        {
            if (counter == maxCounter)
            {
                if (dateCounter < _dateArray.count)
                {
                    _numbersArray[j][i] = _dateArray[dateCounter];
                    dateCounter++;
                }
                else
                {
                    _numbersArray[j][i] = @(kEmptyCellIndicator);
                }
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
        }
    }
    return indexesDictionary;
}

- (NSArray *)_arrayFromDate:(NSDate *)date
{
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = components.day;
    NSInteger month = components.month;
    NSInteger year = components.year;
    
    NSMutableArray * dateArray = [NSMutableArray array];
    int currentNumber;
    CGFloat tempNumber;
    // day
    tempNumber = day / 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }
    tempNumber = day % 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }

    //month
    tempNumber = month / 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }
    tempNumber = month % 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }

    //year
    tempNumber = year / 1000;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }
    tempNumber = year / 100;
    tempNumber = (int)tempNumber % 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }
    tempNumber = year / 10;
    tempNumber = (int)tempNumber % 100;
    tempNumber = (int)tempNumber % 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }
    tempNumber = (int)year % 10;
    if (tempNumber > 0)
    {
        currentNumber = tempNumber;
        [dateArray addObject:[NSNumber numberWithInt:currentNumber]];
    }
    return dateArray;
}

- (void)_rewriteNumbersArray
{
    NSMutableArray * newNumbersArray = [NSMutableArray array];
    
    __block int indexX = 0;
    __block int indexY = 0;
    newNumbersArray[indexX] = [NSMutableArray array];
    
    [_numbersArray enumerateObjectsUsingBlock:^(NSArray  *_Nonnull numberArray, NSUInteger idx, BOOL * _Nonnull stop) {
        [numberArray enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            if (number.intValue != kEmptyCellIndicator)
            {
                newNumbersArray[indexX][indexY] = number;
                
                if (indexY == self->_cellAmountOnWidth - 1)
                {
                    indexY = 0;
                    indexX++;
                    newNumbersArray[indexX] = [NSMutableArray array];
                }
                else
                {
                    indexY++;
                }
            }
        }];
    }];
    
    if (((NSArray *)newNumbersArray[indexX]).count == 0)
    {
        [newNumbersArray removeObject:newNumbersArray[indexX]];
        indexX--;
    }
    _cellAmountOnHeigth = indexX + 1;
    
    if (indexY != 0)
    {
        while (indexY < _cellAmountOnWidth)
        {
            newNumbersArray[indexX][indexY] = @(kEmptyCellIndicator);
            indexY++;
        }
    }
    
    [_numbersArray removeAllObjects];
    _numbersArray = newNumbersArray;
}

@end
