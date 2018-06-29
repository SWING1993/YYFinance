//
//  CSChartsBackgroundLayer.m
//  ImgGetter
//
//  Created by 沈凯 on 14-3-4.
//  Copyright (c) 2014年 CruiseShen. All rights reserved.
//

#import "CSChartsBackgroundLayer.h"
#import "NSString+BoundingRect.h"
#import "CSChartsColorRegion.h"
#import "AppUtil.h"

@implementation CSChartsBackgroundLayer

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];

    // ==============================================背景
    // 绘制表格背景
    [self drawBackgroundColorRegion:ctx];

    // 绘制相间的背景色彩
    [self drawRect:ctx];

    // ==============================================y轴

    // 绘制垂直单位分割线
    [self drawBackgroundVerticalLines:ctx];

    // 绘制y轴单位
    if (self.charts.yAxis.isNeeded) {
        [self drawBackgroundYXAisSigns:ctx];
    }

    // ==============================================x轴

    // 绘制水平单位分割线
    [self drawBackgroundHorizontalLines:ctx];

    // 绘制x轴
    [self drawXAxisLines:ctx];

    // 绘制x轴单位
    [self drawXAxisSigns:ctx];
}

#pragma mark - draw 背景

// 绘制图标背景
- (void)drawBackgroundColorRegion:(CGContextRef)ctx {
    CGFloat rectY = topSpacing + chartsContentHeight;
    NSArray *colorRegionArray = self.charts.background.colorRegionArray;

    for (CSChartsColorRegion *colorRegion in colorRegionArray) {
        if (self.charts.background.isRegionSeparated) {
            CGFloat rectHeight = colorRegion.regionRange / (yAxisMax - yAxisMin) * chartsContentHeight;
            rectY -= rectHeight;
            CGRect drawRect = CGRectMake(leftSpacing - 3, rectY, self.charts.frame.size.width - leftSpacing + 3, rectHeight);
            // draw rect back
            // set color
            CGContextSetFillColorWithColor(ctx, colorRegion.color.CGColor);
            // fill rect
            CGContextFillRect(ctx, drawRect);
            // commit draw
            CGContextStrokePath(ctx);
        } else {
            CSChartsColorRegion *color1 = colorRegionArray[0];
            CSChartsColorRegion *color2 = colorRegionArray[1];
            NSArray             *colors = @[
                color1.color,
                color2.color
            ];
            [self drawGradientColor:ctx
            rect    :CGRectMake(leftSpacing, topSpacing, APP_WIDTH - leftSpacing, chartsContentHeight)
            options :kCGGradientDrawsAfterEndLocation
            colors  :colors];
            CGContextStrokePath(ctx);
            CGContextFillPath(ctx);
        }
    }
}

// 绘制相间的背景色彩
- (void)drawRect:(CGContextRef)ctx {
    CGFloat yorign = xAxisYPosition + 0.5;
    CGFloat xorign = xOrign;

    int index = 0;

    for (int i = 0; i < 4; i++) {
        CGContextBeginPath(ctx);

        CGContextMoveToPoint(ctx, xorign, yorign);
        CGContextAddLineToPoint(ctx, xorign + verticalSpacing, yorign);
        CGContextAddLineToPoint(ctx, self.charts->points[index + 1].x, self.charts->points[1].y + 2);
        CGContextAddLineToPoint(ctx, self.charts->points[index].x, self.charts->points[0].y + 2);

        CGContextClosePath(ctx);

        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:253.0 / 255.0 green:238.0 / 255.0 blue:223.0 / 255.0 alpha:1].CGColor);

        CGContextFillPath(ctx);

        xorign += 2 * verticalSpacing;
        index += 2;
    }
}

#pragma mark - draw y轴

// 绘制垂直单位分割线
- (void)drawBackgroundVerticalLines:(CGContextRef)ctx {
    // set LineDash mode off
    CGPoint points[2];

    CGContextSetLineDash(ctx, 0, nil, 0);
    CGFloat lineXPosition = xOrign;

    for (int i = 0; i < verticalLineAmount; i++, lineXPosition += verticalSpacing) {
        if (i == 0) {
            CGContextSetLineWidth(ctx, 1);
        } else {
            CGContextSetLineWidth(ctx, 0.5);
        }

        // set line color
        UIColor *viceLineColor = [UIColor colorWithWhite:0.8 alpha:1];
        CGContextSetStrokeColorWithColor(ctx, viceLineColor.CGColor);
        // set the points
        points[0] = CGPointMake(lineXPosition, topSpacing);
        points[1] = CGPointMake(lineXPosition, self.charts.frame.size.height - bottomSpacing);
        CGContextAddLines(ctx, points, 2);
        // commit draw
        CGContextStrokePath(ctx);
    }
}

