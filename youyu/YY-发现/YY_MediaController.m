//
//  YY_MediaController.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_MediaController.h"
#import "YY_MediaCell.h"
#import "QTBaseViewController+Table.h"
#import "QTWebViewController.h"

@interface YY_MediaController ()

@end

static CGFloat  scale = 160 / 233.0;
static CGFloat  widthMargin = 17;
static CGFloat  heightMargin = 33;


@implementation YY_MediaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TABLEReg(YY_MediaCell, @"YY_MediaCell");
    
    [self initTable];
    [self initData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    YY_MediaCell *cell = [YY_MediaCell cellWithTableView:tableView];
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (APP_WIDTH - widthMargin) / 3 * scale + heightMargin + 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    QTWebViewController *webVC = [QTWebViewController controllerFromXib];
    NSString *url = WEB_URL(@"/article/article_detail_app/media/").add(dic.str(@"id"));
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
    dic[@"nid"] = @"media";
    [service post:@"article_list" data:dic complete:^(id value) {
        NSLog(@"value:%@",value);
        [self tableHandleValueNotHub:value ];//tableHandleValueNotHub
    }];
}

@end
