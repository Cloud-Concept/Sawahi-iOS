//
//  WebViewController.h
//  Sawahi
//
//  Created by Mina Zaklama on 7/2/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import <UIKit/UIKit.h>
//* SandBox
#define kLoginPageURL @"https://mobileapp-afzamobileapp.cs8.force.com/mobileapp/apex/MobileAppHomePage"
//*/

/* Production
#define kLoginPageURL @"https://afz.force.com/mobileapp/apex/MobileAppHomePage"
//*/

@interface WebViewController : UIViewController <UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
