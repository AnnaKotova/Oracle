//
//  AppDelegate.m
//  Oracle
//
//  Created by Ann Kotova on 7/21/15.
//  Copyright (c) 2015 Anna Kotova. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeScreenViewController.h"
#import "AppearanceManager.h"
#import "NumericPlayFieldViewController.h"
@import Firebase;
@import GoogleMobileAds;

NSString * const kAdMobUnitID = @"ca-app-pub-6318623414577161~9364708687";//@"ca-app-pub-3940256099942544/4411468910"; - testkey

NSString * const kNeedOpenLastGame = @"needOpenLastGameKey";

@interface AppDelegate ()<GADFullScreenContentDelegate>

@property(nonatomic) GADAppOpenAd*  appOpenAd;
@property NSDate*  loadAdTime;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [[AppearanceManager sharedManager] configInterfaceAppearance:self.window.frame];

    WelcomeScreenViewController * welcomeScreenViewController = [WelcomeScreenViewController new];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:welcomeScreenViewController];
    navigationController.navigationBar.hidden = YES;
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self tryToPresentAd];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    UINavigationController * navigationController = (UINavigationController *)self.window.rootViewController;
    if([navigationController.visibleViewController isKindOfClass:[NumericPlayFieldViewController class]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kNeedOpenLastGame];
        NumericPlayFieldViewController * numericPlayFieldViewController = (NumericPlayFieldViewController *)navigationController.visibleViewController;
        numericPlayFieldViewController.needToSaveManagerState = YES;
        [numericPlayFieldViewController saveManagerStateIdNeeded];
    }
}

#pragma mark - GADAppOpenAd

- (void)_requestAppOpenAd
{
    __weak typeof(self) weakSelf = self;
    [GADAppOpenAd loadWithAdUnitID:kAdMobUnitID
                           request:[GADRequest request]
                       orientation:UIInterfaceOrientationPortrait
                 completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return;
            if (error)
            {
                NSLog(@"Failed to load app open ad: %@", error);
                [FIRAnalytics logEventWithName:@"AdMobError"
                parameters:@{ @"error": error.description
                            }];
            }
            else
            {
                strongSelf.appOpenAd = appOpenAd;
                strongSelf.appOpenAd.fullScreenContentDelegate = strongSelf;
                strongSelf.loadAdTime = [NSDate date];
            }
        });
    }];
}

- (BOOL)_wasLoadTimeLessThanNHoursAgo:(int)n {
    NSDate *now = [NSDate date];
    NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:self.loadAdTime];
    double secondsPerHour = 3600.0;
    double intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
    return intervalInHours < n;
}

- (void)tryToPresentAd
{
    if (self.appOpenAd && [self _wasLoadTimeLessThanNHoursAgo:4])
    {
        UIViewController *rootController = self.window.rootViewController;
        [self.appOpenAd presentFromRootViewController:rootController];
    }
    else
    {
        [self _requestAppOpenAd];
    }
}

#pragma mark - GADFullScreenContentDelegate

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error
{
    //NSLog(@"Failed to present app open ad: %@", error);
    [FIRAnalytics logEventWithName:@"AdMobPresentError"
    parameters:@{ @"error": error.description
                }];
    self.appOpenAd = nil;
    [self _requestAppOpenAd];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad
{
    self.appOpenAd = nil;
    [self _requestAppOpenAd];
}
@end
