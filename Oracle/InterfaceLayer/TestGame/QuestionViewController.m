//
//  QuestionViewController.m
//  Oracle
//
//  Created by Ann Kotova on 1/26/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "QuestionViewController.h"
#import "RulesViewController.h"

static const CGFloat kIndent = 20.0f;
static UIFont * _InfoFont() { return [UIFont fontWithName:@"PFHellenicaSerifPro-Light" size:17]; }
static UIFont * _BoldFont() { return [UIFont fontWithName:@"PFHellenicaSerifPro-Bold" size:17]; }

static const CGFloat kButtonSize = 40.0f;

@interface QuestionViewController ()
{
    GameType _gameType;
    NSString * _gameName;
    int _numberOfButtons;
    int _questionsAmount;
    int _questionNumber;
    
    UILabel  * _questionTextView; //UITextView
    NSMutableArray * _buttonsArray;
    
    UIScrollView * _forTestGameAnswersScrollView;
    NSMutableArray<UILabel *> * _answerLabelsForTestGameArray;
    NSArray * _alphabeticForTestGameArray;
    NSDictionary * _answersForTestGameDictionarye;
    int _resultSum;
}
@end

@implementation QuestionViewController

- (instancetype)initWithGameType:(GameType)gameType
                            name:(NSString *)gameName
                 questionsAmount:(int)questionsAmount
          numberOfResponsOptions:(int)numberOfButtons
{
    self = [super init];
    if (self)
    {
        _gameType = gameType;
        _gameName = [gameName copy];
        _questionsAmount = questionsAmount;
        _numberOfButtons = numberOfButtons;
        _questionNumber = 1;
        _resultSum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"images/gameBackground"] drawInRect:self.view.bounds];
    UIImage * backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    self.navigationController.navigationBar.hidden = NO;

    [self _initInterface];
}

- (void)viewDidLayoutSubviews
{
    _questionTextView.center = CGPointMake(CGRectGetMidX(self.view.bounds), kNavigatinBarHeight + kIndent + CGRectGetHeight(_questionTextView.bounds) / 2);
    
    __block CGFloat lastPointY = CGRectGetMaxY(_questionTextView.frame);
    CGFloat margin = self.view.bounds.size.width / 6;
    switch (_gameType)
    {
        case GameTypeImmediatelyResult:
            {
                [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSUInteger indexX = idx % 5;
                    NSUInteger indexY = idx / 5;
                    if (indexX < 3)
                    {
                        //row with 3 buttons
                        button.center = CGPointMake(margin * (indexX * 2 + 1), lastPointY + kIndent + kButtonSize / 2 + (kIndent + kButtonSize) * indexY * 2);
                    }
                    else
                    {
                        //row with 2 buttons
                        indexY = indexY * 2 + 1;
                        button.center = CGPointMake(margin * 2 * (indexX - 2), lastPointY + kIndent + kButtonSize / 2 + (kIndent + kButtonSize) * indexY);
                    }
                }];
            }
            break;
        case GameTypeYesNo:
            {
                [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                    button.center = CGPointMake(CGRectGetWidth(self.view.bounds) * (idx + 1)/ 3, lastPointY + kIndent + kButtonSize / 2);
                }];
            }
            break;
        case GameTypeTest:
            {
                _forTestGameAnswersScrollView.center = CGPointMake(CGRectGetMidX(self.view.bounds), lastPointY + CGRectGetHeight(_forTestGameAnswersScrollView.frame) / 2);
                lastPointY = 0;
                [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
                    button.center = CGPointMake(margin, lastPointY + kIndent + kButtonSize / 2);
                    lastPointY = CGRectGetMaxY(button.frame);
                    UILabel * currentAnswerLabel = self->_answerLabelsForTestGameArray[idx];
                    currentAnswerLabel.frame = CGRectMake(CGRectGetMaxX(button.frame) + kIndent,
                                                          CGRectGetMinY(button.frame),
                                                          CGRectGetWidth(currentAnswerLabel.bounds),
                                                          CGRectGetHeight(currentAnswerLabel.bounds));
                }];
            }
            break;
    }
}

#pragma mark - private methods

