//
//  AppDelegate.h
//  qtyd
//
//
// 引导顺序：  launch（广告页）- navigation(引导页)  - 首页(弹窗)
//
//
//  Created by stephendsw on 15/7/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)presentVC:(UIViewController *)viewController;
+ (void)pushVC:(UIViewController *)viewController;
+ (UIViewController *)presentingVC;

+ (void)toLoginController;
+ (void)toWebViewControllerWithUrl:(NSString *)url;

@end
