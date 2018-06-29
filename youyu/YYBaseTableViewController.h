//
//  YYBaseTableViewController.h
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import <MJRefresh/MJRefresh.h>
@interface YYBaseTableViewController : QMUICommonTableViewController

// 页码
@property (nonatomic, assign, readwrite) NSInteger pageNum;
// 最大页码
@property (nonatomic, assign, readwrite) NSInteger maxPageNum;

@property (nonatomic, copy, readwrite) NSArray *dataSource;


- (NSNumber *)getPageSize;
- (MJRefreshNormalHeader *)getHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (MJRefreshAutoNormalFooter *)getFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
