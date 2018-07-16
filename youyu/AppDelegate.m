//
//  AppDelegate.m
//  qtyd
//
//  Created by stephendsw on 15/7/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "AppDelegate.h"
#import "GVUserDefaults.h"
#import "SystemConfigDefaults.h"
#import "QTJsonUtil.h"
#import "QTJsonUtil+Login.h"
#import <AdSupport/AdSupport.h>
#import "CLLockVC.h"
#import "CoreArchive.h"
#import "MainTabBarController.h"
#import <YTKNetwork/YTKNetwork.h>
#import <UMSocialCore/UMSocialCore.h>
#import "AppDelegate+Config.h"
#import "QMUIConfigurationTemplate.h"
#import "QTloginViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Hello World
    
    QTJsonUtil *service = [[QTJsonUtil alloc]init];
    //获取用户的广告标示符
    [service sendIDFAToServer];

    [QMUIConfigurationTemplate applyConfigurationTemplate];
    [self setConfigurationWithOptions:launchOptions];
    [self setupXHLaunchAd];
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabController = [[MainTabBarController alloc] init];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [self startUseGesture];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    if ([shortcutItem.type isEqualToString:@"toInvest"]) {
        [[AppDelegate presentingVC] toInvest];
        
    }else if ([shortcutItem.type isEqualToString:@"toUcenter"]){
        [[AppDelegate presentingVC] toAccount];
    }
}

- (void)startUseGesture {
    BOOL hasPwd = [CLLockVC hasPwd];
    BOOL isLogin = [GVUserDefaults shareInstance].isLogin;
    if(hasPwd&&isLogin) {
        [CLLockVC showVerifyLockVCInVC:self.window.rootViewController  forgetPwdBlock:^{
            [self.window.rootViewController toLogin];
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:1.0f];
        }];
    } else {
        NSLog(@"你还没有设置密码");
    }
}

#pragma mark - Action

+ (UIViewController *)presentingVC {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (void)presentVC:(UIViewController *)viewController {
    if (!viewController) {
        return;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    if (!viewController.navigationItem.leftBarButtonItem) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage qmui_imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(20, 20) tintColor:kColorWhite] style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalViewControllerAnimated:)];
    }
    [[self presentingVC] presentViewController:nav animated:YES completion:nil];
}

+ (void)pushVC:(UIViewController *)viewController {
    if (!viewController) {
        return;
    }
    viewController.hidesBottomBarWhenPushed = YES;
    [[[self presentingVC] navigationController] pushViewController:viewController animated:YES];
}

+ (void)toLoginController {
    QTloginViewController *controller = [QTloginViewController controllerFromXib];
    controller.isBackHome = YES;
    [AppDelegate pushVC:controller];
}

+ (void)toWebViewControllerWithUrl:(NSString *)url {
    YYWebViewController *webVC = [[YYWebViewController alloc] initWithUrlStr:url];
    [AppDelegate pushVC:webVC];
}

@end
