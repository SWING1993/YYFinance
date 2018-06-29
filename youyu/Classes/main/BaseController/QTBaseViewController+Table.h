//
//  QTBaseViewController+Table.h
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"

#define PAGES_SIZE @"16"

@interface QTBaseViewController (Table)<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSString *total_count;

@property (nonatomic, strong) NSString *total_page;

@property (nonatomic, strong) NSString *current_page;

@property (nonatomic, strong) NSArray *tableDataArray;

@property (strong, nonatomic )NSArray *fullProjectDataArray;
@property (strong, nonatomic )NSArray *RapaidProjectDataArray;
@property (strong, nonatomic )NSArray *investingProjectDataArray;
@property (strong, nonatomic) NSArray *newUserProjectArray;
@property (strong, nonatomic) NSArray *VipProjectArray;

@property (strong, nonatomic) NSMutableArray *allDataArray;

- (void)initTable;

- (void)tableRrefresh;

/**
 *  数据转化
 *
 */
- (void)dataFormat;

/**
 *  分页  - 数据源 keypath
 *
 */
- (NSString *)listKey;

/**
 *  单页数据处理 不隐藏hub
 */
- (void)tableHandleNotHub;

/**
 *  单页数据处理 隐藏hub
 */
- (void)tableHandle;

/**
 *  分页数据处理 隐藏hub
 *
 */
- (void)tableHandleValue:(NSDictionary *)dic;

- (void)tableHandleInvesting:(NSDictionary*)dic;
- (void)tableHandleFull:(NSDictionary*)dic;
- (void)tableHandleRapid:(NSDictionary*)dic;

- (void)tableHandleNewProject:(NSDictionary*)dic;
- (void)tableHandleVip:(NSDictionary*)dic;

/**
 *  分页数据处理 不隐藏hub
 *
 */
- (void)tableHandleValueNotHub:(NSDictionary *)dic;

@end
