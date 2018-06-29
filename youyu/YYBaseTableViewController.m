//
//  YYBaseTableViewController.m
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYBaseTableViewController.h"

@interface YYBaseTableViewController ()

@end

@implementation YYBaseTableViewController

- (void)didInitialize {
    [super didInitialize];
}

- (NSNumber *)getPageSize {
    return @20;
}

- (MJRefreshNormalHeader *)getHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    return refreshHeader;
}

- (MJRefreshAutoNormalFooter *)getFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.stateLabel.hidden = YES;
    return footer;
}

#pragma mark - QMUINavigationControllerDelegate
- (nullable UIColor *)titleViewTintColor {
    return NavBarTintColor;
}

- (nullable UIColor *)navigationBarTintColor {
    return NavBarTintColor;
}

- (UIImage *)navigationBarBackgroundImage {
    return NavBarBackgroundImage;
}

- (nullable UIImage *)navigationBarShadowImage {
    return NavBarShadowImage;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
    return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
    return YES;
}

#pragma mark QMUIKeyboard
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

@end
