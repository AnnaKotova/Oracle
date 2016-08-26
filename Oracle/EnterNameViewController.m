//
//  EnterNameViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/24/15.
//  Copyright © 2015 Bmuse. All rights reserved.
//

#import "EnterNameViewController.h"

const int kSeparatorWidth = 1;
const int kEmptyCellIndicator = -1;

typedef NS_ENUM(NSUInteger, MovingIndex)
{
    MovingIndexX,
    MovingIndexY
};

@implementation EnterNameViewController
{
    int _cellAmountOnWidth;
    int _cellAmountOnHeigth;
    int _cellSize;
    int _countOfNumbers;
    int _labelCellSize;
    
    UIScrollView * _scrollView;
    UITextField * _textField;
    UIView * _playField;
    UIButton * _possibleStepButton;
    
    NSMutableArray * _numbersArray;
    NSMutableArray * _labelsArray;
    
    UIView * _possibleStepFirstCellView;
    UIView * _possibleStepSecondCellView;
    
//    UILabel * _possibleStepFirstLabel;
//    UILabel * _possibleStepSecondLabel;
    BOOL _possibleStepShowning;
    
    int _previousSelectedIndexX;
    int _previousSelectedIndexY;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _cellSize = 30;
    _labelCellSize = _cellSize - kSeparatorWidth * 4;
    CGFloat buttonsWidth = 100.0f;
    CGFloat offsetBeetwenElements = 10.0f;
    
    _textField = [UITextField new];
    _textField.frame = CGRectMake(20, 70, 400, 30);
    _textField.borderStyle = UITextBorderStyleLine;
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];
    
    UIButton * drawPlayFieldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    drawPlayFieldButton.frame = CGRectMake(CGRectGetMaxX(_textField.frame) + offsetBeetwenElements, _textField.frame.origin.y, buttonsWidth, _textField.frame.size.height);
    [drawPlayFieldButton setTitle:@"Done" forState:UIControlStateNormal];
    [drawPlayFieldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    drawPlayFieldButton.layer.cornerRadius = 5;
    drawPlayFieldButton.layer.borderWidth = 2.0;
    drawPlayFieldButton.layer.borderColor = [UIColor blackColor].CGColor;
    [drawPlayFieldButton addTarget:self action:@selector(_onDrawPlayFieldButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:drawPlayFieldButton];
    
    _possibleStepButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    //possiblStepButtom.frame = CGRectMake(CGRectGetMaxX(_textField.frame) + 10, _textField.frame.origin.y, 100, _textField.frame.size.height);
    [_possibleStepButton setTitle:@"Possible step" forState:UIControlStateNormal];
    [_possibleStepButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _possibleStepButton.layer.cornerRadius = 5;
    _possibleStepButton.layer.borderWidth = 2.0;
    _possibleStepButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_possibleStepButton addTarget:self action:@selector(_showPossibleStep) forControlEvents:UIControlEventTouchUpInside];
    _possibleStepButton.hidden = YES;
    [self.view addSubview:_possibleStepButton];
    
    _scrollView = [UIScrollView new];
    _scrollView.frame = CGRectMake(_textField.frame.origin.x,
                                   CGRectGetMaxY(_textField.frame) + offsetBeetwenElements,
                                   self.view.bounds.size.width,
                                   self.view.bounds.size.height - (CGRectGetMaxY(_textField.frame) + offsetBeetwenElements) - buttonsWidth - 2 * offsetBeetwenElements);
    _possibleStepButton.frame = CGRectMake(_textField.frame.origin.x, CGRectGetMaxY(_scrollView.frame) + offsetBeetwenElements, buttonsWidth, _textField.frame.size.height);
    
    [self.view addSubview:_scrollView];
    
    _numbersArray = [NSMutableArray array];
    _labelsArray = [NSMutableArray array];
    _previousSelectedIndexX = kEmptyCellIndicator;
    _previousSelectedIndexY = kEmptyCellIndicator;
    
    _possibleStepFirstCellView = [UIView new];
    _possibleStepFirstCellView.backgroundColor = [UIColor clearColor];
    _possibleStepSecondCellView = [UIView new];
    _possibleStepSecondCellView.backgroundColor = [UIColor clearColor];
    _possibleStepFirstCellView.frame = CGRectMake(0, 0, _labelCellSize, _labelCellSize);
    _possibleStepSecondCellView.frame = CGRectMake(0, 0, _labelCellSize, _labelCellSize);
    
    [self _drawLineFromPoint:CGPointMake(0, 0)
                     toPoint:CGPointMake(CGRectGetMaxX(_possibleStepFirstCellView.frame), CGRectGetMaxY(_possibleStepFirstCellView.frame))
                       color:[UIColor redColor]
                   lineWidth:1.0f
                   superview:_possibleStepFirstCellView];
    [self _drawLineFromPoint:CGPointMake(CGRectGetMaxX(_possibleStepFirstCellView.frame), 0)
                     toPoint:CGPointMake(0, CGRectGetMaxY(_possibleStepFirstCellView.frame))
                       color:[UIColor redColor]
                   lineWidth:1.0f
                   superview:_possibleStepFirstCellView];
    [self _drawLineFromPoint:CGPointMake(0, 0)
                     toPoint:CGPointMake(CGRectGetMaxX(_possibleStepSecondCellView.frame), CGRectGetMaxY(_possibleStepSecondCellView.frame))
                       color:[UIColor redColor]
                   lineWidth:1.0f
                   superview:_possibleStepSecondCellView];
    [self _drawLineFromPoint:CGPointMake(CGRectGetMaxX(_possibleStepSecondCellView.frame), 0)
                     toPoint:CGPointMake(0, CGRectGetMaxY(_possibleStepSecondCellView.frame))
                       color:[UIColor redColor]
                   lineWidth:1.0f
                   superview:_possibleStepSecondCellView];
}

#pragma mark - UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _cellAmountOnWidth = textField.text.length;
    
    //_countOfNumbers = 9 + 9 * (9 * 2 + 1); // 1 to 99 without 0
    _countOfNumbers = 9 + 5 * (9 * 2 + 1);
    float countOfNumbers= _countOfNumbers;
    float width= _cellAmountOnWidth;
    _cellAmountOnHeigth = ceil(countOfNumbers / width);
    
    [self _drawInterface];
    _textField.text = nil;
}

