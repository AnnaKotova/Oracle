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

const int kSeparatorWidth = 1;
const static CGFloat kOffsetBeetwenElements = 20.0f;
static const CGFloat kNavigatinBarHeight = 44.0f;

@interface NumericPlayFieldViewController ()
{
    From1to99Manager * _manager;
    
    NSUInteger _cellSize;
    NSUInteger _labelCellSize;
    
    NSString * _nameString;
    NSDate * _birthdayDate;
    
    UIView * _playField;
    UIScrollView * _scrollView;
    
    UIButton * _possibleStepButton;

    NSMutableArray * _labelsArray;
    
    UIView * _possibleStepFirstCellView;
    UIView * _possibleStepSecondCellView;
    
    BOOL _possibleStepShowwing;
    
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = NO;
    
    _cellSize = 30;
    _labelCellSize = _cellSize - kSeparatorWidth * 4;

    CGFloat buttonsWidth = 100.0f;
    _possibleStepButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _possibleStepButton.frame = CGRectMake(0, 0, buttonsWidth, _cellSize);
    [_possibleStepButton setTitle:NSLocalizedString(@"EnterNameViewController_Possible_Step_Button_Title", nil) forState:UIControlStateNormal];
    [_possibleStepButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _possibleStepButton.layer.cornerRadius = 5;
    _possibleStepButton.layer.borderWidth = 2.0;
    _possibleStepButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_possibleStepButton addTarget:self action:@selector(_onPossibleStepButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _possibleStepButton.hidden = YES;
    [self.view addSubview:_possibleStepButton];
    
    _scrollView = [UIScrollView new];
    _scrollView.frame = CGRectMake(0,
                                   0,
                                   self.view.bounds.size.width - 2 * kOffsetBeetwenElements,
                                   self.view.bounds.size.height - (CGRectGetMaxY(_possibleStepButton.frame) + kOffsetBeetwenElements));
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

    [self _drawInterface];
}

- (void)viewDidLayoutSubviews
{
    CGFloat topIndent = 70.0f;
    _possibleStepButton.center = CGPointMake(topIndent + CGRectGetWidth(_possibleStepButton.frame) / 2, kNavigatinBarHeight + topIndent + CGRectGetHeight(_possibleStepButton.bounds) / 2);
    _scrollView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(_possibleStepButton.frame) + kOffsetBeetwenElements + CGRectGetHeight(_scrollView.frame)/2);
    
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_drawInterface
{
    [self _drawField];
    [self _fillSquares];
}

#pragma mark - draw interface
- (void)_drawField
{
    int nameRow = 1;
    CGFloat playFieldWidth = (kSeparatorWidth + _cellSize) * _manager.cellAmountOnWidth + kSeparatorWidth;
    CGFloat playFieldHeight = (kSeparatorWidth + _cellSize) * (_manager.cellAmountOnHeigth + nameRow) + kSeparatorWidth;
    
    _playField = [UIView new];
    _playField.frame = CGRectMake(0, 0, playFieldWidth, playFieldHeight);
    _scrollView.contentSize = _playField.bounds.size;
    [_scrollView addSubview:_playField];
    
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onPlayFieldTap:)];
    [_playField addGestureRecognizer:gestureRecognizer];
    
    for (int i = 0; i < _manager.cellAmountOnWidth + 1; i++)
    {
        // vertical lines
        [self _drawLineFromPoint:CGPointMake(i * (_cellSize + kSeparatorWidth), 0)
                         toPoint:CGPointMake(i * (_cellSize + kSeparatorWidth), playFieldHeight)
                           color:[UIColor blackColor]
                       lineWidth:kSeparatorWidth
                       superview:_playField];
        
    }
    
