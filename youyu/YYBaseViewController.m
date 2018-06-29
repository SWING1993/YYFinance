//
//  YYBaseViewController.m
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYBaseViewController.h"

@interface YYBaseViewController ()<QMUINavigationControllerDelegate>

@end

@implementation YYBaseViewController

- (void)didInitialize {
    [super didInitialize];
}

#pragma mark - QMUINavigationControllerDelegate
- (nullable UIColor *)titleViewTintColor {
    return NavBarTintColor;
}

- (nullable UIColor *)navigationBarTintColor {
    return NavBarTitleColor;
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
