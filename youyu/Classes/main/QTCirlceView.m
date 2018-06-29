//
//  QTCirlce.m
//  circle
//
//  Created by stephendsw on 15/12/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTCirlceView.h"

@interface QTCirlceView ()


@end

@implementation QTCirlceView

- (void)awakeFromNib {
    [super awakeFromNib];
    

    [self bindKeyPath:@"bounds" object:self block:^(id newobj){
        [self setNeedsDisplay];
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);

    CGContextRef context = UIGraphicsGetCurrentContext();

    // 填充画布
    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    // 圆
    CGFloat radio = rect.size.height / 2;
    CGContextAddEllipseInRect(context, rect);
    [[UIColor whiteColor] set];
    CGContextFillPath(context);

    // 环
    CGFloat ringRadio = radio - self.ringWidth / 2 - 1;

    CGContextSetRGBStrokeColor(context, 252 / 255.0, 238 / 255.0, 225 / 255.0, 1);
    CGContextSetLineWidth(context, self.ringWidth);
    CGContextAddArc(context, center.x, center.y, ringRadio, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);

    if (self.showInnerRing) {
        // 内环
        CGContextSetStrokeColor(context, CGColorGetComponents(self.ringColor.CGColor));
        CGContextSetLineWidth(context, self.ringWidth / 2);
        CGContextAddArc(context, center.x, center.y, ringRadio - 5, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }

    // 进度

    CGContextSetStrokeColor(context, CGColorGetComponents(self.ringColor.CGColor));
    CGContextSetLineWidth(context, self.ringWidth);
    CGContextAddArc(context, center.x, center.y, ringRadio, -M_PI / 2, (-M_PI / 2 + 2 * M_PI * self.rate), 0);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)setRingColor:(UIColor *)ringColor {
    _ringColor = ringColor;
    [self setNeedsDisplay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    [self setNeedsDisplay];
}

@end
