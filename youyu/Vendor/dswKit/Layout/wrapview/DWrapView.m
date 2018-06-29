//
//  DWrapView.m
//  test
//
//  Created by stephen on 15/2/28.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "DWrapView.h"

@implementation DWrapView
{
    NSInteger   columns;
    BOOL        isAvgWidth;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (instancetype)initWidth:(CGFloat)width columns:(NSInteger)column {
    self = [super initWidth:width];

    if (self) {
        columns = column;
        isAvgWidth = YES;
    }

    return self;
}

- (void)setColumn:(NSInteger)num {
    columns = num;
    isAvgWidth = YES;
}

- (void)addView:(UIView *)view {
    [self addView:view margin:UIEdgeInsetsZero];
}

- (void)addView:(UIView *)view padding:(UIEdgeInsets)padding {
    [self addView:view margin:UIEdgeInsetsZero padding:padding];
}

- (void)addView:(UIView *)view margin:(UIEdgeInsets)edge {
    [self addView:view margin:edge padding:UIEdgeInsetsZero];
}

- (void)addView:(UIView *)view margin:(UIEdgeInsets)edge padding:(UIEdgeInsets)padding {
    if (view == self) {
        return;
    }

    view.padding = [NSValue valueWithUIEdgeInsets:padding];
    view.margin = [NSValue valueWithUIEdgeInsets:edge];

    if (![self.subviews containsObject:view]) {
        [self addSubview:view];
    }
}

- (CGFloat)getAvgItemWidth:(NSInteger)num {
    return (self.width - self.offsetX * 2 - 0.1) / num;
}

#pragma  mark  update

- (void)_addView:(UIView *)view margin:(NSValue *)edge padding:(NSValue *)padding {
    if ([view isKindOfClass:[self class]]) {
        [view setNeedsLayout];
        [view layoutIfNeeded];
    }

    if (self.subHeight == 0) {
        self.subHeight = 44;
    }

    CGRect  rect = view.frame;
    CGFloat viewWidth;

    if (isAvgWidth) {
        viewWidth = [self getAvgItemWidth:columns];
    } else {
        viewWidth = view.width;
    }

    rect.size.width = viewWidth;
    rect.size.height = self.subHeight;

    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.numberOfLines = 0;
        [label autoHeight];

        rect.size.height = label.height;
    }

    rect.origin = CGPointMake(0, 0);

    if (frontView && (frontView.right + view.width < self.width)) {
        // 插入当前行
        rect = CGRectOffsetRight(frontView.frame, rect);
        rect.origin.y = frontView.origin.y - [frontView.margin UIEdgeInsetsValue].top - [frontView.padding UIEdgeInsetsValue].top;
    } else {
        // 插入新行

        rect.origin.x = self.offsetX;
        rect.origin.y = frontView.bottom + [frontView.margin UIEdgeInsetsValue].bottom + [frontView.padding UIEdgeInsetsValue].bottom;
    }

    rect = CGRectEdgeInsets(rect, [edge UIEdgeInsetsValue]);

    if (padding) {
        UIEdgeInsets p = [padding UIEdgeInsetsValue];
        rect.origin.x += p.left;
        rect.origin.y += p.top;
    }

    view.frame = rect;
    frontView = view;
    // NSLog(@"%@", NSStringFromCGRect(view.frame));
}

- (void)layoutSubviews {
    NSArray<UIView *> *subviews = self.subviews;
    frontView = nil;

    for (UIView *item in subviews) {
        [self _addView:item margin:item.margin padding:item.padding];
    }

    self.height = frontView.bottom + [frontView.margin UIEdgeInsetsValue].bottom + [frontView.padding UIEdgeInsetsValue].bottom;
}

@end
