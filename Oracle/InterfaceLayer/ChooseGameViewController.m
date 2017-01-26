//
//  ChooseGameViewController.m
//  Oracle
//
//  Created by Ann Kotova on 1/25/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "ChooseGameViewController.h"
#import "EnterNameViewController.h"

@interface ChooseGameViewController ()
{
    UIButton * _numberGame;
    UIButton * _testGame;
}
@end

@implementation ChooseGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.hidden = YES;
    
    CGFloat buttonsWidth = 300.0f;
    CGFloat buttonsHeight = 30.0f;
    
    _numberGame = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Number_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
        [button addTarget:self action:@selector(_onGameButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    _testGame = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:NSLocalizedString(@"ChooseGameViewController_Number_Game", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 2.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.frame = CGRectMake(0, 0, buttonsWidth, buttonsHeight);
        [button addTarget:self action:@selector(_onGameButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)viewDidLayoutSubviews
{
    _numberGame.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [super viewDidLayoutSubviews];
}

#pragma mark - private methods

- (void)_onGameButtonTap
{
    EnterNameViewController * enterNameViewController =  [EnterNameViewController new];
    [self.navigationController pushViewController:enterNameViewController animated:YES];
}
@end
