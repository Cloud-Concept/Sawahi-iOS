//
//  AppDelegate.h
//  Sawahi
//
//  Created by Mina Zaklama on 7/2/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
//@class WebViewController;
@class CustomIOS7AlertView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CustomIOS7AlertView *_customAlertView;
//    BOOL isBackground;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *reachability;
//@property (strong, nonatomic) WebViewController *mainViewController;
@property (strong, nonatomic) UIAlertView *alertView;
//@property (nonatomic) UIPopoverController *noInternetPopover;

@end
