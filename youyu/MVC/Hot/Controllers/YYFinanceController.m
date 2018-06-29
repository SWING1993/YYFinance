//
//  YYFinanceController.m
//  youyu
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYFinanceController.h"
#import "YYBorrowCell.h"
#import "YYBorrowModel.h"
#import "QTInvestDetailViewController.h"

@interface YYFinanceController ()

@end

@implementation YYFinanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startApi];
}

- (void)initSubviews {
    [super initSubviews];
    self.titleView.title = @"理财";
}

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = kColorBackGround;
    self.tableView.rowHeight = [YYBorrowCell rowHeight];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [self getHeaderWithRefreshingTarget:self refreshingAction:@selector(startApi)];
    [self.tableView registerClass:[YYBorrowCell class] forCellReuseIdentifier:[YYBorrowCell cellIdentifier]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)configRequestArgument {
    NSMutableDictionary *requestArgument = [NSMutableDictionary dictionary];
    requestArgument[@"cur_page"] = [NSString stringWithFormat:@"%zi",self.pageNum];
    requestArgument[@"page_size"] = [self getPageSize];
    requestArgument[@"borrow_type"] = @"0";
    requestArgument[@"order_column"] = @"loan_period";
    requestArgument[@"order_value"] = @"asc";
    return requestArgument;
}

- (void)startApi {
    self.pageNum = 1;
    [self.tableView.mj_footer resetNoMoreData];
    @weakify(self);
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"borrow_list" requestArgument:[self configRequestArgument]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            self.maxPageNum = [resultDict.content[@"page_info"][@"total_page"] integerValue];
            if (self.maxPageNum > 1) {
                self.tableView.mj_footer = [self getFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreApi)];
            }
            NSArray *borrow_list = resultDict.content[@"borrow_list"];
            self.dataSource = [[borrow_list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                return [YYBorrowModel mj_objectWithKeyValues:value[@"borrow_info"]];
            }] array];
            [self.tableView reloadData];
        } else {
            [resultDict handleError];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        [resultDict handleError];
    }];
}

- (void)loadMoreApi {
    if (self.pageNum >= self.maxPageNum) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.pageNum ++;
    @weakify(self);
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"borrow_list" requestArgument:[self configRequestArgument]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            NSArray *borrow_list = resultDict.content[@"borrow_list"];
            if (borrow_list.count > 0) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dataSource];
                [tempArr addObjectsFromArray:[[borrow_list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    return [YYBorrowModel mj_objectWithKeyValues:value[@"borrow_info"]];
                }] array]];
                self.dataSource = [tempArr copy];
                [self.tableView reloadData];
            }
        } else {
            self.pageNum --;
            [resultDict handleError];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        self.pageNum --;
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        [resultDict handleError];
    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYBorrowCell *cell = [tableView dequeueReusableCellWithIdentifier:[YYBorrowCell cellIdentifier]];
    if (!cell) {
        cell = [[YYBorrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[YYBorrowCell cellIdentifier]];
    }
    [cell configCellWithModel:self.dataSource[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
    YYBorrowModel *model = self.dataSource[indexPath.section];
    controller.borrow_id = model.id;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
