//
//  NumericPlayFieldViewController.m
//  Oracle
//
//  Created by Ann Kotova on 1/12/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "NumericPlayFieldViewController.h"
#import "From1to99Manager.h"
#import "SaveResultViewController.h"
#import "AppearanceManager.h"

static const CGFloat kOffsetBeetwenElements = 20.0f;
static const CGFloat kLabelInset = 2.0f;

@interface NumericPlayFieldViewController ()
{
    From1to99Manager * _manager;
    
    NSUInteger _cellSize;
    NSUInteger _separatorSize;
    NSUInteger _labelCellSize;
    
    NSString * _nameString;
    NSDate * _birthdayDate;
    
    UIView * _playField;
    UIScrollView * _scrollView;
    
    UIButton * _possibleStepButton;
    UILabel * _messagesLabel;
    
    NSMutableArray * _labelsArray;
    
    NSDictionary * _possibleStepIndexesDictionary;
    
    UIView * _possibleStepFirstCellView;
    UIView * _possibleStepSecondCellView;
    
    BOOL _possibleStepShowwing;
    BOOL _coupleExist;
    
    int _previousSelectedIndexX;
    int _previousSelectedIndexY;
}
@end

@implementation NumericPlayFieldViewController

- (instancetype)initWithNameString:(NSString *)nameString dateOfBirthday:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        _nameString = nameString;
        _birthdayDate = date;
        
        _manager = [From1to99Manager new];
        [self _clearInterface];
        
        [_manager setPlayFieldSizeForLettersCount:_nameString.length dateOfBirthday:date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    
    [self _calculateConstants];
    
    CGFloat buttonsWidth = 100.0f;
    _possibleStepButton = [[AppearanceManager sharedManager] buttonWithTitle:NSLocalizedString(@"NumericPlayFieldViewController_Step_Button_Title", nil)];
    _possibleStepButton.frame = CGRectMake(0, 0, buttonsWidth, buttonsWidth / 2);
    [_possibleStepButton addTarget:self action:@selector(_onPossibleStepButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _possibleStepButton.hidden = YES;
    [self.view addSubview:_possibleStepButton];
    
    _messagesLabel = [UILabel new];
    _messagesLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 2 * kOffsetBeetwenElements, buttonsWidth / 2);
    _messagesLabel.textColor = [UIColor redColor];
    _messagesLabel.font = [[AppearanceManager sharedManager] appFont];
    _messagesLabel.textAlignment = NSTextAlignmentCenter;
    _messagesLabel.numberOfLines = 2;
    _messagesLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_messagesLabel];
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    
    _labelsArray = [NSMutableArray array];
    _previousSelectedIndexX = kEmptyCellIndicator;
    _previousSelectedIndexY = kEmptyCellIndicator;
    
    _possibleStepFirstCellView = [UIView new];
    _possibleStepFirstCellView.backgroundColor = [UIColor clearColor];
    _possibleStepSecondCellView = [UIView new];
    _possibleStepSecondCellView.backgroundColor = [UIColor clearColor];
    _possibleStepFirstCellView.frame = CGRectMake(0, 0, _labelCellSize, _labelCellSize);
    _possibleStepSecondCellView.frame = CGRectMake(0, 0, _labelCellSize, _labelCellSize);
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];

    //crosses for possible step
    [self _drowOvalOnSuperview:_possibleStepFirstCellView color:[UIColor redColor] lineWidth:2.0f];
    [self _drowOvalOnSuperview:_possibleStepSecondCellView color:[UIColor redColor] lineWidth:2.0f];
    
    [self _drawInterface];
    [self _checkPossibleStep];
}

- (void)viewDidLayoutSubviews
{
    CGFloat topIndent = 40.0f;
    _possibleStepButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), kNavigatinBarHeight + topIndent + CGRectGetHeight(_possibleStepButton.bounds) / 2);
    
    _messagesLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_possibleStepButton.frame) + CGRectGetHeight(_messagesLabel.bounds) / 2);

    CGFloat scrollViewWidth = (CGRectGetWidth(_playField.bounds) > CGRectGetWidth(self.view.bounds) - 2 * kOffsetBeetwenElements
                               ? CGRectGetWidth(self.view.bounds) - 2 * kOffsetBeetwenElements
                               : CGRectGetWidth(_playField.bounds));
    
    CGFloat maxScrollViewHeight = CGRectGetHeight(self.view.bounds) - (CGRectGetMaxY(_messagesLabel.frame) + 2 * kOffsetBeetwenElements);
    CGFloat scrollViewHeight = (CGRectGetHeight(_playField.bounds) > maxScrollViewHeight
                               ? maxScrollViewHeight
                               : CGRectGetHeight(_playField.bounds));

    _scrollView.frame = CGRectMake(0,
                                   0,
                                   scrollViewWidth,
                                   scrollViewHeight);
    _scrollView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_messagesLabel.frame) + kOffsetBeetwenElements + CGRectGetHeight(_scrollView.frame)/2);
    
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_drawInterface
{
    [self _updateControllerTitle];
    [self _drawField];
    [self _fillSquares];
//    [self _checkPossibleStep];
}