- (void)_initInterface
{
    
    UIBarButtonItem * rulesButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"EnterNameViewController_Rules_Button_Title", nil)
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(_rulesButtonTap:)];
    self.navigationItem.rightBarButtonItem = rulesButtonItem;

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat widthOfTextViews = self.view.bounds.size.width - 2 * kIndent;
    
    _questionTextView = [UILabel new];
    _questionTextView.frame = CGRectMake(0, 0, widthOfTextViews, kNavigatinBarHeight * 1.5f);
    _questionTextView.textColor = [UIColor blackColor];
    _questionTextView.font = _BoldFont();
    _questionTextView.textAlignment = NSTextAlignmentCenter;
    _questionTextView.numberOfLines = 2;
//    _questionTextView.editable = NO;
    _questionTextView.contentMode = UIViewContentModeTopLeft;
    //_questionTextView.layer.borderColor = [UIColor redColor].CGColor;
    //_questionTextView.layer.borderWidth = 1;
    [self.view addSubview:_questionTextView];
    
    if (_gameType == GameTypeTest)
    {
        _alphabeticForTestGameArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"]; // 8
        _answerLabelsForTestGameArray = [NSMutableArray new];
        _forTestGameAnswersScrollView = [UIScrollView new];
        _forTestGameAnswersScrollView.contentSize = CGSizeMake(widthOfTextViews, (kButtonSize + kIndent) * _numberOfButtons);
//        _forTestGameAnswersScrollView.layer.borderColor = [UIColor redColor].CGColor;
//        _forTestGameAnswersScrollView.layer.borderWidth = 1;
        _forTestGameAnswersScrollView.frame = CGRectMake(0,
                                                         0,
                                                         widthOfTextViews,
                                                         CGRectGetHeight(self.view.bounds) - kNavigatinBarHeight -CGRectGetHeight(_questionTextView.bounds) - 3 * kIndent);
        [self.view addSubview:_forTestGameAnswersScrollView];
    }

    _buttonsArray = [NSMutableArray array];
    int counter = 0;
    while (counter < _numberOfButtons)
    {
        [_buttonsArray addObject:[self _createButtonAtIndex:counter]];
        
        if (_gameType == GameTypeTest)
        {
            UILabel * answerLabel = [UILabel new];
            answerLabel.frame = CGRectMake(0, 0, widthOfTextViews - kButtonSize - kIndent * 2, kButtonSize);
//            answerLabel.layer.cornerRadius = 5;
//            answerLabel.layer.borderWidth = 2.0;
//            answerLabel.layer.borderColor = [UIColor blackColor].CGColor;
            answerLabel.font = _InfoFont();
            [_forTestGameAnswersScrollView addSubview:answerLabel];
            [_answerLabelsForTestGameArray addObject:answerLabel];
        }
        counter++;
    }
    
    [self _configInterface];
}

- (void)_configInterface
{
    NSString * questionStringKey = [NSString stringWithFormat:@"%@_Question%i", _gameName, _questionNumber];
    _questionTextView.text = NSLocalizedString(questionStringKey, nil);
    NSAssert(_questionTextView.text.length > 0, @"Not found question!!!");
    
    [_answerLabelsForTestGameArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * answerStringKey = [NSString stringWithFormat:@"%@__Question%i_Answer%lu", self->_gameName, self->_questionNumber, (unsigned long)idx + 1];
        label.text = NSLocalizedString(answerStringKey, nil);
    }];
}

