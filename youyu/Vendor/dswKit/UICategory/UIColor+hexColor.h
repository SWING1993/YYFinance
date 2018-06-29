//
//  UIColor+hexColor.h
//  qtyd
//
//  Created by stephendsw on 15/9/2.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)

/**
 *  十六进制颜色，可忽略#
 */
+ (UIColor *)colorHex:(NSString *)hexColor;

/**
 *  十六进制颜色，可忽略#
 */
+ (UIColor *)colorHex:(NSString *)hexColor alpha:(CGFloat) alpha;

@end
