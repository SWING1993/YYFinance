//
//  DStackView+Add.m
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "DStackView+Add.h"
#import "UIControl+BlockEvent.h"

@implementation DStackView (Add)
- (UIButton *)gj_addSubmitButtonTitle:(NSString *)str click:(void (^)(id))block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:str forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 0, 44);
    
    [self setNewSubmitButtonStyle:button];
    
    //重新修正圆角
    button.layer.cornerRadius = 6;
    
    [button click:^(id value) {
        block(value);
    }];
    
    if ([self isKindOfClass:NSClassFromString(@"DGridView")]) {
        [self addView:button margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    } else {
        [self addView:button margin:UIEdgeInsetsMake(0, 16, 0, 16)];
    }
    
    return button;
}
- (UIButton *)addRowButtonTitle:(NSString *)str click:(void (^)(id value))block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:str forState:UIControlStateNormal];

    button.frame = CGRectMake(0, 0, 0, 44);

    [self setSubmitButtonStyle:button];

    [button click:^(id value) {
        block(value);
    }];

    if ([self isKindOfClass:NSClassFromString(@"DGridView")]) {
        [self addView:button margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    } else {
        [self addView:button margin:UIEdgeInsetsMake(0, 16, 0, 16)];
    }

    return button;
}

- (UIButton *)addSubmitButtonTitle:(NSString *)str click:(void (^)(id))block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:str forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 0, 44);
    
    [self setNewSubmitButtonStyle:button];
    
    [button click:^(id value) {
        block(value);
    }];
    
    if ([self isKindOfClass:NSClassFromString(@"DGridView")]) {
        [self addView:button margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    } else {
        [self addView:button margin:UIEdgeInsetsMake(0, 16, 0, 16)];
    }
    
    return button;
}


- (UILabel *)addTelephoneButtonTitle:(NSString *)str click:(void (^)(id value))block {
    UILabel *label = [UILabel new];
    
    NSMutableAttributedString *AttributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, str.length-4)];
    label.attributedText = AttributeStr;
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(0, 0, 0, 32);
    label.textAlignment = NSTextAlignmentCenter;
    

    label.borderWidth = 1;
    label.cornerRadius = 16;
    [label addTapGesture:^{
        block;
    }];

    [self addView:label margin:UIEdgeInsetsMake(0, 50, 100, 50)];
    
    
    return label;
}


@end
