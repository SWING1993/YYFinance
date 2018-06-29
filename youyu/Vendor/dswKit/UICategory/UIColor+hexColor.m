//
//  UIColor+hexColor.m
//  qtyd
//
//  Created by stephendsw on 15/9/2.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UIColor+hexColor.h"
#import "NSString+regularExpression.h"

@implementation UIColor (hexColor)

+ (UIColor *)colorHex:(NSString *)hexColor {
    return [UIColor colorHex:hexColor alpha:1];
}

/**
 *  十六进制颜色，可忽略#
 */
+ (UIColor *)colorHex:(NSString *)hexColor alpha:(CGFloat)alpha {
    NSString    *reg1 = @"^\\#[0-9a-fA-F]{6}$";
    NSString    *reg2 = @"^[0-9a-fA-F]{6}$";

    if ([hexColor isMatch:reg1]) {
        hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    } else if ([hexColor isMatch:reg2]) {} else {
        return [UIColor whiteColor];
    }

    unsigned int    red, green, blue;
    NSRange         range;

    range.length = 2;

    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];

    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];

    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];

    return [UIColor colorWithRed:(float)(red / 255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
}

@end
