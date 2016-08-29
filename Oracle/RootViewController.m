//
//  ViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/21/15.
//  Copyright (c) 2015 Bmuse. All rights reserved.
//

#import "RootViewController.h"
#import "EnterNameViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _runSpinAnimationOnView:self.generalImageView duration:1 rotations:1 repeat:1];
//    [UIView animateWithDuration:20.0
//                          delay:0.0
//                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         self.generalImageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
//                     }
//                     completion:^(BOOL finished)
//                     {
//                     }];
    
    
//    self.generalImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onGeneralImageTap)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)_onGeneralImageTap
{
    EnterNameViewController* enterNameViewController =  [[EnterNameViewController alloc] init];
    [self.navigationController pushViewController:enterNameViewController animated:YES];
}

@end
