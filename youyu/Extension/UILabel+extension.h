//
//  UILabel+extension.h
//  Label
//
//  Created by Jason on 15/9/25.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)
- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color;
- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text;
/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

@end
