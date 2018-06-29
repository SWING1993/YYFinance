//
//  NewPagedFlowView.h
//
//  Created by dsw on 16/7/13.
//  Copyright © 2016年 . All rights reserved.
//  Designed By dsw,
//  github:https://github.com/PageGuo/NewPagedFlowView

#import <UIKit/UIKit.h>

@protocol NewPagedFlowViewDataSource;
@protocol NewPagedFlowViewDelegate;

@interface NewPagedFlowView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGSize    pageSize;   // 一页的尺寸
@property (nonatomic, assign) NSInteger pageCount;  // 总页数

@property (nonatomic, strong) NSMutableArray    *cells;
@property (nonatomic, assign) NSRange           visibleRange;

@property (nonatomic, assign)   id<NewPagedFlowViewDataSource>  dataSource;
@property (nonatomic, assign)   id<NewPagedFlowViewDelegate>    delegate;

/**
 *  非当前页的缩放比例
 */
@property (nonatomic, assign) CGFloat minimumPageScale;

- (void)reloadData;

@end

@protocol  NewPagedFlowViewDelegate<NSObject>

/**
 *  单个子控件的Size
 *
 */
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView;

@end

@protocol NewPagedFlowViewDataSource<NSObject>

/**
 *  返回显示View的个数
 *
 */
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView;

/**
 *  给某一列设置属性
 */
- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end