// 绘制y轴单位
- (void)drawBackgroundYXAisSigns:(CGContextRef)ctx {
    // set Anti alias
    CGContextSetShouldAntialias(ctx, YES);
    // set line font
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.5 alpha:1].CGColor);
    UIGraphicsPushContext(ctx);

    CGFloat drawNum = self.charts.yAxis.max;
    CGFloat numGap = (self.charts.yAxis.max - self.charts.yAxis.min) / (horizontalLineAmount - 1);
    CGFloat characterPosition = CSCHARTS_TOP_EXTRA_SPACING;

    for (int i = 0; i < horizontalLineAmount; i++, characterPosition += horizontalSpacing) {
        // draw characters
        NSString    *drawString = [NSString stringWithFormat:self.charts.yAxis.signFormat, drawNum];
        CGSize      drawStringSize = [drawString boundingRectWithSize:CGSizeMake(200, 200) withTextFont:self.charts.yAxis.font withLineSpacing:3];

        [drawString drawAtPoint:CGPointMake((leftSpacing - drawStringSize.width) / 2, characterPosition) withAttributes:@{NSFontAttributeName:yAxisFont}];

        drawNum -= numGap;
    }

    UIGraphicsPopContext();
}

#pragma mark - draw  x 轴
// 绘制x轴
- (void)drawXAxisLines:(CGContextRef)ctx {
    CGPoint points[2];

    // set line width
    CGContextSetLineWidth(ctx, 1);
    // set line style
    CGContextSetLineCap(ctx, kCGLineCapRound);
    // set anti alias off
    CGContextSetShouldAntialias(ctx, NO);
    // set line color
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    // set the points
    points[0] = CGPointMake(self.charts.frame.size.width, xAxisYPosition + 0.5);
    points[1] = CGPointMake(xOrign, xAxisYPosition + 0.5);
    CGContextAddLines(ctx, points, 2);
    // commit draw
    CGContextStrokePath(ctx);
}

// 绘制x轴单位
- (void)drawXAxisSigns:(CGContextRef)ctx {
    UIColor *xAxisSignColor = self.charts.xAxis.signColor;
    UIFont  *xAxisSignFont = self.charts.xAxis.signFont;
    CGFloat xAxisSignPosition = leftSpacing;

    // set Anti alias
    CGContextSetShouldAntialias(ctx, YES);

    CGContextSetFillColorWithColor(ctx, xAxisSignColor.CGColor);
    UIGraphicsPushContext(ctx);

    for (int i = 0; i < self.charts.xAxis.signArray.count; i++, xAxisSignPosition += verticalSpacing) {
        // draw characters
        NSString    *drawString = [self.charts.xAxis.signArray objectAtIndex:i];
        CGSize      drawStringSize = [drawString boundingRectWithSize:CGSizeMake(200, 200) withTextFont:self.charts.yAxis.font withLineSpacing:3];
        //        [drawString drawAtPoint:CGPointMake(xAxisSignPosition - drawStringSize.width / 2, xAxisYPosition + CSCHARTS_SPACING) withAttributes:attributes];

        [drawString drawAtPoint:CGPointMake(xAxisSignPosition - drawStringSize.width / 2, xAxisYPosition + CSCHARTS_SPACING) withAttributes:@{NSFontAttributeName:xAxisSignFont}];
    }

    UIGraphicsPopContext();
}

// 绘制水平单位分割线
- (void)drawBackgroundHorizontalLines:(CGContextRef)ctx {
    // set line width
    CGContextSetLineWidth(ctx, 0.1);
    // set line style
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    // set anti alias off
    CGContextSetShouldAntialias(ctx, NO);

    CGPoint points[2];
    CGFloat lineYPosition = topSpacing;

    for (int i = 0; i < horizontalLineAmount; i++, lineYPosition += horizontalSpacing) {
        UIColor *viceLineColor = self.charts.background.viceLineColor;
        CGContextSetStrokeColorWithColor(ctx, viceLineColor.CGColor);

        //            // set dash linez
        if (i != 0) {
            CGFloat lengths[] = {1, 1};
            CGContextSetLineDash(ctx, 0, lengths, 2);
        }

        // set the points
        points[0] = CGPointMake(self.charts.frame.size.width, lineYPosition);
        points[1] = CGPointMake(leftSpacing, lineYPosition);
        CGContextAddLines(ctx, points, 2);
        // commit draw
        CGContextStrokePath(ctx);
    }
}

@end
