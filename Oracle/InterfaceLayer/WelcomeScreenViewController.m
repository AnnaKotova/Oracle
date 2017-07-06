//
//  WelcomeScreenViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/5/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "DecorationManager.h"

@interface WelcomeScreenViewController ()
{
    UIImageView * _tableImageView;
    UIImageView * _globeImageView;
    UIImageView * _arrowImageView;
    UILabel * _welcomeLabel;
}
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self _initInterface];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _tableImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_tableImageView.bounds) / 2);
    _globeImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.56);
    _arrowImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.35);
    
    CGFloat offset = CGRectGetHeight(self.view.bounds) * 0.05;//100.0f;
    _welcomeLabel.frame = CGRectMake(offset, offset, CGRectGetWidth(self.view.bounds) - 2 * offset, CGRectGetHeight(self.view.bounds) * 0.25);
}

#pragma mark - private methods

- (void)_initInterface
{
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    background.contentMode = UIViewContentModeScaleToFill;
    background.frame = self.view.bounds;
    
    _tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/TableImage"]];
    _globeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/Globe"]];
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/Arrow"]];
    
    _welcomeLabel = [UILabel new];
    _welcomeLabel.text = NSLocalizedString(@"WelcomeScreenViewController_Welcom_Label_Text", nil);
    _welcomeLabel.font = [DecorationManager mainFontWithSize:24.0f];
    _welcomeLabel.textColor = [DecorationManager mainTextColor];
    _welcomeLabel.backgroundColor = [UIColor redColor];
    _welcomeLabel.numberOfLines = 3;
    _welcomeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:background];
    [self.view addSubview:_tableImageView];
    [self.view addSubview:_globeImageView];
    [self.view addSubview:_arrowImageView];
    [self.view addSubview:_welcomeLabel];
}

@end
