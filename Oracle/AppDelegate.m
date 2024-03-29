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

NSString * const kNeedOpenLastGame = @"needOpenLastGameKey";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

@end