- (void)_drawInterface
{
    [self _drawField];
    [self _fillSquares];
}

#pragma mark = drow interface
- (void)_drawField
{
    CGFloat playFieldWidth = (kSeparatorWidth + _cellSize) * _cellAmountOnWidth + kSeparatorWidth;
    CGFloat playFieldHeight = (kSeparatorWidth + _cellSize) * _cellAmountOnHeigth + kSeparatorWidth;
    _playField = [UIView new];
    _playField.frame = CGRectMake(0, 0, playFieldWidth, playFieldHeight);
    _scrollView.contentSize = _playField.bounds.size;
    [_scrollView addSubview:_playField];
    
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onPlayFieldTap:)];
    [_playField addGestureRecognizer:gestureRecognizer];
    
    for (int i = 0; i < _cellAmountOnWidth + 1; i++)
    {
        // vertical lines
        [self _drawLineFromPoint:CGPointMake(i * (_cellSize + kSeparatorWidth), 0)
                         toPoint:CGPointMake(i * (_cellSize + kSeparatorWidth), playFieldHeight)
                           color:[UIColor blackColor]
                       lineWidth:kSeparatorWidth
                       superview:_playField];
        
    }
    
    for (int i = 0; i < _cellAmountOnHeigth + 1; i++)
    {
        // horizontal lines
        [self _drawLineFromPoint:CGPointMake(0, i * (_cellSize + kSeparatorWidth))
                         toPoint:CGPointMake(playFieldWidth, i * (_cellSize + kSeparatorWidth))
                           color:[UIColor blackColor]
                       lineWidth:kSeparatorWidth
                       superview:_playField];

    }
    _possibleStepButton.hidden = NO;
}

