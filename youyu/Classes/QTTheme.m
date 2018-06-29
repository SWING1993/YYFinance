//
//  QTTheme.m
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTTheme.h"
#import <UIKit/UIKit.h>

#define CORNER_RADIUS 5

@implementation QTTheme

#pragma mark -nav

+ (void)navigationBar {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSShadowAttributeName:[NSShadow new]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(3, -1.5) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[Theme mainOrangeColor] size:CGSizeMake(APP_WIDTH, 66)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setBackIndicatorImage:[UIImage imageNamed:@"icon_bar_back"]];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"icon_bar_back"]];
}

+ (void)tabStyle:(UITabBar *)tabBar {
    tabBar.items[2].imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    tabBar.tintColor = Theme.mainOrangeColor;
    tabBar.barStyle = UIBarStyleBlack;
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(APP_WIDTH, 44)];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_bg"]];
    imageview.contentMode = UIViewContentModeCenter;
    imageview.frame = CGRectMake(0, -4, APP_WIDTH, 40);
    tabBar.backgroundColor = [UIColor whiteColor];
    [tabBar insertSubview:imageview atIndex:0];
}

#pragma mark -btn

/**
 *  红边框，白色内容,圆角
 */
+ (void)btnWhiteStyle:(UIButton *)btn {
    btn.layer.borderColor = Theme.redColor.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = CORNER_RADIUS;
    [btn setTitleColor:Theme.redColor forState:UIControlStateNormal];
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.showBackgroundColorHighlighted = YES;
}

/**
 *  红边框，透明度红,圆角
 */
+ (void)btnLightRedStyle:(UIButton *)btn {
    btn.layer.borderColor = Theme.redColor.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = CORNER_RADIUS;
    [btn setTitleColor:Theme.redColor forState:UIControlStateNormal];
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setBackgroundColor:[UIColor colorHex:@"ff4401"alpha:0.2]];
}

/**
 *  红边框，白色内容,圆角
 */
+ (void)btnWhiteShadowStyle:(UIButton *)btn {
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 10;
    [btn setTitleColor:Theme.redColor forState:UIControlStateNormal];
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.showBackgroundColorHighlighted = YES;

    // 阴影的颜色
    btn.layer.shadowColor = [[UIColor colorWithRed:101 / 255.0 green:25 / 255.0 blue:30 / 255.0 alpha:0.1] CGColor];
    btn.layer.shadowOffset = CGSizeMake(0, 0);
    // 阴影透明度
    btn.layer.shadowOpacity = 6;
    // 阴影圆角度数
    btn.layer.shadowRadius = 10;
}

/**
 *  灰边框，白色内容,圆角
 */
+ (void)btnGrayCodeStyle:(UIButton *)btn {
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = CORNER_RADIUS;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
}

/**
 *  红色内容,圆角
 */
+ (void)btnRedStyle:(UIButton *)btn {
    btn.backgroundColor = [Theme mainOrangeColor];
    btn.layer.cornerRadius = CORNER_RADIUS;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 0;
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.showBackgroundColorHighlighted = YES;
}


/**
 *  红色内容,圆角 渐变颜色
 */
+ (void)btnRedGradientStyle:(UIButton *)btn {
    btn.backgroundColor = [Theme mainOrangeColor];
    btn.layer.cornerRadius = 20;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 0;
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0,0);
    gradientLayer.frame = btn.frame;
    [btn.layer insertSublayer:gradientLayer atIndex:2];
    btn.showBackgroundColorHighlighted = YES;
}

/**
 *  灰色
 *
 */
+ (void)btnGrayStyle:(UIButton *)btn {
    btn.backgroundColor = [Theme lightGrayColor];
    btn.layer.cornerRadius = CORNER_RADIUS;
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 0;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
}

/**
 *  绿色
 */
+ (void)btnGreenStyle:(UIButton *)btn {
    btn.layer.borderColor = Theme.blueColor.CGColor;
    btn.layer.borderWidth = 1;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = CORNER_RADIUS;
    [btn setTitleColor:Theme.blueColor forState:UIControlStateNormal];
    btn.enabled = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
}

+ (void)btnLightGreenStyle:(UIButton *)btn {
    btn.backgroundColor = [Theme lightGreenColor];
    btn.layer.cornerRadius = CORNER_RADIUS;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.enabled = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
}

#pragma  mark - tb

