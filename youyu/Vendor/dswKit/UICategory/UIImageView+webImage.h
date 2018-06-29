//
//  UIImageView+webImage.h
//  qtyd
//
//  Created by stephendsw on 16/4/26.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (webImage)

- (void)setImageWithURLString:(NSString *)urlstring;

- (void)setImageWithURLString:(NSString *)urlstring placeholderImageString:(NSString *)imageString;

@end
