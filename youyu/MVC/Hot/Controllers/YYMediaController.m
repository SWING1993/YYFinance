//
//  YYMediaController.m
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMediaController.h"
#import "YYMediaCell.h"
#import "YYMediaModel.h"

@interface YYMediaController ()

@end

@implementation YYMediaController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self startApi];
}

- (void)initSubviews {
    [super initSubviews];
    self.titleView.title = @"了解平台";
}

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = kColorBackGround;
    self.tableView.rowHeight = [YYMediaCell rowHeight];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [self getHeaderWithRefreshingTarget:self refreshingAction:@selector(startApi)];
    [self.tableView registerClass:[YYMediaCell class] forCellReuseIdentifier:[YYMediaCell cellIdentifier]];
}

- (NSDictionary *)configRequestArgument {
    NSMutableDictionary *requestArgument = [NSMutableDictionary dictionary];
    requestArgument[@"cur_page"] = [NSNumber numberWithInteger:self.pageNum];
    requestArgument[@"page_size"] = [self getPageSize];
    requestArgument[@"nid"] = @"media";
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
    YYMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:[YYMediaCell cellIdentifier]];
    if (!cell) {
        cell = [[YYMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[YYMediaCell cellIdentifier]];
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
    QTWebViewController *webVC = [[QTWebViewController alloc] init];
    YYMediaModel *model = self.dataSource[indexPath.section];
    NSString *url = [WEB_URL(@"/article/article_detail_app/media/") stringByAppendingFormat:@"%@",model.id];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
