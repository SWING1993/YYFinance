//
//  CAShapeLayer+qtlayer.m
//  qtyd
//
//  Created by stephendsw on 16/4/12.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "CAShapeLayer+qtlayer.h"

@implementation CAShapeLayer (qtlayer)

+ (CAShapeLayer *)layerDottedLine:(CGRect)rect {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    shapeLayer.frame = rect;
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];

    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
    [NSNumber numberWithInt:2], nil]];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 16, rect.size.height / 2);
    CGPathAddLineToPoint(path, NULL, rect.size.width - 16, rect.size.height / 2);

    [shapeLayer setPath:path];
    CGPathRelease(path);
    return shapeLayer;
}

@end