    for (int i = 0; i < _manager.cellAmountOnHeigth + 1 + nameRow; i++)
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
    // fill name cells
    for (int i = 0; i < _manager.cellAmountOnWidth; i++)
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kSeparatorWidth * 2 + i * (_cellSize + kSeparatorWidth),
                                                                    kSeparatorWidth * 2,
                                                                    _labelCellSize,
                                                                    _labelCellSize)];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = [_nameString substringWithRange:NSMakeRange(i, 1)];
        
        [_playField addSubview:label];
    }
    
    BOOL wasBreak = NO;
    for (int j = 0; j < _manager.cellAmountOnHeigth; j++)
    {
        _labelsArray[j] = [NSMutableArray array];
        for (int i = 0; i < _manager.cellAmountOnWidth; i++)
        {
            if ([_manager.numbersArray[j][i] intValue] == kEmptyCellIndicator)
            {
                wasBreak = YES;
                break;
            }
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kSeparatorWidth * 2 + i * (_cellSize + kSeparatorWidth),
                                                                        kSeparatorWidth * 2 + (j + 1) * (_cellSize + kSeparatorWidth), //  (j + 1) first row for name
                                                                        _labelCellSize,
                                                                        _labelCellSize)];
            label.backgroundColor = [UIColor greenColor];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            _labelsArray[j][i] = label;
            
            label.text = [NSString stringWithFormat:@"%i", [_manager.numbersArray[j][i] intValue]];
            
            [_playField addSubview:label];
        }
        
        if (wasBreak)
        {
            break;
        }
    }
}

- (void)_clearInterface
{
    [_playField removeFromSuperview];
    _playField = nil;
    
    _previousSelectedIndexX = kEmptyCellIndicator;
    _previousSelectedIndexY = kEmptyCellIndicator;
    [_labelsArray removeAllObjects];
}

- (void)_onPlayFieldTap:(UITapGestureRecognizer *)sender
{
    ///get tapped point
    CGPoint point = [sender locationInView:_playField];
    int indexX = point.x / (kSeparatorWidth + _cellSize);
    int indexY = point.y / (kSeparatorWidth + _cellSize);
    
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
        previousSelectedLabel.backgroundColor = [UIColor greenColor];
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
        ///couple
        if (cellCompliesCondition)
        {
            if(_possibleStepShowwing)
            {
                _possibleStepShowwing = NO;
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
            previousSelectedLabel.backgroundColor = [UIColor greenColor];
            _previousSelectedIndexX = kEmptyCellIndicator;
            _previousSelectedIndexY = kEmptyCellIndicator;
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
        
        selectedLabel.backgroundColor = [UIColor grayColor];
        _previousSelectedIndexX = indexX;
        _previousSelectedIndexY = indexY;
    }
}

- (void)_onPossibleStepButtonTap:(UIButton *)sender
{
    if (_possibleStepShowwing)
    {
        return;
    }
    
    NSDictionary * indexesDictionary = [_manager possibleStepIndexesDictionary];
    //    if (indexesDictionary.count > 0)
    //    {
    //        int x = [indexesDictionary[kPossibleStepCurrentLabelX] intValue];
    //        int y = [indexesDictionary[kPossibleStepCurrentLabelY] intValue];
    //        [_labelsArray[x][y] addSubview:_possibleStepFirstCellView];
    //
    //        x = [indexesDictionary[kPossibleStepPreviousLabelX] intValue];
    //        y = [indexesDictionary[kPossibleStepPreviousLabelY] intValue];
    //        [_labelsArray[x][y] addSubview:_possibleStepSecondCellView];
    //
    //        _possibleStepShowwing = YES;
    //    }
    //    else
    //    {
    _possibleStepButton.enabled = NO;
    NSInteger sum = 1;//[_manager sumLeftoverNumbers];
    NSString * key = [NSString stringWithFormat:@"%li", (long)sum];
    
    __typeof(self) __weak weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:NSLocalizedString(key, nil)
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"EnterNameViewController_Save", nil)
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [weakSelf _showSaveResultViewControllerResultKey:sum];
                                                        }];
    UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:NSLocalizedString(@"EnterNameViewController_Try_Again", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil];
    [alert addAction:saveAction];
    [alert addAction:tryAgain];
    [self presentViewController:alert animated:YES completion:nil];
    
    //    }
}

- (void)_showSaveResultViewControllerResultKey:(NSInteger)resultKey
{
    SaveResultViewController * saveResultViewController = [SaveResultViewController new];
    saveResultViewController.name = _nameString;
    saveResultViewController.resultKey = resultKey;
    saveResultViewController.birthdayDate = _birthdayDate;
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:saveResultViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

@end
