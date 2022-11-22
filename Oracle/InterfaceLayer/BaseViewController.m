//
//  BaseViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/4/18.
//  Copyright © 2018 Anna Kotova. All rights reserved.
//

#import "BaseViewController.h"

CGFloat const kNavigationBarHeight = 44.0f;

@interface BaseViewController ()
{
    UIImageView * _backgroundImageView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gameBackground"]];
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//    tintColor = [UIColor colorWithRed:32.0f/255.0f green:46.0f/255.0 blue:116.0f/255.0 alpha:1];[UIColor colorWithRed:94.0f/255.0f green:107.0f/255.0 blue:181.0f/255.0 alpha:1];
//    _backgroundImageView.frame = self.view.frame;
    [self.view addSubview:_backgroundImageView];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:32.0f/255.0f green:46.0f/255.0 blue:116.0f/255.0 alpha:0.1];
}

- (void)viewDidLayoutSubviews
{
//    CGRect frame = self.view.frame;
//    if (!self.navigationController.navigationBar.hidden)
//    {
//        frame.origin.y = CGRectGetMinY(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.navigationController.navigationBar.frame);
//        frame.size.height -= frame.origin.y;
//    }
    _backgroundImageView.frame = self.view.frame;
    
    [super viewDidLayoutSubviews];
}


@end
