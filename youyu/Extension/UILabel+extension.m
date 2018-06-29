//
//  UILabel+extension.m
//  Label
//
//  Created by Jason on 15/9/25.
//  Copyright (c) 2015年 www.jizhan.com. All rights reserved.
//

#import "UILabel+extension.h"
#import <CoreText/CoreText.h>

@implementation UILabel (extension)

- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.font = font;
        self.textColor = color;
    }
    return self;
}

- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text{
    self = [self initWithFont:font textColor:color];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)setColumnSpace:(CGFloat)columnSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace {
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

@end