#pragma mark - draw interface
- (void)_calculateConstants
{
    CGFloat minSeparatorWidth = 2;
    CGFloat minCellSize = 50.0f;
    
//    CGFloat estimatedMaxCellSize = (CGRectGetWidth(self.view.frame) - 2 * kOffsetBeetwenElements) / _manager.cellAmountOnWidth;
//    CGFloat maxCellSize = minCellSize * 2;
//    if (estimatedMaxCellSize < minCellSize + minSeparatorWidth)
//    {
        _cellSize = minCellSize;
        _separatorSize = minSeparatorWidth;
//    }
//    else if(estimatedMaxCellSize < maxCellSize)
//    {
//        _separatorSize = estimatedMaxCellSize * 1 / 6.;
//        CGFloat estimatedMaxCellSize = (CGRectGetWidth(self.view.frame) - 2 * kOffsetBeetwenElements  - _separatorSize) / _manager.cellAmountOnWidth;
//        _cellSize = estimatedMaxCellSize - _separatorSize;
//    }
//    else
//    {
//        _separatorSize = maxCellSize * 1 / 6.;
//        _cellSize = maxCellSize - _separatorSize;
//    }
    
    _labelCellSize = _cellSize - kLabelInset * 2;
    _coupleExist = NO;
}

- (void)_updateControllerTitle
{
    self.title = [NSString stringWithFormat:NSLocalizedString(@"NumericPlayFieldViewController_Step_Label", nil), _manager.currentStepNumber];
}

- (void)_drawField
{
    int nameRow = 1;
    CGFloat playFieldWidth = (_separatorSize + _cellSize) * _manager.cellAmountOnWidth + _separatorSize;
    CGFloat playFieldHeight = (_separatorSize + _cellSize) * (_manager.cellAmountOnHeigth + nameRow) + _separatorSize;
    
    _playField = [UIView new];
    _playField.frame = CGRectMake(0, 0, playFieldWidth, playFieldHeight);
    _scrollView.contentSize = _playField.bounds.size;
    [_scrollView addSubview:_playField];
    
    
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onPlayFieldTap:)];
    [_playField addGestureRecognizer:gestureRecognizer];
    
    for (int i = 0; i < _manager.cellAmountOnWidth + 1; i++)
    {
        // vertical lines
        [self _drawLineFromPoint:CGPointMake(i * (_cellSize + _separatorSize) + _separatorSize / 2., 0)
                         toPoint:CGPointMake(i * (_cellSize + _separatorSize) + _separatorSize / 2., playFieldHeight)
                           color:[AppearanceManager dackColor]
                       lineWidth:_separatorSize
                       superview:_playField];
    }
    
    for (int i = 0; i < _manager.cellAmountOnHeigth + 1  + nameRow; i++)
    {
        // horizontal lines
        [self _drawLineFromPoint:CGPointMake(0, i * (_cellSize + _separatorSize) + _separatorSize / 2.)
                         toPoint:CGPointMake(playFieldWidth - _separatorSize, i * (_cellSize + _separatorSize) + _separatorSize / 2.)
                           color:[AppearanceManager dackColor]
                       lineWidth:_separatorSize
                       superview:_playField];
        
    }
    _possibleStepButton.hidden = NO;
    
    [self viewDidLayoutSubviews];
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
    [superview.layer addSublayer:shapeLayer];
}

- (void)_drowOvalOnSuperview:(UIView *)superview color:(UIColor *)color lineWidth:(CGFloat)lineWidth
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(lineWidth,
                                                                                  lineWidth,
                                                                                  superview.bounds.size.width - lineWidth * 2,
                                                                                  superview.bounds.size.height - lineWidth * 2)];
    
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath:bezierPath.CGPath];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setLineWidth:lineWidth];
    [superview.layer addSublayer:shapeLayer];
}

