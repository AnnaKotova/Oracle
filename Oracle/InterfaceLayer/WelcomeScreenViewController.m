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
}
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    background.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:background];
    
    [self _initInterface];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_tableImageView.bounds) / 2);
}

#pragma mark - private methods

- (void)_initInterface
{
    _tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/TableImage"]];
    [self.view addSubview:_tableImageView];
}

@end
