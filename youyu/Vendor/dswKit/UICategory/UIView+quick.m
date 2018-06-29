//
//  UIView+quick.m
//  test
//
//  Created by stephen on 15/2/28.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "UIView+quick.h"
#import <objc/runtime.h>

@implementation UIView (quick)

#pragma mark 手势

static char *tapKey;

- (void)addTapGesture:(tapBlcok)block {
    objc_setAssociatedObject(self, &tapKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelector:)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)tapSelector:(id)value {
    tapBlcok block = objc_getAssociatedObject(self, &tapKey);

    block(value);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (CGPoint)pointInView:(UIView *)view {
    return [view convertPoint:self.center fromView:self.superview];
}

- (CGRect)rectInView:(UIView *)view {
    return [view convertRect:self.frame fromView:self.superview];
}

@end

@implementation UIView (tranform)

- (void)setRotation:(float)rotation {
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformMakeRotation(rotation);
}

@end
