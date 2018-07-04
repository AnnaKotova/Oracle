//
//  BaseViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/4/18.
//  Copyright © 2018 Bmuse. All rights reserved.
//

#import "BaseViewController.h"

CGFloat const kNavigatinBarHeight = 44.0f;

@interface BaseViewController ()
{
    UIImageView * _backgroundImageView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/gameBackground"]];
    [self.view addSubview:_backgroundImageView];

}

- (void)viewDidLayoutSubviews
{
    CGRect frame = self.view.frame;
    frame.origin.y = kNavigatinBarHeight;
    frame.size.height -= kNavigatinBarHeight;
    _backgroundImageView.frame = frame;
    
    [super viewDidLayoutSubviews];
}


@end
