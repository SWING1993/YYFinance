//
//  UIView+quick.h
//  test
//
//  Created by stephen on 15/2/28.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  LINE_WIDTH                  1

#define SINGLE_LINE_WIDTH           (LINE_WIDTH / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((LINE_WIDTH / [UIScreen mainScreen].scale) / 2)

CGRect GetLineRectX(CGRect rect);

CGRect GetLineRectY(CGRect rect);

typedef void (^ tapBlcok)();

@interface UIView (layout)

+ (instancetype)viewNib;

- (instancetype)initWidth:(CGFloat)w Height:(CGFloat)h;

/**
 *  清空子视图
 */
- (void)clearSubviews;

/**
 *  所有子视图
 *
 */
- (NSMutableArray *)allSubviews;

/**
 *  设置底部线条
 *
 *  @param color 颜色
 */
- (void)setBottomLine:(UIColor *)color;

/**
 *  设置左线条
 *
 *  @param color 颜色
 */
- (void)setLeftLine:(UIColor *)color;

/**
 *  设置顶线条
 *
 *  @param color 颜色
 */
- (void)setTopLine:(UIColor *)color;

/**
 *  设置右线条
 *
 */
- (void)setRightLine:(UIColor *)color;

/**
 *  当前视图的视图控制器
 */
@property (nonatomic, readonly) UIViewController *viewController;

@end
