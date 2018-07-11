//
//  UIPagesViewController.m
//  Oracle
//
//  Created by Ann Kotova on 11/13/17.
//  Copyright © 2017 Anna Kotova. All rights reserved.
//

#import "UIPagesViewController.h"
#import "RulesViewController.h"
#import "AppearanceManager.h"

static const int kControllersNumber = 4;

@interface UIPagesViewController ()<UIPageViewControllerDataSource>
{
    UIPageViewController * _pageController;
}
@end

@implementation UIPagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    _pageController.dataSource = self;
    _pageController.view.frame = self.view.bounds;
    [UIPageControl appearance].pageIndicatorTintColor = [AppearanceManager dackColor];
    [UIPageControl appearance].currentPageIndicatorTintColor = [AppearanceManager secondColor];
    
    RulesViewController * rulesViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:rulesViewController];
    
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    [_pageController didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - UIPageViewControllerDataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    return kControllersNumber;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // The selected item reflected in the page indicator.
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(RulesViewController *)viewController index];
    
    if (index == 0)
    {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [(RulesViewController *)viewController index];
    index++;
    if (index == kControllersNumber)
    {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (RulesViewController *)viewControllerAtIndex:(NSUInteger)index
{
    RulesViewController * childViewController = [RulesViewController new];
    childViewController.index = index;
    
    return childViewController;
}

#pragma mark - private methods

- (void)_onSkipButtonTap
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
