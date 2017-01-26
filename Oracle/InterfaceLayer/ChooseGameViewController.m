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
    UIButton * _questionGameButton;
}
@end

@implementation ChooseGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = YES;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"images/Backgroung"] drawInRect:self.view.bounds];
    UIImage * backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    [self _initInterface];
}

- (void)viewDidLayoutSubviews
{
    CGFloat indent = 20.0f;
    _numberGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) - indent - CGRectGetHeight(_numberGameButton.bounds) / 2);
    _questionGameButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(_numberGameButton.frame) + indent + CGRectGetHeight(_questionGameButton.bounds) / 2);
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
        [button addTarget:self action:@selector(_onGameButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _questionGameButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Test_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
        [button addTarget:self action:@selector(_onTestButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)_onGameButtonTap
{
    EnterNameViewController * enterNameViewController =  [EnterNameViewController new];
    [self.navigationController pushViewController:enterNameViewController animated:YES];
}

- (void)_onTestButtonTap
{
    QuestionViewController * questionViewController = [QuestionViewController new];
    [self.navigationController pushViewController:questionViewController animated:YES];
}
@end
