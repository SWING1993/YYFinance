//
//  NewPagedFlowView.m
//
//  Created by dsw on 16/7/13.
//  Copyright © 2016年 . All rights reserved.
//  Designed By dsw,
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "NewPagedFlowView.h"

@interface NewPagedFlowView ()

/**
 *  原始页数
 */
@property (nonatomic, assign) NSInteger orginPageCount;

@end

@implementation NewPagedFlowView

#pragma mark - Private Methods
- (void)initialize {
    [self clearSubviews];

    self.clipsToBounds = YES;
    self.pageSize = self.bounds.size;
    self.pageCount = 0;
    self.visibleRange = NSMakeRange(0, 0);

    self.cells = [[NSMutableArray alloc] initWithCapacity:0];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    [self addSubview:self.scrollView];
}

- (void)refreshVisibleCellAppearance {
    if (_minimumPageScale == 1.0) {
        return;// 无需更新
    }

    CGFloat offset = _scrollView.contentOffset.x;

    for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
        UIView  *cell = [_cells objectAtIndex:i];
        CGFloat origin = cell.frame.origin.x;
        CGFloat delta = fabs(origin - offset);

        CGFloat inset = 0;

        if (delta < _pageSize.width) {
            inset = (_pageSize.width * (1 - _minimumPageScale)) * (delta / _pageSize.width) / 2.0;
        } else {
            inset = _pageSize.width * (1 - _minimumPageScale) / 2.0;
        }

        cell.transform = CGAffineTransformMakeScale(1 - (inset / self.width * 2), 1 - (inset / self.width * 2));
    }
}

- (void)setPagesAtContentOffset:(CGPoint)offset {
    // 计算_visibleRange
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);

    int startIndex = (int)(((int)startPoint.x) / _pageSize.width);

    int endIndex = (int)(((int)endPoint.x) / _pageSize.width);

    self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);

    if (startIndex == 0) {
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount + _pageSize.width, 0) animated:NO];
    }

    if (endIndex == 8) {
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount + _pageSize.width, 0) animated:NO];
    }
}

#pragma mark - NewPagedFlowView API

- (void)reloadData {
    [self initialize];

    // 重置pageCount
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInFlowView:)]) {
        // 总页数
        _pageCount = [_dataSource numberOfPagesInFlowView:self] * 3;

        // 原始页数
        self.orginPageCount = [_dataSource numberOfPagesInFlowView:self];
    }

    // 重置pageWidth
    if (_delegate && [_delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
        _pageSize = [_delegate sizeForPageInFlowView:self];
    }

    _visibleRange = NSMakeRange(0, 0);
    _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
    _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, _pageSize.height);
    CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _scrollView.center = theCenter;

    [_scrollView clearSubviews];

    for (int pageIndex = 0; pageIndex < _pageCount; pageIndex++) {
        UIView *cell = [_dataSource flowView:self cellForPageAtIndex:pageIndex % self.orginPageCount];
        [_cells addObject:cell];
        cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);

        if (!cell.superview) {
            [_scrollView addSubview:cell];
        }
    }

    if (self.orginPageCount > 1) {
        // 滚到第二组
        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount + _pageSize.width, 0) animated:NO];
    }

    [self refreshVisibleCellAppearance];                        // 更新各个可见Cell的显示外貌
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCellAppearance];
}

@end
