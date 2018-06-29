//
//  UIImage+color.m
//  qtyd
//
//  Created by stephendsw on 15/8/12.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UIImage+other.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - color
@implementation UIImage (color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)maskColor:(UIColor *)maskColor {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, rect);

    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return smallImage;
}

/** 颜色变化 */

- (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color blendMode:kCGBlendModeDestinationIn];
}

/** 颜色变化 */

- (UIImage *)imageWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);

    // Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

- (UIImage *)convertImageToGreyScale {
    UIImage         *image = self;
    CGRect          imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef    context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);

    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef  imageRef = CGBitmapContextCreateImage(context);
    UIImage     *newImage = [UIImage imageWithCGImage:imageRef];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    return newImage;
}

@end

#pragma mark - size

@implementation UIImage (size)

- (UIImage *)scaleSize:(CGSize)size {
    UIImage *image = self;

    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleSizeWithoutScale:(CGSize)asize {
    UIImage *newimage;
    UIImage *image = self;

    if (nil == image) {
        newimage = nil;
    } else {
        CGSize  oldsize = image.size;
        CGRect  rect;

        if (asize.width / asize.height > oldsize.width / oldsize.height) {
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }

        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));// clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return newimage;
}

// 剪裁的图片，图片是需要剪裁的形状。
- (UIImage *)maskImage:(UIImage *)maskImage {
    UIImage     *image = self;
    CGImageRef  maskRef = maskImage.CGImage;

    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), NULL, false);

    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);

    return [UIImage imageWithCGImage:masked];
}

+ (UIImage *)imageFromView:(UIView *)v rect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(v.frame.size, NO, 1.0);  // NO，YES控制是否透明

    [v.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    CGRect myImageRect = rect;

    CGImageRef imageRef = image.CGImage;

    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawImage(context, myImageRect, subImageRef);

    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];

    CGImageRelease(subImageRef);

    UIGraphicsEndImageContext();

    return smallImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
    float ovalHeight) {
    float fw, fh;

    if ((ovalWidth == 0) || (ovalHeight == 0)) {
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;

    CGContextMoveToPoint(context, fw, fh / 2);              // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1); // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1);   // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1);    // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1);  // Back to lower right

    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)r {
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;

    UIImage         *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef    context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect          rect = CGRectMake(0, 0, w, h);

    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);

    return img;
}

- (UIImage *)becomeRound {
    return [UIImage createRoundedRectImage:self size:self.size radius:self.size.height / 2];
}

@end
