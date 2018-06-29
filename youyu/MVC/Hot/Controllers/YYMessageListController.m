//
//  YYMessageListController.m
//  youyu
//
//  Created by 宋国华 on 2018/6/15.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMessageListController.h"
#import "YYMessageListCell.h"
#import "YYMessageModel.h"

@interface YYMessageListController ()

@end

@implementation YYMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startApi];
}

- (void)initSubviews {
    [super initSubviews];
}


- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor = kColorBackGround;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [self getHeaderWithRefreshingTarget:self refreshingAction:@selector(startApi)];
    [self.tableView registerClass:[YYMessageListCell class] forCellReuseIdentifier:[YYMessageListCell cellIdentifier]];
}

- (NSDictionary *)configRequestArgument {
    NSMutableDictionary *requestArgument = [NSMutableDictionary new];
    requestArgument[@"cur_page"] = [NSNumber numberWithInteger:self.pageNum];
    requestArgument[@"page_size"] = @20;
    requestArgument[@"type_id"] = self.type_id;
    requestArgument[@"begin_time"] = @"0";
    requestArgument[@"end_time"] = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
    requestArgument[@"user_id"] = [GVUserDefaults shareInstance].user_id;
    return requestArgument;
}

- (void)startApi {
    self.pageNum = 1;
    @weakify(self);
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"webMessage_list" requestArgument:[self configRequestArgument]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            self.maxPageNum = [resultDict.content[@"page_info"][@"total_page"] integerValue];
            NSLog(@"%@",request.responseString);
            if (self.maxPageNum > 1) {
                self.tableView.mj_footer = [self getFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreApi)];
            }
            NSArray *list = resultDict.content[@"message_list"];
            self.dataSource = [[list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                return [YYMessageModel mj_objectWithKeyValues:value];
            }] array];
            [self configCellDataSectionsWithArray:self.dataSource];
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
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"webMessage_list" requestArgument:[self configRequestArgument]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            NSArray *list = resultDict.content[@"message_list"];
            if (list.count > 0) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dataSource];
                [tempArr addObjectsFromArray:[[list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    return [YYMessageModel mj_objectWithKeyValues:value];
                }] array]];
                self.dataSource = [tempArr copy];
                [self configCellDataSectionsWithArray:self.dataSource];
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

- (void)configCellDataSectionsWithArray:(NSArray *)array {
    NSArray *datas = [[array.rac_sequence map:^id _Nullable(YYMessageModel* model) {
        return @[({
            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
            d.cellClass = [YYMessageListCell class];
            d.identifier = 1;
            d.style = UITableViewCellStyleSubtitle;
            d.height = [YYMessageListCell rowHeight];
            d.text = model.title;
            d.detailText = model.sendtime;
            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
            d.didSelectTarget = self;
            d.didSelectAction = @selector(handleDisclosureIndicatorCellEvent:);
            d;
        })];
    }] array];
    QMUIStaticTableViewCellDataSource *dataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:datas];
    self.tableView.qmui_staticCellDataSource = dataSource;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (void)handleDisclosureIndicatorCellEvent:(QMUIStaticTableViewCellData *)cellData {
    // cell 的点击事件，注意第一个参数的类型是 QMUIStaticTableViewCellData
//    [QMUITips showWithText:[NSString stringWithFormat:@"点击了 %@", cellData.text] inView:self.view hideAfterDelay:1.2];
    YYMessageModel * model = self.dataSource[cellData.indexPath.section];
    QTWebViewController *webVC = [[QTWebViewController alloc] init];
    NSString *uri = [NSString stringWithFormat:@"/finance/notice_detail/type_id/%@/id/%@",self.type_id,model.id];
    webVC.url = WEB_URL(uri);
    webVC.isNeedLogin = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
}


@end
