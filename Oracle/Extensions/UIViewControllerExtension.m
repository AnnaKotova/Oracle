//
//  UIViewControllerExtension.m
//  Oracle
//
//  Created by Ann Kotova on 1/12/17.
//  Copyright © 2017 Bmuse. All rights reserved.
//

#import "UIViewControllerExtension.h"

@implementation UIViewController (UIViewControllerExtension)

+ (UIViewController *)visibleViewController
{
    UIViewController * visibleViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    if ([visibleViewController isKindOfClass:[UINavigationController class]])
    {
        visibleViewController = [(UINavigationController *)visibleViewController visibleViewController];
    }
    
    while (visibleViewController.presentedViewController)
    {
        visibleViewController = visibleViewController.presentedViewController;
    }
    return visibleViewController;
}

@end
