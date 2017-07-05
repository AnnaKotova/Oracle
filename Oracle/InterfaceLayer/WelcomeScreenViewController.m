//
//  WelcomeScreenViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/5/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "WelcomeScreenViewController.h"

@interface WelcomeScreenViewController ()
{
    UIImageView * _tableImageView;
    UIImageView * _globeImageView;
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
}

#pragma mark - private methods

- (void)_initInterface
{
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    background.contentMode = UIViewContentModeScaleToFill;
    background.frame = self.view.bounds;
    
    _tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/TableImage"]];
    
    _globeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/Globe"]];
    
    [self.view addSubview:background];
    [self.view addSubview:_tableImageView];
    [self.view addSubview:_globeImageView];
}

@end
