//
//  UIViewController+menu.m
//  qtyd
//
//  Created by stephendsw on 15/8/13.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UIViewController+menu.h"

#import "UIViewController+page.h"

#import "GVUserDefaults.h"
#import "UIViewController+toast.h"

#import "QTTheme.h"
#import "MenuViewController.h"

@implementation UIViewController (menu)

#pragma  mark - menu
- (void)showMenu {
    [self hideCustomHUB];

    NSArray *menuItems;

    if (![GVUserDefaults  shareInstance].isLogin) {
        menuItems =
            @[

            [KxMenuItem menuItem:@"首页"
                        image   :nil
                        target  :self
                        action  :@selector(toHome)],

            [KxMenuItem menuItem:@"登录"
                        image   :nil
                        target  :self
                        action  :@selector(loginAccount)],

            [KxMenuItem menuItem:@"注册"
                        image   :nil
                        target  :self
                        action  :@selector(toRegister)],
            [KxMenuItem menuItem:@"收益计算器"
                        image   :nil
                        target  :self
                        action  :@selector(toCalc)]

        ];
    } else if ([GVUserDefaults  shareInstance].real_status == 1) {
        menuItems =
            @[
            [KxMenuItem menuItem:@"首页"
                        image   :nil
                        target  :self
                        action  :@selector(toHome)],

            [KxMenuItem menuItem:@"充值"
                        image   :nil
                        target  :self
                        action  :@selector(toPay)],

            [KxMenuItem menuItem:@"提现"
                        image   :nil
                        target  :self
                        action  :@selector(toWithdrew)],
            [KxMenuItem menuItem:@"投资"
                        image   :nil
                        target  :self
                        action  :@selector(toInvest)],
            [KxMenuItem menuItem:@"收益计算器"
                        image   :nil
                        target  :self
                        action  :@selector(toCalc)],
            [KxMenuItem menuItem:@"切换账号"
                        image   :nil
                        target  :self
                        action  :@selector(toLogin)],
            [KxMenuItem menuItem:@"安全退出"
                        image   :nil
                        target  :self
                        action  :@selector(logout)]

        ];
    } else {
        menuItems =
            @[
            [KxMenuItem menuItem:@"首页"
                        image   :nil
                        target  :self
                        action  :@selector(toHome)],
            [KxMenuItem menuItem:@"收益计算器"
                        image   :nil
                        target  :self
                        action  :@selector(toCalc)],
            [KxMenuItem menuItem:@"切换账号"
                        image   :nil
                        target  :self
                        action  :@selector(toLogin)],
            [KxMenuItem menuItem:@"安全退出"
                        image   :nil
                        target  :self
                        action  :@selector(logout)]

        ];
    }

    MenuViewController *menu = [MenuViewController sharedInstance];
    menu.menuItems = menuItems;

    [self.navigationController.view addSubview:menu.maskView];
    [self.navigationController.view addSubview:menu.view];

    // 动画
    CGRect rect = menu.view.frame;
    menu.view.frame = CGRectMake(APP_WIDTH, 0, rect.size.width, APP_HEIGHT);

    menu.maskView.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        menu.view.frame = rect;
        menu.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        menu.view.frame = rect;
        menu.maskView.alpha = 1;
    }];
}

- (void)setMenu {
    UIButton *itembtn;

    itembtn = [UIButton buttonWithType:UIButtonTypeCustom];

    itembtn.frame = CGRectMake(0, 0, 22, 14);
    [itembtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];

    [itembtn click:^(id value) {
        [self showMenu];
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:itembtn];
}



@end
