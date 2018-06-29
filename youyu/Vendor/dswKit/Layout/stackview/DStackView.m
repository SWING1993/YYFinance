//
//  StackView.m
//  test
//
//  Created by stephen on 15/2/12.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "DStackView.h"
#import <objc/runtime.h>
#import "UIScrollView+contentSize.h"

#pragma mark - stack

@implementation DStackView

#pragma  mark - other
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark -delete

- (void)removeFormIndex:(NSInteger)index {
    for (int i = 0; i < self.subviews.count; i++) {
        if (i > index) {
            [self.subviews[i] removeFromSuperview];
        }
    }
}

#pragma mark -  获取

- (UIView *)indexForView:(NSInteger)index {
    if (self.subviews.count >= index + 1) {
        return self.subviews[index];
    } else {
        return nil;
    }
}

#pragma  mark  LINE
- (void)addLineForHeight:(CGFloat)h {
    [self addLineForHeight:h color:[UIColor clearColor]];
}

- (void)addLineForHeight:(CGFloat)h color:(UIColor *)color {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, h)];

    view.backgroundColor = color;
    CGFloat temp = self.offsetX;
    self.offsetX = 0;
    [self addView:view margin:UIEdgeInsetsZero];
    self.offsetX = temp;
}

#pragma  mark  ADD
- (void)addView:(UIView *)view {
    [self addView:view margin:UIEdgeInsetsZero];
}

- (void)addView:(UIView *)view margin:(UIEdgeInsets)magin {
    if (view == self) {
        return;
    }

    view.margin = [NSValue valueWithUIEdgeInsets:magin];

    if ([view isKindOfClass:NSClassFromString(@"DWrapView")]) {
        view.width = self.width - magin.left - magin.right;
    } else {
        view.width = self.width - magin.left - magin.right - self.offsetX * 2;
    }

    if (![self.subviews containsObject:view]) {
        [self addSubview:view];
    }
}

#pragma  mark  update

- (void)layoutSubviews {
    // NSLog(@"重新布局中----------------------------------");
    // TIME_INIT
    [self updateView];

    if ([self.superview isMemberOfClass:[UIScrollView class]]) {
        [((UIScrollView *)self.superview) autoContentSize];
    }

    // TIME_USE
}

- (void)updateView {
    NSArray<UIView *> *subviews = self.subviews;
    frontView = nil;

    for (UIView *item in subviews) {
        UIEdgeInsets edge = [item.margin UIEdgeInsetsValue];
        [self _addView:item margin:edge];
    }

    self.height = frontView.bottom + [frontView.margin UIEdgeInsetsValue].bottom;
}

- (void)_addView:(UIView *)view margin:(UIEdgeInsets)magin {
    if ([view isKindOfClass:[self class]]) {
        [view setNeedsLayout];
        [view layoutIfNeeded];
    }

    if ([view isKindOfClass:NSClassFromString(@"DWrapView")]) {
        [view setNeedsLayout];
        [view layoutIfNeeded];
    }

    if (view.hidden) {
        return;
    }

    CGRect newRect = view.frame;

    newRect.size.width = self.width;
    newRect.origin.x = 0;
    newRect.origin.y = 0;

    // 添加到底部
    if (frontView) {
        newRect = CGRectOffsetBottom(frontView.frame, newRect);
        newRect.origin.y += [frontView.margin UIEdgeInsetsValue].bottom;
    }

    // 添加view边距
    newRect = CGRectEdgeInsets(newRect, UIEdgeInsetsMake(0, magin.left, 0, magin.right));
    // 添加 stack边距

    if ([view isKindOfClass:NSClassFromString(@"DWrapView")]) {
        newRect = CGRectEdgeInsets(newRect, UIEdgeInsetsMake(0, 0, 0, 0));
    } else {
        newRect = CGRectEdgeInsets(newRect, UIEdgeInsetsMake(0, self.offsetX, 0, self.offsetX));
    }

    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.numberOfLines = 0;
        [label autoHeight];
        newRect.size.height = label.height;
    }

    //上下边距
    newRect.origin.y += magin.top;
    view.frame = newRect;
    frontView = view;

    // NSLog(@"%@", NSStringFromCGRect(view.frame));
}

#pragma mark - theme
- (void)setCodeButtonStyle:(UIButton *)item {}

- (void)setTfviewStyle:(UITextField *)item {}

- (void)setLabelStyle:(UILabel *)item {}

- (void)setSubmitButtonStyle:(UIButton *)item {}

- (void)setRightButtonStyle:(UIButton *)item {}

- (void)setNewSubmitButtonStyle:(UIButton *)item{}

@end
