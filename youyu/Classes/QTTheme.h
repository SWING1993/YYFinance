//
//  QTTheme.h
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QTCirlceView.h"
#import "DSegmentedControl.h"
#import "UIColor+hexColor.h"
#import "WMPageController.h"
#import "MXMarqueeView.h"

#pragma mark -  颜色

@interface QTTheme : NSObject

#pragma mark navbar style

+ (void)navigationBar;

+ (void)tabStyle:(UITabBar *)tabBar;

#pragma mark btn style

/**
 *  白色内容,红边框，圆角
 */
+ (void)btnWhiteStyle:(UIButton *)btn;

/**
 *  阴影，白色内容,圆角
 */
+ (void)btnWhiteShadowStyle:(UIButton *)btn;

/**
 *  灰边框，白色内容,圆角
 */
+ (void)btnGrayCodeStyle:(UIButton *)btn;
/**
 *  红边框，透明度红,圆角
 */
+ (void)btnLightRedStyle:(UIButton *)btn;

/**
 *  红色内容,圆角
 */
+ (void)btnRedStyle:(UIButton *)btn;

/**
 *  灰色内容,圆角，不可用
 */
+ (void)btnGrayStyle:(UIButton *)btn;

/**
 *  绿色内容
 */
+ (void)btnGreenStyle:(UIButton *)btn;

/**
 *  浅绿色
 *
 */
+ (void)btnLightGreenStyle:(UIButton *)btn;

#pragma mark tb style

/**
 *  无边框
 *
 */
+ (void)tbStyle1:(UITextField *)tb;

#pragma mark lb style

/**
 *  跑马灯样式
 *
 */
+ (void)marqueeViewYellow:(MXMarqueeView *)lb;

/**
 *  灰色字体，12号
 *
 */
+ (void)lbStyle1:(UILabel *)lb;

/**
 *  orange ,圆角,白色
 *
 *
 */
+ (void)lbStyle2:(UILabel *)lb;

/**
 *  红色背景 ，黑色字体，12号
 *
 */
+ (void)lbStyle3:(UILabel *)lb;

+ (void)lbStyle4:(UILabel *)lb;

/**
 *  金钱为红色
 *
 */
+ (void)lbStyleMoney:(UILabel *)lb;


/**
 *  颜色渐变
 *
 */

+ (void)submitBUttonColorGradient:(UIButton*)btn;

/**
 *  红色内容,圆角 渐变颜色
 */
+ (void)btnRedGradientStyle:(UIButton *)btn;

#pragma mark lb process

/**
 * 红色 ，圆角 ，灰色底
 *
 */
+ (void)progressStyle1:(UIProgressView *)process;

/**
 * 绿色 ，圆角 ，灰色底
 *
 */
+ (void)progressStyle2:(UIProgressView *)process;

#pragma mark segment
+ (void)segmentStyle1:(DSegmentedControl *)view;

#pragma mark tab
+ (void)tabbarStyle1:(UITabBarItem *)item;

#pragma mark pagecontrol
+ (void)pageControlStyle:(UIPageControl *)item;

+ (void)pageWMControlStyle:(WMPageController *)item;

+ (void)pageWMControlStyle2:(WMPageController *)pageVC;

@end
