//
//  UIImage+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-4.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
/**
 渲染纯色图片颜色
 比如将白色箭头，修改为黑色箭头
 @param color color
 @return
 */
-(UIImage *)renderColor:(UIColor *)color;
-(NSData *)dataRepresentation;
-(UIImage *)scaledToSize:(CGSize)targetSize;
-(UIImage *)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage *)scaledToMaxSize:(CGSize )size;
+(UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
+(UIImage *)fullScreenImageALAsset:(ALAsset *)asset;

- (UIColor *)colorAtPixel:(CGPoint)point;

+ (UIImage *)hk_animatedGIFNamed:(NSString *)name;
+ (UIImage *)hk_animatedGIFWithData:(NSData *)data;
- (UIImage *)hk_animatedImageByScalingAndCroppingToSize:(CGSize)size;

/** 将一个View转换成iamge */
+ (UIImage *)convertViewToImage:(UIView *)v;
//返回一张圆形图片
- (instancetype)imageWithCircle;

@end
