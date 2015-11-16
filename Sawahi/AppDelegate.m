//
//  AppDelegate.m
//  Sawahi
//
//  Created by Mina Zaklama on 7/2/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "WebViewController.h"
#import "NoInternetPopoverViewController.h"
#import "CustomIOS7AlertView.h"

@implementation AppDelegate

- (CustomIOS7AlertView*) customAlertView{
    if(_customAlertView)
        return _customAlertView;
    
    _customAlertView = [[CustomIOS7AlertView alloc] init];
    
    NoInternetPopoverViewController *noInternetPopoverViewController = [[NoInternetPopoverViewController alloc] initNoInternetPopoverViewController];
    
    [_customAlertView setContainerView:noInternetPopoverViewController.view];
    [_customAlertView setButtonTitles:nil];
    
    [_customAlertView setUseMotionEffects:true];
    
    return _customAlertView;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    /*
     NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
     
     NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
     
     [defaults setObject: cookiesData forKey: @"cookies"];
     [defaults synchronize];
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        isBackground = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [self reachabilityChanged:[NSNotification notificationWithName:@"" object:self.reachability]];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)notification
{
    Reachability* curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    if([curReach currentReachabilityStatus] != NotReachable)
    {
        if([self.customAlertView isVisible]) {
            [self.customAlertView close];
        }
        if(!isBackground){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
        }
//        [self.mainViewController.webView reload];

    }
    else
    {
        if(![self.customAlertView isVisible]) {
            [self.customAlertView show];
        }
    }
}

@end
