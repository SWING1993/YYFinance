//
//  UIView+quick.m
//  test
//
//  Created by stephen on 15/2/28.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "UIView+layout.h"
#import "UIViewExt.h"
#import <objc/runtime.h>

CGRect GetLineRectX(CGRect rect) {
    CGFloat pixelAdjustOffsetY = 0;

    if (((int)(SINGLE_LINE_WIDTH * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffsetY = SINGLE_LINE_ADJUST_OFFSET;
    }

    return CGRectOffset(rect, 0, -pixelAdjustOffsetY);
}

CGRect GetLineRectY(CGRect rect) {
    CGFloat pixelAdjustOffsetX = 0;

    if (((int)(SINGLE_LINE_WIDTH * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffsetX = SINGLE_LINE_ADJUST_OFFSET;
    }

    return CGRectOffset(rect, -pixelAdjustOffsetX, 0);
}

@implementation UIView (layout)

@dynamic viewController;

+ (instancetype)viewNib {
    UIView  *result = nil;
    NSArray *elements = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
        owner:nil options:nil];

    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            result = anObject;
            break;
        }
    }

    return result;
}

- (instancetype)initWidth:(CGFloat)w Height:(CGFloat)h {
    return [self initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)clearSubviews {
    for (UIView *item in self.subviews) {
        [item removeFromSuperview];
    }
}

- (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableArray *)outArray {
    [outArray addObject:aView];

    for (UIView *view in [aView subviews]) {
        [self dumpView:view atIndent:indent + 1 into:outArray];
    }
}

- (NSMutableArray *)allSubviews {
    NSMutableArray *outViews = [NSMutableArray new];

    [self dumpView:self atIndent:0 into:outViews];
    return outViews;
}

- (void)setBottomLine:(UIColor *)color {
    CALayer *layer = [CALayer new];

    layer.frame = GetLineRectX(CGRectMake(0, self.height - LINE_WIDTH+0.5, self.width, LINE_WIDTH));
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void)setLeftLine:(UIColor *)color {
    CALayer *layer = [CALayer new];

    layer.frame = GetLineRectY(CGRectMake(0, 0, LINE_WIDTH, self.height));
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void)setRightLine:(UIColor *)color {
    CALayer *layer = [CALayer new];

    layer.frame = GetLineRectY(CGRectMake(self.width - LINE_WIDTH, 0, LINE_WIDTH, self.height));
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (void)setTopLine:(UIColor *)color {
    CALayer *layer = [CALayer new];

    layer.frame = GetLineRectX(CGRectMake(0, 0, self.width, LINE_WIDTH));
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

- (UIViewController *)viewController {
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;

    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }

    // If the view controller isn't found, return nil.
    return nil;
}

@end