- (void)_drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)finishPoint color:(UIColor *)color lineWidth:(CGFloat)lineWidth superview:(UIView *)superview
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:finishPoint];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = lineWidth;
//    shapeLayer.fillColor = [[UIColor greenColor] CGColor];
//    shapeLayer.backgroundColor = [[UIColor greenColor] CGColor];
    
    [superview.layer addSublayer:shapeLayer];
}

- (void)_fillSquares
{
    int counter = 1;
    int tempNumber = 0;
    
    for (int j = 0; j < _cellAmountOnHeigth; j++)
    {
        _numbersArray[j] = [NSMutableArray array];
        _labelsArray[j] = [NSMutableArray array];
        for (int i = 0; i < _cellAmountOnWidth; i++)
        {
            if (counter == 60)//100)
            {
                _numbersArray[j][i] = @(kEmptyCellIndicator);
            }
            else
            {
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kSeparatorWidth * 2 + i * (_cellSize + kSeparatorWidth),
                                                                            kSeparatorWidth * 2 + j * (_cellSize + kSeparatorWidth),
                                                                            _labelCellSize,
                                                                            _labelCellSize)];
                label.backgroundColor = [UIColor greenColor];
                label.textColor = [UIColor blackColor];
                label.textAlignment = NSTextAlignmentCenter;
                _labelsArray[j][i] = label;
                
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
                label.text = [NSString stringWithFormat:@"%i", currentNumber];
                
                if (tempNumber == 0)
                {
                    counter++;
                }
                
                [_playField addSubview:label];
            }
        }
        
//        if (counter == 100)
//        {
//            break;
//        }
    }
}

#pragma mark - Handlers
- (void)_onDrawPlayFieldButtonTap:(UIButton *)sender
{
    [_playField removeFromSuperview];
    _playField = nil;
    [_textField resignFirstResponder];
}

