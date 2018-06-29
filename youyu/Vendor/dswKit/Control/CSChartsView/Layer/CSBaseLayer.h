//
//  CSBaseLayer.h
//  qtyd
//
//  Created by stephendsw on 15/8/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CSCharts.h"
#import "NSString+BoundingRect.h"
#import "CSChartsPoint.h"

@interface CSBaseLayer : CALayer
{
    CGSize      yAxisCharacterSize;
    CGSize      xAxisCharacterSize;
    CGFloat     bottomSpacing;
    CGFloat     leftSpacing;
    CGFloat     topSpacing;
    NSInteger   horizontalLineAmount;
    CGFloat     horizontalSpacing;
    NSUInteger  verticalLineAmount;
    CGFloat     verticalSpacing;
    UIColor     *yAxisColor;
    UIFont      *yAxisFont;
    CGFloat     characterSpacing;
    CGFloat     chartsContentHeight;
    CGFloat     yAxisMax;
    CGFloat     yAxisMin;
    CGFloat     unitHeight;
    CGFloat     xAxisYPosition;
    CGFloat     xOrign;
}

@property(nonatomic, weak) CSCharts *charts;

- (void)paramsPreparation;

- (void)drawGradientColor   :(CGContextRef)p_context
        rect                :(CGRect)p_clipRect
        options             :(CGGradientDrawingOptions)p_options
        colors              :(NSArray *)p_colors;

@end
