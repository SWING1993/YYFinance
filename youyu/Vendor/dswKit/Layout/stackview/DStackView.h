//
//  StackView.h
//  test
//
//  Created by stephen on 15/2/12.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLayoutBaseView.h"

/**
 *  堆栈布局
 */
@interface DStackView : DLayoutBaseView

/**
 *  距离父视图边距
 */
@property (nonatomic, assign) CGFloat offsetX;

- (void)addLineForHeight:(CGFloat)h;

- (void)addLineForHeight:(CGFloat)h color:(UIColor *)color;

/**
 *  magin : 影响宽度
 *
 */
- (void)addView:(UIView *)view margin:(UIEdgeInsets)magin;

#pragma mark -delete

- (void)removeFormIndex:(NSInteger)index;

#pragma mark -  获取

- (UIView *)indexForView:(NSInteger)index;

#pragma mark - theme
- (void)setCodeButtonStyle:(UIButton *)item;

- (void)setTfviewStyle:(UITextField *)item;

- (void)setLabelStyle:(UILabel *)item;

- (void)setSubmitButtonStyle:(UIButton *)item;

- (void)setRightButtonStyle:(UIButton *)item;

- (void)setNewSubmitButtonStyle:(UIButton *)item;

@end