- (void)_onPlayFieldTap:(UITapGestureRecognizer *)sender
{
    ///get tapped point
    CGPoint point = [sender locationInView:_playField];
    int indexX = point.x / (kSeparatorWidth + _cellSize);
    int indexY = point.y / (kSeparatorWidth + _cellSize);
    
    NSNumber * selectedNumber = _numbersArray[indexY][indexX];
    
    ///tap on already used cell
    if (selectedNumber.intValue == kEmptyCellIndicator)
    {
        return;
    }
    
    /// tap on selected, but yet wasn't used cell
    if (indexX == _previousSelectedIndexX && indexY == _previousSelectedIndexY)
    {
        UILabel * previousSelectedLabel = _labelsArray[_previousSelectedIndexY][_previousSelectedIndexX];
        previousSelectedLabel.backgroundColor = [UIColor greenColor];
        _previousSelectedIndexX = kEmptyCellIndicator;
        _previousSelectedIndexY = kEmptyCellIndicator;
        return;
    }
    
    ///selected cell exist
    if (_previousSelectedIndexX >= 0)
    {
        BOOL cellCompliesCondition = [self _checkAccordanceOfCellsWithIndexX:indexX indexY:indexY];
        UILabel * previousSelectedLabel = _labelsArray[_previousSelectedIndexY][_previousSelectedIndexX];
        ///couple
        if (cellCompliesCondition)
        {
            if(_possibleStepShowning)
            {
                _possibleStepShowning = NO;
                [_possibleStepFirstCellView removeFromSuperview];
                [_possibleStepSecondCellView removeFromSuperview];
            }

            UILabel * currentSelectedLabel = _labelsArray[indexY][indexX];
            previousSelectedLabel.backgroundColor = [UIColor darkGrayColor];
            currentSelectedLabel.backgroundColor = [UIColor darkGrayColor];
            _previousSelectedIndexX = kEmptyCellIndicator;
            _previousSelectedIndexY = kEmptyCellIndicator;
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                            message:@"Missing choise"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleCancel
                                                            handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else ///tap on the first cell
    {
        UILabel * selectedLabel = _labelsArray[indexY][indexX];
        
        if(_possibleStepShowning)
        {
            _possibleStepShowning = NO;
            [_possibleStepFirstCellView removeFromSuperview];
            [_possibleStepSecondCellView removeFromSuperview];
        }
        
        selectedLabel.backgroundColor = [UIColor grayColor];
        _previousSelectedIndexX = indexX;
        _previousSelectedIndexY = indexY;
    }
}

#pragma mark - Logic

- (BOOL)_checkAccordanceOfCellsWithIndexX:(int)currentIndexX indexY:(int)currentIndexY
{
    BOOL cellCompliesCondition = NO;
    
    NSNumber * previousNumber = _numbersArray[_previousSelectedIndexY][_previousSelectedIndexX];
    NSNumber * currentNumber = _numbersArray[currentIndexY][currentIndexX];
    
    int movingPreviousIndex;
    int movingCurrentIndex;
    MovingIndex movingIndex;
    
    if (currentIndexX == _previousSelectedIndexX)
    {
        movingPreviousIndex = _previousSelectedIndexY;
        movingCurrentIndex = currentIndexY;
        movingIndex = MovingIndexY;
    }
    else if (currentIndexY == _previousSelectedIndexY)
    {
        movingPreviousIndex = _previousSelectedIndexX;
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
                _numbersArray[_previousSelectedIndexY][_previousSelectedIndexX] = @(kEmptyCellIndicator);
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

- (BOOL)_findPossibleStepForIndexX:(int)i indexY:(int)j movingIndex:(MovingIndex)movingIndex//previousX:(int)previousX previousY:(int)previousY
{
    BOOL findPossibleStep = NO;
    
    NSNumber * currentNumber = _numbersArray[i][j];
    
    if (currentNumber.intValue != kEmptyCellIndicator)
    {
        int previousIndex;// = j - 1;
        NSNumber * previousNumber; //= _numbersArray[i][previousIndex];

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
        
        NSLog(@"i = %i, j = %i", i, j);
        if ((currentNumber == previousNumber || currentNumber.intValue + previousNumber.intValue == 10) && currentNumber.intValue != kEmptyCellIndicator)
        {
            _possibleStepShowning = YES;
            
            UILabel * currentLabel = _labelsArray[i][j];
            UILabel * previousLabel;
            switch (movingIndex)
            {
                case MovingIndexX: /// move on row
                {
                    previousLabel = _labelsArray[i][previousIndex];
                }
                    break;
                case MovingIndexY: /// move on colume
                {
                    previousLabel = _labelsArray[previousIndex][j];
                }
                    break;
            }
            
            [currentLabel addSubview:_possibleStepFirstCellView];
            [previousLabel addSubview:_possibleStepSecondCellView];
            
            findPossibleStep = YES;
        }
    }
    return findPossibleStep;
}

- (void)_showPossibleStep
{
    if (_possibleStepShowning)
    {
        return;
    }
    
    int i = 0;
    int j = 1;
    BOOL findPossibleStep = NO;
    //NSLog(@"_cellAmountOnHeigth = %i, _cellAmountOnWidth = %i", _cellAmountOnHeigth, _cellAmountOnWidth);
    /// move on row
    while(i < _cellAmountOnHeigth)
    {
        j = 1;
        while (j < _cellAmountOnWidth)
        {
            findPossibleStep = [self _findPossibleStepForIndexX:i indexY:j movingIndex:MovingIndexX];
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
        return;
    }
    
    /// move on colume
    i = 1;
    while(i < _cellAmountOnHeigth)
    {
        j = 0;
        while (j < _cellAmountOnWidth)
        {
            findPossibleStep = [self _findPossibleStepForIndexX:i indexY:j movingIndex:MovingIndexY];
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

    if(!findPossibleStep)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                        message:@"There are no available moves"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end