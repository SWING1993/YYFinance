//
//  DWrapView.h
//  test
//
//  Created by stephen on 15/2/28.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "DLayoutBaseView.h"

/**
 *  流式布局
 */
@interface DWrapView : DLayoutBaseView

- (instancetype)initWidth:(CGFloat)width columns:(NSInteger)column;

- (void)setColumn:(NSInteger)num;

/**
 *  添加视图 内边距  外边距
 */
- (void)addView:(UIView *)view margin:(UIEdgeInsets)edge padding:(UIEdgeInsets)padding;

/**
 *  添加视图  外边距
 */
- (void)addView:(UIView *)view padding:(UIEdgeInsets)padding;

/**
 *  添加视图 内边距
 */
- (void)addView:(UIView *)view margin:(UIEdgeInsets)edge;

/**
 *  单元格高度
 */
@property (nonatomic, assign) CGFloat subHeight;

@property (nonatomic, assign) CGFloat offsetX;

@end
