//
//  QTNavigationController.m
//  qtyd
//
//  Created by stephendsw on 15/9/28.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTNavigationController.h"
#import "QTTheme.h"
#import "UIViewController+xib.h"
#import "UIViewController+toast.h"
#import "UIView+layout.h"
#import "QTJsonUtil.h"
#import "SystemConfigDefaults.h"
#import "QTAdView.h"
#import "QTWebViewController.h"

@interface QTNavigationController ()

@end

@implementation QTNavigationController {
    // 是否显示ad
    BOOL isShow;
    QTJsonUtil *service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    service = [QTJsonUtil new];
    [QTTheme navigationBar];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [Theme mainOrangeColor];
    [self.navigationBar setShadowImage:[UIImage new]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [AppUtil onceAction:@"launch" block:^{
    
    } otherBlock:^{
        [self commonADJson];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)commonADJson {}

@end
