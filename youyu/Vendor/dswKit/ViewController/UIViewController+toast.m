//
//  UIViewController+toast.m
//  qtyd
//
//  Created by stephendsw on 15/8/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UIViewController+toast.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "DAlertViewController.h"

static MBProgressHUD *toast;
static MBProgressHUD *HUB;
static MBProgressHUD *CustomHUB;
@implementation UIViewController (toast)

#pragma mark - HUD
- (void)showCustomHUD:(UIView *)view {
    if (!CustomHUB) {
        CustomHUB = [[MBProgressHUD alloc] initWithView:self.view];
    }

    CGRect rect = view.frame;
    CustomHUB.customView = view;
    CustomHUB.margin = 0;
    CustomHUB.color = [UIColor clearColor];
    CustomHUB.dimBackground = YES;
    CustomHUB.mode = MBProgressHUDModeCustomView;

    [self.view addSubview:CustomHUB];
    [self.view bringSubviewToFront:CustomHUB];
    [CustomHUB show:YES];
    CustomHUB.customView.frame = rect;
}

- (void)hideCustomHUB {
    if (CustomHUB) {
        [CustomHUB hide:YES];
    }
}

- (void)showHUD:(NSString *)meg {
    if (!HUB) {
        HUB = [[MBProgressHUD alloc] initWithView:self.view];
        HUB.opacity = 0.6;
        HUB.minShowTime = 0.2;
    }
    HUB.labelText = meg;
    [self.view addSubview:HUB];
    [self.view bringSubviewToFront:HUB];
    [HUB show:YES];
}

- (void)showHUD {
    [self showHUD:@""];
}

- (void)hideHUD {
    if (HUB) {
        [HUB hide:YES];
    }
}

#pragma mark  showmeg
- (void)showMeg:(NSString *)meg {
    [self showMeg:meg cancelTitle:@"确定" block:nil];
}

- (void)showMeg:(NSString *)meg cancelTitle:(NSString *)str {
    [self showMeg:meg cancelTitle:str block:nil];
}

- (void)showMeg:(NSString *)meg block:(alertBlock)block {
    [self showMeg:meg cancelTitle:@"确定" block:block];
}

- (void)showMeg:(NSString *)meg cancelTitle:(NSString *)str block:(alertBlock)block {
    DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"" message:meg];
    [alert addActionWithTitle:str handler:^(CKAlertAction *action) {
        if (block) {
            block(0);
        }
    }];
    [alert show];
}

#pragma mark  toast
- (void)showToast:(NSString *)msg {
    [self showToast:msg duration:1 done:nil];
}

- (void)showToast:(NSString *)msg done:(void (^)())blcok {
    [self showToast:msg duration:1 done:blcok];
}

- (void)showToast:(NSString *)msg duration:(unsigned int)val {
    [self showToast:msg duration:val done:nil];
}

static void extracted(void (^blcok)(), unsigned int val) {
    [toast showAnimated:YES whileExecutingBlock:^{
        // 对话框显示时需要执行的操作
        sleep(val);
    } completionBlock:^{
        // 操作执行完后取消对话框
        [toast removeFromSuperview];
        toast = nil;
        
        if (blcok) {
            blcok();
        }
    }];
}

- (void)showToast:(NSString *)msg duration:(unsigned int)val done:(void (^)())blcok {
    if (val <= 0) {
        val = 3;
    }
    if (!toast) {
        UIWindow *win = [[UIApplication sharedApplication].windows firstObject];
        toast = [[MBProgressHUD alloc] initWithView:win];
        [win addSubview:toast];
        toast.mode = MBProgressHUDModeText;
        toast.detailsLabelText = msg;
//        // 显示对话框
        extracted(blcok, val);
    }
}

@end