+ (void)tbStyle1:(UITextField *)tb {
    tb.borderStyle = UITextBorderStyleNone;
    tb.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - MXMarqueeView

/**
 *  跑马灯样式
 *
 */
+ (void)marqueeViewYellow:(MXMarqueeView *)lb {
    lb.font = [UIFont systemFontOfSize:12];
    lb.backgroundColor = [UIColor colorWithRed:253.0 / 255.0 green:246.0 / 255.0 blue:148.0 / 255.0 alpha:1];
}

#pragma mark -lb

/**
 *  灰色字体，12号
 *
 */
+ (void)lbStyle1:(UILabel *)lb {
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    lb.layer.cornerRadius = 0;
    lb.layer.masksToBounds = YES;
    lb.backgroundColor = [UIColor clearColor];
}

/**
 *  orange ,圆角,白色
 *
 *
 */
+ (void)lbStyle2:(UILabel *)lb {
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor whiteColor];
    lb.layer.cornerRadius = 5;
    lb.layer.masksToBounds = YES;
    lb.backgroundColor = [UIColor orangeColor];
}

+ (void)lbStyle3:(UILabel *)lb {
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = Theme.redColor;
    lb.layer.cornerRadius = 5;
    lb.layer.masksToBounds = YES;
}

+ (void)lbStyle4:(UILabel *)lb {
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = [Theme grayColor];
    lb.layer.cornerRadius = 5;
    lb.layer.masksToBounds = YES;
}

/**
 *  金钱为红色
 *
 */
+ (void)lbStyleMoney:(UILabel *)lb {
    NSString *text = lb.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [text match:kRegNumber done:^(NSRange range) {
        [str addAttribute:NSForegroundColorAttributeName value:Theme.redColor range:range];
    }];
    [text match:@"," done:^(NSRange range) {
        [str addAttribute:NSForegroundColorAttributeName value:Theme.redColor range:range];
    }];
    lb.attributedText = str;
}

#pragma mark -progress

/**
 * 红色 ，圆角 ，灰色底
 *
 */
+ (void)progressStyle1:(UIProgressView *)process {
    process.layer.cornerRadius = 5;
    process.trackTintColor = Theme.backgroundColor;
    process.layer.masksToBounds = YES;
    process.progressTintColor = Theme.redColor;
    process.layer.borderColor = Theme.redColor.CGColor;
    process.layer.borderWidth = 1;
}

/**
 * 绿色 ，圆角 ，灰色底
 *
 */
+ (void)progressStyle2:(UIProgressView *)process {
    process.trackTintColor = Theme.backgroundColor;
    process.layer.cornerRadius = 5;
    process.progressTintColor = Theme.greenColor;
    process.layer.masksToBounds = YES;
    process.layer.borderColor = Theme.greenColor.CGColor;
    process.layer.borderWidth = 1;
}

#pragma mark - tabbar
+ (void)tabbarStyle1:(UITabBarItem *)item {
    UIOffset offset;
    offset.horizontal = 0.0;
    offset.vertical = -2.0;
    [item setTitlePositionAdjustment:offset];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[Theme mainOrangeColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[Theme grayColor]} forState:UIControlStateNormal];
}

#pragma mark segment
+ (void)segmentStyle1:(DSegmentedControl *)view {
    view.titleColor = [UIColor blackColor];
    view.selectColor = Theme.redColor;
    view.width = APP_WIDTH;
    view.backgroundColor = [UIColor whiteColor];
    [view setBottomLine:Theme.borderColor];
}

#pragma mark pagecontrol
+ (void)pageControlStyle:(UIPageControl *)item {
    item.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [item setValue:[UIImage imageNamed:@"icon_adr_appindex_banner_lab2"] forKeyPath:@"_currentPageImage"];
    [item setValue:[UIImage imageNamed:@"icon_adr_appindex_banner_lab1"] forKeyPath:@"_pageImage"];
    item.transform = CGAffineTransformMakeScale(0.6, 0.6);
}

+ (void)pageWMControlStyle:(WMPageController *)pageVC {
    pageVC.menuItemWidth = APP_WIDTH / 2;
    pageVC.menuHeight = 40;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.titleColorNormal = [UIColor blackColor];
    pageVC.titleColorSelected = Theme.redColor;
    pageVC.menuBGColor = [UIColor whiteColor];
    pageVC.titleSizeNormal = 12;
    pageVC.titleSizeSelected = 13;
}

+ (void)pageWMControlStyle2:(WMPageController *)pageVC {
    pageVC.menuItemWidth = APP_WIDTH / 2;
    pageVC.menuHeight = 40;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.titleColorNormal = [UIColor colorHex:@"#f06b6b"];
    pageVC.titleColorSelected = [UIColor whiteColor];
    pageVC.menuBGColor = [UIColor clearColor];
    pageVC.titleSizeNormal = 12;
    pageVC.titleSizeSelected = 13;
    pageVC.menuItemWidth = 200 / 3;
}

+ (void)submitBUttonColorGradient:(UIButton*)btn{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorHex:@"fc7649"].CGColor, (__bridge id)[UIColor colorHex:@"ff5922"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0,0);
    gradientLayer.frame = btn.frame;
    [btn.layer addSublayer:gradientLayer];
}



@end
