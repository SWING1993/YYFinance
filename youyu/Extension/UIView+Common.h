//
//  UIView+Common.h
//  BlackCard
//
//  Created by Mr.song on 16/5/24.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

- (CAGradientLayer *)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )aPoint endPoint:(CGPoint)endPoint;

- (void)addShakeAnimation;

- (void)addJitterAnimation;

- (void)addScaleAnimation;

- (void)addBoomAnimation;

- (void)setClickableafter:(NSTimeInterval)second;
/**
 设置内边框颜色
 
 @param width 边宽
 @param radius 半径
 @param color 色值
 */
- (void)setButtonBorderWidth:(CGFloat)width cornerRadius:(CGFloat)radius borderColor:(UIColor *)color;
@end
