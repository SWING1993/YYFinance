//
//  FlowView.m
//  test
//
//  Created by stephen on 15/2/12.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "DGridView.h"
#import <objc/runtime.h>
#import "NSObject+quick.h"

#import "DWrapView.h"

//
#pragma mark - 网格

@interface UIView (Row)
@property (nonatomic, assign) NSInteger columnNum;
@end

@implementation UIView (Row)

- (NSInteger)columnNum {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setColumnNum:(NSInteger)columnNum {
    objc_setAssociatedObject(self, @selector(columnNum), @(columnNum), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@interface UIView (Grid)

@property (nonatomic, assign) NSInteger crossColumns;

@end

@implementation UIView (Grid)

- (NSInteger)crossColumns {
    return [objc_getAssociatedObject(self, _cmd)integerValue];
}

- (void)setCrossColumns:(NSInteger)crossColumns {
    objc_setAssociatedObject(self, @selector(crossColumns), @(crossColumns), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
#pragma mark - grid

@implementation DGridView
{
    NSMutableArray *lineList;
}
@synthesize rowHeight;

- (void)setColumn:(NSInteger)s height:(NSInteger)h {
    lineList = [NSMutableArray new];
    self.lineColor = [UIColor colorHex:@"e6e6e6" alpha:0.5];
    self.isShowLine = YES;
    column = s;
    rowHeight = h;
    self.offsetX = 16;
}

- (NSArray<UIView *> *)showRowList {
    NSMutableArray<UIView *> *showRowList = [NSMutableArray new];

    for (UIView *item in self.subviews) {
        if (!item.hidden) {
            [showRowList addObject:item];
        }
    }

    return showRowList;
}

#pragma mark  add

- (void)addRowView:(UIView *)view {
    DWrapView *wrap = [[DWrapView alloc]initWidth:self.width];

    wrap.subHeight = view.height;
    [wrap addView:view];
    view.width = self.width - self.offsetX * 2;
    self.rowHeight = view.height;
    [self addView:wrap crossColumn:column];
    self.rowHeight = 44;
}

- (void)addRowView:(UIView *)view setOffset:(CGFloat)offset{
    DWrapView *wrap = [[DWrapView alloc]initWidth:self.width];
    
    wrap.subHeight = view.height;
    [wrap addView:view];
    view.width = self.width;
    self.rowHeight = view.height;
    view.width = self.width;
    [self addView:view margin:UIEdgeInsetsMake(0, -16, 0, -16)];
    self.rowHeight = 44;

}



- (void)addView:(UIView *)view margin:(UIEdgeInsets)magin {
    if (![view isKindOfClass:[DWrapView class]]) {
        view.columnNum = column;
    }

    [super addView:view margin:magin];
}

- (void)addView:(UIView *)view {
    [self addView:view crossColumn:1];
}

- (void)addView:(UIView *)view crossColumn:(NSInteger)num {
    [self addView:view crossColumn:num margin:UIEdgeInsetsZero];
}

- (void)addView:(UIView *)view crossColumn:(NSInteger)num margin:(UIEdgeInsets)margin {
    [self addView:view crossColumn:num margin:margin padding:UIEdgeInsetsZero];
}

- (void)addView:(UIView *)view crossColumn:(NSInteger)num padding:(UIEdgeInsets)padding {
    [self addView:view crossColumn:num margin:UIEdgeInsetsZero padding:padding];
}

- (void)addView:(UIView *)view crossColumn:(NSInteger)num margin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding {
    // 异常
    NSAssert(column > 0, @"Column 列数不得为0");

    if (view == self) {
        return;
    }

    CGFloat itemWidth = (self.width - self.offsetX * 2 - 1) / column;
    view.width = itemWidth * num;

    BOOL hasLast = NO;

    // frontView 为最后一行
    if (frontView) {
        //有最后一个元素
        if ([frontView isKindOfClass:[DWrapView class]]) {
            //有最后一个元素为wrap
            if (((DWrapView *)frontView).columnNum < column) {
                // warp item 未满格
                hasLast = YES;
            }
        }
    }

    if ([view isKindOfClass:[UILabel class]] && UIEdgeInsetsEqualToEdgeInsets(padding, UIEdgeInsetsZero)) {
        CGFloat offsetTopBottom = (self.rowHeight - ((UILabel *)view).font.pointSize) / 2;

        padding = UIEdgeInsetsMake(offsetTopBottom, 0, offsetTopBottom, 0);
    }

    if (hasLast) {
        // 最后一行
        DWrapView *rowView = (DWrapView *)frontView;
        rowView.columnNum += num;
        [rowView addView:view margin:margin padding:padding];
    } else {
        // 新建一行
        DWrapView *rowView = [[DWrapView alloc]initWidth:self.width];
        rowView.offsetX = self.offsetX;
        rowView.backgroundColor = [UIColor whiteColor];
        rowView.columnNum += num;
        rowView.subHeight = rowHeight;
        [rowView addView:view margin:margin padding:padding];
        [self addView:rowView margin:UIEdgeInsetsZero];
        frontView = rowView;
    }
}

- (void)layoutSubviews {
    //NSLog(@"刷新页面＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");

    [super layoutSubviews];
    [self setBorder];
}

- (void)updateView {
    [super updateView];
    [self setBorder];
}

#pragma mark  show

- (void)showRow:(NSInteger)row {
    self.subviews[row].hidden = NO;
    [self updateView];
}

- (void)hideRow:(NSInteger)row {
    self.subviews[row].hidden = YES;
    [self updateView];
}

#pragma  mark -border
- (void)setBorder {
    // 线条
    for (CALayer *item in lineList) {
        [item removeFromSuperlayer];
    }

    [lineList removeAllObjects];

    //
    // border
    if (self.isShowLine) {
        NSMutableArray<NSMutableArray *> *sectionList = [NSMutableArray new];

        BOOL needAdd = NO;

        for (UIView *item in [self showRowList]) {
            // 提取section分组
            if ([item isKindOfClass:[DWrapView class]]) {
                if (sectionList.count == 0) {
                    needAdd = YES;
                }

                if (needAdd) {
                    NSMutableArray *itemList = [NSMutableArray new];
                    [itemList addObject:item];
                    [sectionList addObject:itemList];
                    needAdd = NO;
                } else {
                    [sectionList.lastObject addObject:item];
                }
            } else {
                needAdd = YES;
            }
        }

        for (NSMutableArray *itemlist in sectionList) {
            for (int i = 0; i < itemlist.count; i++) {
                CGFloat xoffset = self.offsetX;

                UIView *view = itemlist[i];

                if (i == 0) {
                    CALayer *layer = [CALayer new];
                    CGRect  rect = CGRectMake(0, view.top - 1, self.width, 1);
                    layer.frame = GetLineRectX(rect);
                    layer.backgroundColor = self.lineColor.CGColor;
                    [self.layer addSublayer:layer];
                    [lineList addObject:layer];
                }

                if (i == itemlist.count - 1) {
                    xoffset = 0;
                }

                CALayer *layer = [CALayer new];
                CGRect  rect = CGRectMake(xoffset, view.bottom , self.width - xoffset, 1);
                layer.frame = GetLineRectX(rect);
                layer.backgroundColor = self.lineColor.CGColor;
                [self.layer addSublayer:layer];
                [lineList addObject:layer];
            }
        }
    }
}

@end
