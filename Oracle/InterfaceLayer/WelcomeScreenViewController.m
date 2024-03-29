//
//  WelcomeScreenViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/5/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "DecorationManager.h"
#import "ChooseGameViewController.h"

@interface WelcomeScreenViewController ()
{
    UIImageView * _tableImageView;
    UIImageView * _globeImageView;
    UIImageView * _arrowImageView;
    UILabel * _welcomeLabel;
}
@end

@implementation WelcomeScreenViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self _initInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [self _startAnimations];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    CGFloat tableWidth = CGRectGetWidth(_tableImageView.frame);
    CGFloat tableHeight = CGRectGetHeight(_tableImageView.frame);
    CGFloat koef = viewHeight * 0.33 / tableHeight;
    
    _tableImageView.frame = CGRectMake(0, 0, tableWidth * koef, viewHeight * 0.33);
    _tableImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_tableImageView.bounds) / 2);
    
    _globeImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_globeImageView.frame) * koef, CGRectGetHeight(_globeImageView.frame) * koef);
    _globeImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(_tableImageView.frame) - CGRectGetHeight(_globeImageView.bounds) * 0.42);
    
//    _arrowImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_arrowImageView.frame) * koef, CGRectGetHeight(_arrowImageView.frame) * koef);
//    _arrowImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(_globeImageView.frame) - CGRectGetHeight(_arrowImageView.bounds));
    
    CGFloat offset = CGRectGetHeight(self.view.bounds) * 0.05;
    CGFloat welcomeLabelHeight = CGRectGetMinY(_globeImageView.frame) - offset * 2.0f;
    
    _welcomeLabel.frame = CGRectMake(offset, offset, CGRectGetWidth(self.view.bounds) - 2 * offset, welcomeLabelHeight);
    
//    _arrowImageView.hidden = (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation));
}

#pragma mark - private methods

- (void)_initInterface
{
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    background.contentMode = UIViewContentModeScaleToFill;
    background.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    background.frame = self.view.bounds;
    
    _tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/TableImage"]];
    _globeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/Globe"]];
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ViewControllers/WelcomeScreenViewController/Arrow"]];
    
    _tableImageView.contentMode = UIViewContentModeScaleAspectFit;
    _globeImageView.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _welcomeLabel = [UILabel new];
    _welcomeLabel.text = NSLocalizedString(@"WelcomeScreenViewController_Welcom_Label_Text", nil);
    _welcomeLabel.font = [DecorationManager mainFontWithSize:26.0f];
    _welcomeLabel.textColor = [DecorationManager mainTextColor];
    _welcomeLabel.numberOfLines = 0;
    _welcomeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:background];
    [self.view addSubview:_tableImageView];
    [self.view addSubview:_globeImageView];
//    [self.view addSubview:_arrowImageView];
    [self.view addSubview:_welcomeLabel];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onGlobeTap:)];
    //_globeImageView.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)_onGlobeTap:(UITapGestureRecognizer *)gestureRecognizer
{
    ChooseGameViewController * chooseGameViewController = [ChooseGameViewController new];
    [self.navigationController pushViewController:chooseGameViewController animated:YES];
}

- (void)_startAnimations
{
    //arrow animation
    CGFloat offset = 20.0f;
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         CGRect frame = self->_arrowImageView.frame;
                         frame.origin.y += offset;
                         self->_arrowImageView.frame = frame;
                     }
                     completion:nil];
    
    //globe animation
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];  /* full rotation*/
    rotationAnimation.duration = 10.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = FLT_MAX;
    
    [_globeImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
@end
