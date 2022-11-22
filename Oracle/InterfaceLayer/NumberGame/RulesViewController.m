//
//  RulesViewController.m
//  Oracle
//
//  Created by Ann Kotova on 4/27/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import "RulesViewController.h"
#import "AppearanceManager.h"

@interface RulesViewController ()
{
    UIButton * _skipButton;
    UILabel * _label;
    UIImageView * _imageView;
    UIButton * _startPlayButton;
}
@end

@implementation RulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_skipButton setTitle:NSLocalizedString(@"Skip", @"Skip") forState:UIControlStateNormal];
    [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _skipButton.titleLabel.font = [AppearanceManager appFontWithSize:18];
    [_skipButton addTarget:self action:@selector(_tapStartPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipButton];
    
    _label = [UILabel new];
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    _label.contentMode = UIViewContentModeCenter;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [[AppearanceManager sharedManager] appFont];
    [self.view addSubview:_label];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    [self _configInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat indent = 10.0f;
    
    CGFloat skipButtonY = 0;
    if (@available(iOS 11.0, *))
    {
        skipButtonY = self.view.safeAreaInsets.top;
    }
    
    _skipButton.frame = CGRectMake(0,
                                   skipButtonY,
                                   [AppearanceManager sharedManager].smallButtonsWidth,
                                   44.0f);
    
    CGFloat labelHeight = ( (_index == 2 || _index == 0)
                           ? CGRectGetHeight(self.view.frame) / 2.0f
                           : CGRectGetHeight(self.view.frame) / 5.0f);
    CGFloat indentsCount = ( (_index == 2)
                            ? 2.0f
                            : 6.0f);
    _label.frame = CGRectMake(indent,
                              CGRectGetMaxY(_skipButton.frame),
                              CGRectGetWidth(self.view.frame) - indent * 2,
                              labelHeight);
    _imageView.frame = CGRectMake(0,
                                  CGRectGetMaxY(_label.frame) + indent,
                                  CGRectGetWidth(self.view.frame),
                                  CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_label.frame) - CGRectGetHeight(_startPlayButton.frame) - indentsCount * indent);
    _startPlayButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(_imageView.frame) + CGRectGetHeight(_startPlayButton.frame));
}

- (void)_configInterface
{
    switch (_index)
    {
        case 0:
        {
            _label.text = NSLocalizedString(@"RulesViewController_Page0", nil);
        }
            break;
        case 1:
        {
            _label.text = NSLocalizedString(@"RulesViewController_Page1", nil);
            _imageView.image = [UIImage imageNamed:@"ViewControllers/Rules/Page1"];
        }
            break;
        case 2:
        {
            _label.text = NSLocalizedString(@"RulesViewController_Page2", nil);
            _label.textAlignment = NSTextAlignmentLeft;
            _imageView.image = [UIImage imageNamed:@"ViewControllers/Rules/Page2"];
        }
            break;
        case 3:
        {
            _label.text = NSLocalizedString(@"RulesViewController_Page3", nil);
            _imageView.image = [UIImage imageNamed:@"ViewControllers/Rules/Page3"];
            
            _startPlayButton = [[AppearanceManager sharedManager] buttonWithTitle:NSLocalizedString(@"RulesViewController_Page6_Button", nil)];
            [_startPlayButton addTarget:self action:@selector(_tapStartPlayButton:) forControlEvents:UIControlEventTouchUpInside];
            _startPlayButton.frame = CGRectMake(0, 0, [AppearanceManager sharedManager].buttonsWidth, [AppearanceManager sharedManager].buttonsHeight);
            [self.view addSubview:_startPlayButton];
        }
            break;
    }
}

- (void)_tapStartPlayButton:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
