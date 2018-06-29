//
//  UIImageView+webImage.m
//  qtyd
//
//  Created by stephendsw on 16/4/26.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "UIImageView+webImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (webImage)

- (void)setImageWithURLString:(NSString *)urlstring placeholderImageString:(NSString *)imageString {
    [self sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:imageString] options:SDWebImageTransformAnimatedImage];
}

- (void)setImageWithURLString:(NSString *)urlstring {
    [self sd_setImageWithURL:[NSURL URLWithString:urlstring]];
}

@end
