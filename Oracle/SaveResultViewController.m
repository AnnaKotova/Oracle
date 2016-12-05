//
//  SaveResultViewcontrollerViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/5/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import "SaveResultViewController.h"

static const CGFloat imageViewSize = 220.0f;

@interface SaveResultViewController ()
{
    UIImageView * _thumbnailImageView;
}
@end

@implementation SaveResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 4.0f;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _thumbnailImageView = [UIImageView new];
    _thumbnailImageView.frame = CGRectMake(0, 0, imageViewSize, imageViewSize);
    _thumbnailImageView.backgroundColor = [UIColor grayColor];
    _thumbnailImageView.layer.cornerRadius = 4.0f;
    [self.view addSubview:_thumbnailImageView];

    UILabel * addIcon = [UILabel new];
    addIcon.frame = _thumbnailImageView.frame;
    addIcon.text = NSLocalizedString(@"SaveResultViewController_Add_Icon_Label_Text", nil);
    addIcon.textColor = [UIColor whiteColor];
    addIcon.textAlignment = NSTextAlignmentCenter;
    addIcon.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_thumbnailImageView addSubview:addIcon];
    
    //UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onIconTap:)];
    
}

- (void)viewDidLayoutSubviews
{
    _thumbnailImageView.center = CGPointMake(self.view.bounds.size.width / 2, 30.0 + imageViewSize / 2);
    [super viewDidLayoutSubviews];
}
@end
