//
//  YYActivityListController.m
//  youyu
//
//  Created by 宋国华 on 2018/6/13.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYActivityListController.h"
#import "YYActivityListCell.h"
#import "YYMediaModel.h"

@interface YYActivityListController ()

@end

@implementation YYActivityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startApi];
}

- (void)initSubviews {
    [super initSubviews];
    self.titleView.title = @"活动专区";
}

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = kColorBackGround;
    self.tableView.rowHeight = [YYActivityListCell rowHeight];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [self getHeaderWithRefreshingTarget:self refreshingAction:@selector(startApi)];
    [self.tableView registerClass:[YYActivityListCell class] forCellReuseIdentifier:[YYActivityListCell cellIdentifier]];
}

- (NSDictionary *)configRequestArgument {
    NSMutableDictionary *requestArgument = [NSMutableDictionary dictionary];
    requestArgument[@"cur_page"] = [NSNumber numberWithInteger:self.pageNum];
    requestArgument[@"page_size"] = [self getPageSize];
    requestArgument[@"nid"] = @"notice";
    requestArgument[@"notice_type"] = @2;
    return requestArgument;
}

- (void)startApi {
    self.pageNum = 1;
    [self.tableView.mj_footer resetNoMoreData];
    @weakify(self);
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"article_list" requestArgument:[self configRequestArgument]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            self.maxPageNum = [resultDict.content[@"page_info"][@"total_page"] integerValue];
            if (self.maxPageNum > 1) {
                self.tableView.mj_footer = [self getFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreApi)];
            }
            NSArray *borrow_list = resultDict.content[@"article_list"];
            self.dataSource = [[borrow_list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                return [YYMediaModel mj_objectWithKeyValues:value[@"article_info"]];
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
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"article_list" requestArgument:[self configRequestArgument]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            NSArray *borrow_list = resultDict.content[@"article_list"];
            if (borrow_list.count > 0) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dataSource];
                [tempArr addObjectsFromArray:[[borrow_list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    return [YYMediaModel mj_objectWithKeyValues:value[@"article_info"]];
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
    YYActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:[YYActivityListCell cellIdentifier]];
    if (!cell) {
        cell = [[YYActivityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[YYActivityListCell cellIdentifier]];
    }
    [cell configCellWithModel:self.dataSource[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YYMediaModel *model = self.dataSource[section];
    UILabel *titleLabel = [[UILabel alloc] initWithFont:UIFontLightMake(12) textColor:kColorTextBlack text:model.publish];
    titleLabel.frame = CGRectMake(0, 0, kScreenW, 40);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YYMediaModel *model = self.dataSource[indexPath.section];
    NSString *urlStr = [WEB_URL(@"/article/article_detail_app/news/") stringByAppendingFormat:@"%@",model.id];
    YYWebViewController *webVC = [[YYWebViewController alloc] initWithUrlStr:urlStr];
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
