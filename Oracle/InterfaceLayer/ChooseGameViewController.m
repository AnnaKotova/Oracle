//
//  ChooseGameViewController.m
//  Oracle
//
//  Created by Ann Kotova on 1/25/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import "ChooseGameViewController.h"
#import "EnterNameViewController.h"
#import "QuestionViewController.h"
#import "DecorationManager.h"

static CGFloat const kWidthKoef = 0.8f;

@interface ChooseGameViewController ()
{
    UIButton * _numberGameButton;
    UIButton * _immedialetyResultGameButton;
    UIButton * _yesNoGameButton;
    UIButton * _testGameButton;
    
    NSDictionary * _configDictionary;
}
@end

@implementation ChooseGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    background.contentMode = UIViewContentModeScaleToFill;
    background.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    background.frame = self.view.bounds;
    [self.view addSubview:background];

    [self _initInterface];
    [self _extractGamesConfiguration];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLayoutSubviews
{
    if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation))
    {
        CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
        CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
        CGFloat smallerSide = (viewWidth > viewHeight ? viewHeight : viewWidth);

        CGFloat buttonWidth = _numberGameButton.frame.size.width;
        CGFloat buttonHeight = _numberGameButton.frame.size.height;
        
        CGFloat newButtonWidth = smallerSide * kWidthKoef;
//        if (newButtonWidth < buttonWidth)
        {
            CGFloat koef = newButtonWidth / buttonWidth;
            buttonWidth = newButtonWidth;
            buttonHeight = buttonHeight * koef;
        }
        
        CGRect frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        _numberGameButton.frame = frame;
        _immedialetyResultGameButton.frame = frame;
        _yesNoGameButton.frame = frame;
        _testGameButton.frame = frame;
        
        _numberGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) / 5);
        _immedialetyResultGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) * 2 / 5);
        _yesNoGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) * 3 / 5);
        _testGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) * 4 / 5);
    }
    else
    {
        if (CGRectGetWidth(self.view.frame) * kWidthKoef < CGRectGetWidth(_numberGameButton.frame) * 2)
        {
            CGRect buttonRect = _numberGameButton.bounds;
            buttonRect.size.width = CGRectGetWidth(self.view.frame) * kWidthKoef / 2.0f;
            buttonRect.size.height = buttonRect.size.height * buttonRect.size.width / CGRectGetWidth(_numberGameButton.bounds);
            _numberGameButton.frame = buttonRect;
            _immedialetyResultGameButton.frame = buttonRect;
            _yesNoGameButton.frame = buttonRect;
            _testGameButton.frame = buttonRect;
        }
        
        _numberGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame) / 2.0f, CGRectGetHeight(self.view.frame) / 3);
        _immedialetyResultGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame) / 2.0f, CGRectGetHeight(self.view.frame) * 2 / 3);
        _yesNoGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame) * 1.5f, CGRectGetHeight(self.view.frame) / 3);
        _testGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame) * 1.5f, CGRectGetHeight(self.view.frame) * 2 / 3);
    }
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_initInterface
{
    UIImage * image = [UIImage imageNamed:@"ViewControllers/ChooseGameViewController/GameNameButtonBackgroundImage"];
    
    CGFloat buttonWidth = image.size.width;
    CGFloat buttonHeight = image.size.height;
    CGRect frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    
    _numberGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Number_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [DecorationManager mainFontWithSize:22];
        button.frame = frame;
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _immedialetyResultGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Immedialety_Result_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [DecorationManager mainFontWithSize:24];
        button.frame = frame;
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _yesNoGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Yes_No_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [DecorationManager mainFontWithSize:24];
        button.frame = frame;
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _testGameButton =({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Test_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [DecorationManager mainFontWithSize:24];
        button.frame = frame;
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)_extractGamesConfiguration
{
    NSString  * path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    _configDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (void)_onGameButtonTap:(UIButton *)button
{
    UIViewController * viewController;
    if (button == _numberGameButton)
    {
        viewController =  [EnterNameViewController new];
    }
    else
    {
        NSString * gameName = nil;
        GameType gameType;
        if (button == _immedialetyResultGameButton)
        {
            gameName = @"TruthOracle";
            gameType = GameTypeImmediatelyResult;
        }
        else if (button == _yesNoGameButton)
        {
            gameName = @"YesNoGame";
            gameType = GameTypeYesNo;
        }
        else //if (button == _testGameButton)
        {
            gameName = @"TestGame";
            gameType = GameTypeTest;
        }
        NSAssert(gameName.length > 0, @"Unknown game!");
        
        NSDictionary * gameDictionary = _configDictionary[gameName];
        int questionsAmount = [gameDictionary[@"QuestionsAmount"] intValue];
        int numberOfResponsOptions = [gameDictionary[@"NumberOfResponsOptions"] intValue];
        
        viewController = [[QuestionViewController alloc] initWithGameType:gameType
                                                                     name:gameName
                                                          questionsAmount:questionsAmount
                                                   numberOfResponsOptions:numberOfResponsOptions];
    }
    [self.navigationController  pushViewController:viewController animated:YES];
}

- (void)_backButtonTap
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
