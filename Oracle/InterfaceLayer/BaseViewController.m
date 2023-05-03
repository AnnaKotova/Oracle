//
//  BaseViewController.m
//  Oracle
//
//  Created by Ann Kotova on 7/4/18.
//  Copyright © 2018 Anna Kotova. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@import GoogleMobileAds;

CGFloat const kNavigationBarHeight = 44.0f;

@interface BaseViewController ()<GADFullScreenContentDelegate>
{
    UIImageView * _backgroundImageView;
}
@property(nonatomic, strong) GADInterstitialAd *interstitial;
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
    
    [self _requestAppOpenAd];
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

#pragma mark - GADAppOpenAd

- (void)tryToPresentAd
{
    if (self.interstitial)
    {
        [self.interstitial presentFromRootViewController:self];
    }
    else
    {
        [self _requestAppOpenAd];
    }
}

- (void)_requestAppOpenAd
{
    __weak typeof(self) weakSelf = self;
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:kAdMobUnitID
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return;
            if (error) {
                NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
                return;
            }
            strongSelf.interstitial = ad;
            strongSelf.interstitial.fullScreenContentDelegate = self;
        });
    }];
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
    self.interstitial = nil;
    [self _requestAppOpenAd];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did dismiss full screen content.");
    self.interstitial = nil;
    [self _requestAppOpenAd];
}
@end
