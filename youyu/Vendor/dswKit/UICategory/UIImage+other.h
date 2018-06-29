//
//  UIImage+color.h
//  qtyd
//
//  Created by stephendsw on 15/8/12.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (color)

/**
 *  颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  颜色遮罩
 */
- (UIImage *)maskColor:(UIColor *)maskColor;

/**
 *  改变图片颜色
 *
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  颜色混合
 *
 */
- (UIImage *)imageWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode;

/**
 *  黑白化
 *
 */
- (UIImage *)convertImageToGreyScale;

@end

@interface UIImage (size)

/**
 * 改变图像的尺寸
 */
- (UIImage *)scaleSize:(CGSize)size;

/**
 *  保持原来的长宽比，生成一个缩略图
 */
- (UIImage *)scaleSizeWithoutScale:(CGSize)asize;

/**
 * 剪裁的图片，图片是需要剪裁的形状。
 */
- (UIImage *)maskImage:(UIImage *)maskImage;

/**
 *  截取uiview指定区域
 *
 */
+ (UIImage *)imageFromView:(UIView *)v rect:(CGRect)rect;

/**
 *  图片变圆角
 */

- (UIImage *)becomeRound;

@end
