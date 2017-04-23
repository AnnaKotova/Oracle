//
//  ChooseGameViewController.m
//  Oracle
//
//  Created by Ann Kotova on 1/25/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "ChooseGameViewController.h"
#import "EnterNameViewController.h"
#import "QuestionViewController.h"

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
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"images/Backgroung"] drawInRect:self.view.bounds];
    UIImage * backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    [self _initInterface];
    [self _extractGamesConfiguration];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews
{
    //CGFloat indent = 20.0f;
    _numberGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) / 5);
    _immedialetyResultGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) * 2 / 5);
    _yesNoGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) * 3 / 5);
    _testGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) * 4 / 5);
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_initInterface
{
    CGFloat buttonsWidth = 300.0f;
    CGFloat buttonsHeight = 30.0f;
    
    _numberGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Number_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _immedialetyResultGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Immedialety_Result_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _yesNoGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Yes_No_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
        [button addTarget:self action:@selector(_onGameButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _testGameButton =({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Test_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
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
            gameName = @"QuestionGame2";
            gameType = GameTypeYesNo;
        }
        else if (button == _testGameButton)
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
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
