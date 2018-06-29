//
//  CSBaseLayer.m
//  qtyd
//
//  Created by stephendsw on 15/8/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "CSBaseLayer.h"

@implementation CSBaseLayer

- (void)drawInContext:(CGContextRef)ctx {
    [self paramsPreparation];
}

#pragma mark -- param init method
- (void)paramsPreparation {
    yAxisCharacterSize = [[NSString stringWithFormat:self.charts.yAxis.signFormat, self.charts.yAxis.max] boundingRectWithSize:CGSizeMake(200, 200) withTextFont:self.charts.yAxis.font withLineSpacing:3];
    xAxisCharacterSize = [[self.charts.xAxis.signArray objectAtIndex:0] boundingRectWithSize:CGSizeMake(200, 200) withTextFont:self.charts.xAxis.signFont withLineSpacing:3];
    bottomSpacing = xAxisCharacterSize.height + CSCHARTS_SPACING * 2;

    if (self.charts.yAxis.isNeeded) {
        leftSpacing = yAxisCharacterSize.width + CSCHARTS_SPACING * 2;
    } else {
        leftSpacing = 0;
    }

    topSpacing = yAxisCharacterSize.height / 2 + CSCHARTS_TOP_EXTRA_SPACING;
    horizontalLineAmount = self.charts.yAxis.signAmount;
    horizontalSpacing = (self.charts.frame.size.height - topSpacing - bottomSpacing) / (horizontalLineAmount - 1);
    verticalLineAmount = self.charts.xAxis.signArray.count;
    verticalSpacing = (self.charts.frame.size.width - leftSpacing) / (verticalLineAmount);
    yAxisColor = self.charts.yAxis.color;
    yAxisFont = self.charts.yAxis.font;
    characterSpacing = horizontalSpacing * 5;
    yAxisMax = self.charts.yAxis.max;
    yAxisMin = self.charts.yAxis.min;
    chartsContentHeight = self.charts.frame.size.height - bottomSpacing - topSpacing;

    xAxisYPosition = self.charts.frame.size.height - bottomSpacing - self.charts.xAxis.axisWidth / 2;
    xOrign = leftSpacing;
}

/**
 * (“别人写的”————Cruise Shen注)绘制背景色渐变的矩形，p_colors渐变颜色设置，集合中存储UIColor对象（创建Color时一定用三原色来创建）
 **/
- (void)drawGradientColor   :(CGContextRef)p_context
        rect                :(CGRect)p_clipRect
        options             :(CGGradientDrawingOptions)p_options
        colors              :(NSArray *)p_colors {
    CGContextSaveGState(p_context);             // 保持住现在的context
    CGContextClipToRect(p_context, p_clipRect); // 截取对应的context
    NSUInteger      colorCount = p_colors.count;
    int             numOfComponents = 4;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat         colorComponents[colorCount * numOfComponents];

    for (int i = 0; i < colorCount; i++) {
        UIColor         *color = p_colors[i];
        CGColorRef      temcolorRef = color.CGColor;
        const CGFloat   *components = CGColorGetComponents(temcolorRef);

        for (int j = 0; j < numOfComponents; ++j) {
            colorComponents[i * numOfComponents + j] = components[j];
        }
    }

    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, colorCount);
    CGColorSpaceRelease(rgb);
    CGPoint startPoint = p_clipRect.origin;
    CGPoint endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
    CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options);
    CGGradientRelease(gradient);
    CGContextRestoreGState(p_context);// 恢复到之前的context
}

@end