- (UIButton *)_createButtonAtIndex:(int)counter
{
    //CGFloat buttonsWidth = 100.0f;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, kButtonSize, kButtonSize);
    switch (_gameType)
    {
        case GameTypeImmediatelyResult:
            [button setTitle:[NSString stringWithFormat:@"%i", counter + 1] forState:UIControlStateNormal];
            break;
        case GameTypeYesNo:
            [button setTitle:(counter == 0 ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil)) forState:UIControlStateNormal];
            break;
        case GameTypeTest:
            [button setTitle:_alphabeticForTestGameArray[counter] forState:UIControlStateNormal];
            break;
     }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font= _InfoFont();
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 2.0;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    [button addTarget:self action:@selector(_onResponsButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    if (_gameType == GameTypeTest)
    {
        [_forTestGameAnswersScrollView addSubview:button];
    }
    else
    {
        [self.view addSubview:button];
    }
    return button;
}

- (void)_onResponsButtonTap:(UIButton *)button
{
    NSUInteger index = [_buttonsArray indexOfObject:button];
    switch (_gameType)
    {
        case GameTypeImmediatelyResult:
            [self _showResponsWithIndex:index];
            break;
        case GameTypeYesNo:
            [self _calculateResaltForGameTypeYesNoWithIndex:index];
            break;
        case GameTypeTest:
            [self _calculateResaltForGameTypeTestWithIndex:index];
            break;
        break;
    }
}

- (void)_showResponsWithIndex:(NSUInteger)index
{
    NSString * responsStringKey = [NSString stringWithFormat:@"%@__Question%i_Respons%lu", _gameName, _questionNumber, (unsigned long)index + 1];
    NSAssert(NSLocalizedString(responsStringKey, nil).length > 0, @"Not found respons!!!");
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:NSLocalizedString(responsStringKey, nil)
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    __typeof(self) __weak weakSelf = self;
    if (_questionNumber == _questionsAmount)
    {
        UIAlertAction * actionTryAgain = [UIAlertAction actionWithTitle:NSLocalizedString(@"Try_Again", nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    __typeof(weakSelf) __strong strongSelf = weakSelf;
                                                                    strongSelf->_questionNumber = 1;
                                                                    [strongSelf _configInterface];
                                                                }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel_Game", nil)
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                                                              }];
        [alert addAction:cancelAction];
        [alert addAction:actionTryAgain];
    }
    else
    {
        _questionNumber++;
        UIAlertAction * action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Next_question", nil)
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            __typeof(weakSelf) __strong strongSelf = weakSelf;
                                                            [strongSelf _configInterface];
                                                        }];
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)_calculateResaltForGameTypeYesNoWithIndex:(NSUInteger)index
{
    if (index == 0)_resultSum++;
    _questionNumber++;

    if (_questionNumber > _questionsAmount)
    {
        [self _showFinalResult];
    }
    else
    {
        [self _configInterface];
    }
}

- (void)_calculateResaltForGameTypeTestWithIndex:(NSUInteger)index
{
    if (!_answersForTestGameDictionarye.count)
    {
        NSString  * path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary * dictionaryOfAll = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSDictionary * gameDictionary = [dictionaryOfAll valueForKey:_gameName];
        _answersForTestGameDictionarye = [gameDictionary valueForKey:@"Answers"];
        NSAssert(_answersForTestGameDictionarye.count > 0, @"Not fount _answersDictionary for test game (key Answers)");
    }
    
    NSString * key = [NSString stringWithFormat:@"Question%i", _questionNumber];
    NSArray * responsArray = _answersForTestGameDictionarye[key];
    NSAssert(responsArray.count > 0 || responsArray.count < index, @"Not found data for key %@ in %@->Answers", key, _gameName);
    
    _resultSum += [responsArray[index] intValue];
    _questionNumber++;
    
    if (_questionNumber > _questionsAmount)
    {
        [self _showFinalResult];
    }
    else
    {
        [self _configInterface];
    }
}

- (void)_showFinalResult
{
    int optimizedSum = _resultSum;
    if (_gameType == GameTypeTest)
    {
        optimizedSum = _resultSum / 5 + 1;
    }
    NSString * responsStringKey = [NSString stringWithFormat:@"%@_Respons%i", _gameName, optimizedSum];
    NSAssert(NSLocalizedString(responsStringKey, nil).length > 0, @"Not found respons for game %@!!!", _gameName);
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:NSLocalizedString(responsStringKey, nil)
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    __typeof(self) __weak weakSelf = self;
    UIAlertAction * actionTryAgain = [UIAlertAction actionWithTitle:NSLocalizedString(@"Try_Again", nil)
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                __typeof(weakSelf) __strong strongSelf = weakSelf;
                                                                strongSelf->_questionNumber = 1;
                                                                strongSelf->_resultSum = 0;
                                                                [strongSelf _configInterface];
                                                            }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel_Game", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                                          }];
    [alert addAction:cancelAction];
    [alert addAction:actionTryAgain];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)_rulesButtonTap:(UIBarButtonItem *)selector
{
//    RulesViewController * rulesViewController = [RulesViewController new];
//    rulesViewController.text = NSLocalizedString(@"RulesViewController_1", nil);
//    [self.navigationController presentViewController:rulesViewController animated:YES completion:nil];
}

@end
