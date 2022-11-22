//
//  BaseViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/4/18.
//  Copyright © 2018 Anna Kotova. All rights reserved.
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
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gameBackground"]];
//    tintColor = [UIColor colorWithRed:32.0f/255.0f green:46.0f/255.0 blue:116.0f/255.0 alpha:1];[UIColor colorWithRed:94.0f/255.0f green:107.0f/255.0 blue:181.0f/255.0 alpha:1];
    [self.view addSubview:_backgroundImageView];

}

- (void)viewDidLayoutSubviews
{
    CGRect frame = self.view.frame;
//    if (!self.navigationController.navigationBar.hidden)
//    {
//        frame.origin.y = CGRectGetMinY(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.navigationController.navigationBar.frame);
//        frame.size.height -= frame.origin.y;
//    }
    _backgroundImageView.frame = frame;
    
    [super viewDidLayoutSubviews];
}


@end
