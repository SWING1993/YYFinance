//
//  CGRect+other.m
//  test
//
//  Created by stephendsw on 15/9/11.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "CGRect+other.h"

CGRect CGRectEdgeInsets(CGRect rect, UIEdgeInsets edge) {
    CGRect resultRect = CGRectZero;

    CGFloat x = rect.origin.x + edge.left;
    CGFloat y = rect.origin.y + edge.top;

    CGFloat width = rect.size.width - edge.left - edge.right;
    CGFloat height = rect.size.height - edge.top - edge.bottom;

    return resultRect = CGRectMake(x, y, width, height);
}

CGRect CGRectOffsetBottom(CGRect rect, CGRect rect2) {
    rect2.origin.y = rect.origin.y + rect.size.height;

    return rect2;
}

CGRect CGRectOffsetRight(CGRect rect, CGRect rect2) {
    rect2.origin.x += rect.origin.x + rect.size.width;

    return rect2;
}