- (void)_fillSquares
{
    // fill name cells
    for (int i = 0; i < _manager.cellAmountOnWidth; i++)
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_separatorSize + i * (_cellSize + _separatorSize),
                                                                    _separatorSize,
                                                                    _cellSize,
                                                                    _cellSize)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = [_nameString substringWithRange:NSMakeRange(i, 1)];
        
        [_playField addSubview:label];
    }
    
//    BOOL wasBreak = NO;
    for (int j = 0; j < _manager.cellAmountOnHeigth; j++)
    {
        _labelsArray[j] = [NSMutableArray array];
        for (int i = 0; i < _manager.cellAmountOnWidth; i++)
        {
//            if ([_manager.numbersArray[j][i] intValue] == kEmptyCellIndicator)
//            {
//                wasBreak = YES;
//                break;
//            }
//            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kSeparatorWidth * 2 + i * (_cellSize + kSeparatorWidth),
//                                                                        kSeparatorWidth * 2 + (j + 1) * (_cellSize + kSeparatorWidth), //  (j + 1) first row for name
//                                                                        _labelCellSize,
//                                                                        _labelCellSize)];
//            label.backgroundColor = [UIColor greenColor];
//            label.textColor = [UIColor blackColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            _labelsArray[j][i] = label;
//
//            label.text = [NSString stringWithFormat:@"%i", [_manager.numbersArray[j][i] intValue]];
//
//            [_playField addSubview:label];
            if ([_manager.numbersArray[j][i] intValue] == kEmptyCellIndicator)
            {
                // inactive cells
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(_separatorSize + i * (_cellSize + _separatorSize),
                                                                         _separatorSize + (j + 1) * (_cellSize + _separatorSize),  //  (j + 1) first row for name
                                                                         _cellSize,
                                                                         _cellSize)];
                view.backgroundColor = [AppearanceManager cellEnableColor];
                view.userInteractionEnabled = NO;
                _labelsArray[j][i] = view;
                [_playField addSubview:view];
            }
            else
            {
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_separatorSize + kLabelInset + i * (_cellSize + _separatorSize),
                                                                            _separatorSize + kLabelInset + (j + 1) * (_cellSize + _separatorSize),  //  (j + 1) first row for name
                                                                            _labelCellSize,
                                                                            _labelCellSize)];
                label.layer.backgroundColor = [AppearanceManager cellBackgroundColorAtNormalState].CGColor;
                label.textColor = [AppearanceManager dackColor];
                label.textAlignment = NSTextAlignmentCenter;
                CGFloat fontSizeAspect = 3.0f / 5.0f * _cellSize;
                label.font = [AppearanceManager appFontWithSize:fontSizeAspect];
                label.adjustsFontSizeToFitWidth = YES;
                label.layer.cornerRadius = 3.0f;
                label.clipsToBounds = YES;
                _labelsArray[j][i] = label;
                
                label.text = [NSString stringWithFormat:@"%i", [_manager.numbersArray[j][i] intValue]];
                
                [_playField addSubview:label];
            }
        }
        
//        if (wasBreak)
//        {
//            break;
//        }
    }
}

- (void)_clearInterface
{
    if(_possibleStepShowwing)
    {
        _possibleStepShowwing = NO;
        [_possibleStepFirstCellView removeFromSuperview];
        [_possibleStepSecondCellView removeFromSuperview];
    }
    
    _scrollView.contentOffset = CGPointZero;
    [_playField removeFromSuperview];
    _playField = nil;
    
    _coupleExist = NO;
    _previousSelectedIndexX = kEmptyCellIndicator;
    _previousSelectedIndexY = kEmptyCellIndicator;
    [_labelsArray removeAllObjects];
    _possibleStepIndexesDictionary = nil;
}

