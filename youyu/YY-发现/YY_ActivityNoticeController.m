//
//  YY_ActivityNoticeController.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_ActivityNoticeController.h"
#import "YY_ActivityNoticeCell.h"
#import "QTBaseViewController+Table.h"
#import "QTWebViewController.h"

@interface YY_ActivityNoticeController ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
//cell height :240
@implementation YY_ActivityNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现";
    TABLEReg(YY_ActivityNoticeCell, @"YY_ActivityNoticeCell");
    [self initTable];
    [self initData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YY_ActivityNoticeCell *cell = [YY_ActivityNoticeCell cellWithTableView:tableView];
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    QTWebViewController *webVC = [QTWebViewController controllerFromXib];
    NSString *url = WEB_URL(@"/article/article_detail_app/news/").add(dic.str(@"id"));
//    webVC.htmlContent = dic[@"content"];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - commonJson
- (void)initData {
    [self tableRrefresh];
}

- (NSString *)listKey {
    return @"article_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"nid"] = @"notice";
    dic[@"notice_type"] = @2;
    [service post:@"article_list" data:dic complete:^(id value) {
        NSLog(@"value:%@",value);
        [self tableHandleValueNotHub:value];
    }];
}

@end
