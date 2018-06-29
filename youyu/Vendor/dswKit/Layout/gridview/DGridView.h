//
//  FlowView.h
//  test
//
//  Created by stephen on 15/2/12.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLayoutBaseView.h"
#import "NSObject+KVO.h"
#import "DStackView.h"

/**
 *  网格布局
 */
@interface DGridView : DStackView

{
    // 配置
    CGFloat column;
    CGFloat rowHeight;
}
@property (nonatomic, assign) CGFloat rowHeight;

#pragma mark  init

- (void)setColumn:(NSInteger)s height:(NSInteger)h;

#pragma mark  show line

@property (nonatomic, strong)  UIColor *lineColor;

@property (nonatomic, assign) BOOL isShowLine;

#pragma mark  add view

/**
 *   添加一行
 */
- (void)addRowView:(UIView *)view;
- (void)addRowView:(UIView *)view setOffset:(CGFloat)offset;

- (void)addView:(UIView *)view crossColumn:(NSInteger)num;

- (void)addView:(UIView *)view crossColumn:(NSInteger)num margin:(UIEdgeInsets)padding;

#pragma mark  delete view

// - (void)removeRow:(NSInteger)row;

#pragma mark  show hide

- (void)showRow:(NSInteger)row;

- (void)hideRow:(NSInteger)row;

@end