#pragma mark - Actions
- (void)_onPlayFieldTap:(UITapGestureRecognizer *)sender
{
    ///get tapped point
    CGPoint point = [sender locationInView:_playField];
    int indexX = (point.x - _separatorSize / 2)/ (_separatorSize + _cellSize);
    int indexY = (point.y - _separatorSize / 2)/ (_separatorSize + _cellSize);

    /// tap on name
    if(   indexY == 0
       || indexX > _manager.cellAmountOnWidth
       || indexY > _manager.cellAmountOnHeigth)
    {
        return;
    }
    indexY--;
    
    NSNumber * selectedNumber = _manager.numbersArray[indexY][indexX];
    
    ///tap on already used cell
    if (selectedNumber.intValue == kEmptyCellIndicator)
    {
        return;
    }
    
    /// tap on selected, but yet wasn't used cell
    if (indexX == _previousSelectedIndexX && indexY == _previousSelectedIndexY)
    {
        UILabel * previousSelectedLabel = _labelsArray[_previousSelectedIndexY][_previousSelectedIndexX];
        previousSelectedLabel.layer.backgroundColor = [AppearanceManager cellBackgroundColorAtNormalState].CGColor;
        _previousSelectedIndexX = kEmptyCellIndicator;
        _previousSelectedIndexY = kEmptyCellIndicator;
        return;
    }
    
    ///selected cell exist
    if (_previousSelectedIndexX >= 0)
    {
        BOOL cellCompliesCondition = [_manager checkAccordanceOfCellsWithIndexX:indexX
                                                                         indexY:indexY
                                                         previousSelectedIndexX:_previousSelectedIndexX
                                                         previousSelectedIndexY:_previousSelectedIndexY];
        
        UILabel * previousSelectedLabel = _labelsArray[_previousSelectedIndexY][_previousSelectedIndexX];
        UILabel * currentSelectedLabel = _labelsArray[indexY][indexX];
        ///couple
        if (cellCompliesCondition)
        {
            if(_possibleStepShowwing)
            {
                _possibleStepShowwing = NO;
                [_possibleStepFirstCellView removeFromSuperview];
                [_possibleStepSecondCellView removeFromSuperview];
            }
            
            previousSelectedLabel.layer.backgroundColor = [AppearanceManager cellEnableColor].CGColor;
            currentSelectedLabel.layer.backgroundColor = [AppearanceManager cellEnableColor].CGColor;
            previousSelectedLabel.textColor = [AppearanceManager mainBackgroundColor];
            currentSelectedLabel.textColor = [AppearanceManager mainBackgroundColor];
            _coupleExist = YES;
            _previousSelectedIndexX = kEmptyCellIndicator;
            _previousSelectedIndexY = kEmptyCellIndicator;
            
            [self _checkPossibleStep];
        }
        else
        {
            ///missing choise
            [self _executeMissingChoiseForPreviousSelectedLabel:previousSelectedLabel currentSelectedLabel:currentSelectedLabel];
        }
    }
    else ///tap on the first cell
    {
        UILabel * selectedLabel = _labelsArray[indexY][indexX];
        
        if(_possibleStepShowwing)
        {
            _possibleStepShowwing = NO;
            [_possibleStepFirstCellView removeFromSuperview];
            [_possibleStepSecondCellView removeFromSuperview];
        }
        
        selectedLabel.layer.backgroundColor = [AppearanceManager secondColor].CGColor;
        _previousSelectedIndexX = indexX;
        _previousSelectedIndexY = indexY;
    }
}

- (void)_onPossibleStepButtonTap:(UIButton *)sender
{
    if (_possibleStepIndexesDictionary.count > 0)
    {
        int x = [_possibleStepIndexesDictionary[kPossibleStepCurrentLabelX] intValue];
        int y = [_possibleStepIndexesDictionary[kPossibleStepCurrentLabelY] intValue];
        [_labelsArray[x][y] addSubview:_possibleStepFirstCellView];

        x = [_possibleStepIndexesDictionary[kPossibleStepPreviousLabelX] intValue];
        y = [_possibleStepIndexesDictionary[kPossibleStepPreviousLabelY] intValue];
        [_labelsArray[x][y] addSubview:_possibleStepSecondCellView];

        
        x = [_possibleStepIndexesDictionary[kPossibleStepPreviousLabelX] intValue];
        y = [_possibleStepIndexesDictionary[kPossibleStepPreviousLabelY] intValue];
        [_labelsArray[x][y] addSubview:_possibleStepSecondCellView];
        UILabel * possibleStepSecondCellLable = _labelsArray[x][y];
        _possibleStepShowwing = YES;
        
        //scroll to visible _possibleStep cell if needed
        CGFloat offsetX = _scrollView.contentOffset.x;
        if (possibleStepSecondCellLable.frame.origin.x < _scrollView.contentOffset.x)
        {
            offsetX = possibleStepSecondCellLable.frame.origin.x;
        }
        else if (possibleStepSecondCellLable.frame.origin.x > (_scrollView.contentOffset.x + _scrollView.frame.size.width)  )
        {
            offsetX = possibleStepSecondCellLable.frame.origin.x;
        }
        
        CGFloat offsetY = _scrollView.contentOffset.y;
        if (possibleStepSecondCellLable.frame.origin.y < _scrollView.contentOffset.y)
        {
            offsetY = possibleStepSecondCellLable.frame.origin.y;
        }
        else if (possibleStepSecondCellLable.frame.origin.y > (_scrollView.contentOffset.y + _scrollView.frame.size.height)  )
        {
            offsetY = possibleStepSecondCellLable.frame.origin.y;
        }
        
        _scrollView.contentOffset = CGPointMake(offsetX, offsetY);
    }
}

