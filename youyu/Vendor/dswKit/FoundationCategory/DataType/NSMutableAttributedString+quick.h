//
//  NSMutableString+quick.h
//  qtyd
//
//  Created by stephendsw on 15/9/24.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (quick)

- (void)appendImageName:(NSString *)imageName;

-(void)appendImage:(UIImage *)image;

/**
 *  链接线
 *
 */
-(void)setLinkString:(NSString *)str;

/**
 *  中划线
 *
 */
-(void)setUnderlineString:(NSString *)str;

- (void)setColor:(UIColor *)color string:(NSString *)str;
- (void)setColor:(UIColor *)color;

- (void)setFont:(UIFont *)font string:(NSString *)str;
- (void)setFont:(UIFont *)font;

- (void)setParagraphStyle:(void (^)(NSMutableParagraphStyle *Paragraph))block;

@end
