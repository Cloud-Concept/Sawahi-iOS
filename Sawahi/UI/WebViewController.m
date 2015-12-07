//
//  WebViewController.m
//  Sawahi
//
//  Created by Mina Zaklama on 7/2/14.
//  Copyright (c) 2014 Cloud Concept. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self retrieveCookies];
    [self addSwipeGestureToWebView];
    [self reloadView:[[NSURL alloc] initWithString:kLoginPageURL]];
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetLisener:) name:kReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];
}
-(void)internetLisener:(NSNotification*)notif{
    Reachability* curReach = [notif object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
//    NSLog(@"URI ------ %@ ",[[self.webView request] URL]);
    if([curReach currentReachabilityStatus] != NotReachable)
    {
        [self reloadView:([[[self.webView request] URL] absoluteString].length)?[[self.webView request] URL]:[[NSURL alloc] initWithString:kLoginPageURL]];
    }
}
//-(void)refreshView:(NSNotification*)notif{
//    NSLog(@"URI : ------ %@",[[self.webView request] URL] );
//    if([[notif name] isEqualToString:@"refreshView"])
//        [self reloadView:([[self.webView request] URL])?[[self.webView request] URL]:[[NSURL alloc] initWithString:kLoginPageURL]];
//}
-(void)reloadView:(NSURL*)URI{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URI];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSwipeGestureToWebView
{
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [self.webView addGestureRecognizer:swipeRight];
}

- (void)swipeRightAction:(id)ignored
{
    NSLog(@"Swipe Right");
    //add Function
    
    NSString *url = [[[self.webView request] URL]absoluteString];
    if([self.webView canGoBack]
       && [url rangeOfString:@"MobileAppHomePage"].location == NSNotFound
       && [url rangeOfString:@"MobileAppCustomLogin"].location == NSNotFound
       && [url rangeOfString:@"MobileAppThankYou"].location == NSNotFound
       && [url rangeOfString:@"MobileAppContactUsThankYou"].location == NSNotFound
       && [url rangeOfString:@"MobileAppSuggestionThankYou"].location == NSNotFound
       && [url rangeOfString:@"MobileAppForgotPasswordThankYou"].location == NSNotFound
       && [url rangeOfString:@"MobileAppCompanyNotValidError"].location == NSNotFound)
        [self.webView goBack];
}

- (void)saveCookies
{
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    
    [defaults setObject: cookiesData forKey: @"cookies"];
    [defaults synchronize];
}

- (void)deleteCookies
{
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"cookies"];
    [defaults synchronize];

}

- (void)retrieveCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"cookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies)
    {
        [cookieStorage setCookie: cookie];
    }
}

#pragma UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *url = [[[webView request] URL]absoluteString];
    NSLog(@"UR ---- %@",url);
    if ([url rangeOfString:@"MobileAppHomePage"].location != NSNotFound) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD showWithStatus:@"Loading..."];
            });
        });
    }
    if([url rangeOfString:@"MobileAppHomePage"].location != NSNotFound)
        [self saveCookies];
    else if([url rangeOfString:@"Logout"].location != NSNotFound)
        [self deleteCookies];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
//     if ([[[[webView request] URL]absoluteString] rangeOfString:@"MobileAppHomePage"].location != NSNotFound)
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
//        });
//    });
}

@end