- (void)_orientationChanged:(NSNotification *)note
{
    _messagesLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 2 * kOffsetBeetwenElements, CGRectGetHeight(_messagesLabel.frame));
}

- (void)_checkPossibleStep
{
    _possibleStepIndexesDictionary = [_manager possibleStepIndexesDictionary];
    if (!(_possibleStepIndexesDictionary.count > 0))
    {
        if(!_coupleExist)
        {
            [self _executeGameEnd];
        }
        else
        {
            [self _showNextStep];
        }
    }
}

- (void)_executeGameEnd
{
    //_possibleStepButton.enabled = NO;
    NSInteger sum = [_manager sumLeftoverNumbers];
    sum = (sum > 42 ? 42 : sum);
    NSString * key = [NSString stringWithFormat:@"%li", (long)sum];
    
    __typeof(self) __weak weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:[NSString stringWithFormat:@"%@ %@", _nameString, NSLocalizedString(key, nil)]
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"EnterNameViewController_Save", nil)
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            __typeof(self) __strong strongSelf = weakSelf;
                                                            if([strongSelf.delegate respondsToSelector:@selector(numericPlayFieldViewControllerSaveResultWithKey:)])
                                                            {
                                                                [strongSelf.delegate numericPlayFieldViewControllerSaveResultWithKey:sum];
                                                            }
                                                            [strongSelf.navigationController popViewControllerAnimated:YES];
                                                        }];
    UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:NSLocalizedString(@"EnterNameViewController_Try_Again", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action){
                                                          __typeof(self) __strong strongSelf = weakSelf;
                                                          [strongSelf->_manager resetManager];
                                                          [strongSelf _clearInterface];
                                                          [strongSelf _drawInterface];
                                                          [strongSelf _checkPossibleStep];
                                                      }];
    [alert addAction:saveAction];
    [alert addAction:tryAgain];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)_showNextStep
{
    _messagesLabel.text = NSLocalizedString(@"NumericPlayFieldViewController_Next_Step_Alert", nil);
    
    [UIView animateWithDuration:2.0f
                     animations:^{
                         // fade out
                         _scrollView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_manager goToNextStep];
                         [self _clearInterface];
                         [self _drawInterface];
                         
                         [UIView animateWithDuration:2.0f
                                          animations:^{
                                              //fade in
                                              _scrollView.alpha = 1;
                                              _messagesLabel.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              _messagesLabel.alpha = 1;
                                              _messagesLabel.text = @"";
                                              [self _checkPossibleStep];
                                          }];
                     }];
}

- (void)_executeMissingChoiseForPreviousSelectedLabel:(UILabel *)previousSelectedLabel currentSelectedLabel:(UILabel *)currentSelectedLabel
{
    _messagesLabel.text = NSLocalizedString(@"NumericPlayFieldViewController_Missing_Choise_Label", nil);
    previousSelectedLabel.userInteractionEnabled = NO;
    currentSelectedLabel.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.0 animations:^{
        previousSelectedLabel.layer.backgroundColor = [UIColor redColor].CGColor;
        currentSelectedLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            previousSelectedLabel.layer.backgroundColor = [AppearanceManager cellBackgroundColorAtNormalState].CGColor;
            currentSelectedLabel.layer.backgroundColor = [AppearanceManager cellBackgroundColorAtNormalState].CGColor;
            _messagesLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _messagesLabel.text = @"";
            _messagesLabel.alpha = 1;
            previousSelectedLabel.userInteractionEnabled = YES;
            currentSelectedLabel.userInteractionEnabled = YES;
        }];
    }];
    
    _previousSelectedIndexX = kEmptyCellIndicator;
    _previousSelectedIndexY = kEmptyCellIndicator;
}

@end
