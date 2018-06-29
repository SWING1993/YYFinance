//
//  UITextView+Common.h
//  BlackCard
//
//  Created by pz on 2017/6/26.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Common)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
