//
//  QTActivityListViewController.m
//  qtyd
//
//  Created by stephendsw on 16/8/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTActivityListViewController.h"
#import "QTActivityCell.h"
#import "QTBaseViewController+Table.h"
#import "QTWebViewController.h"

@interface QTActivityListViewController ()

@end

@implementation QTActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTActivityCell, @"QTActivityCell");

    self.navigationItem.rightBarButtonItem = nil;
    self.titleView.title = @"活动专区";
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
    self.tableView.separatorStyle = NO;
}

- (void)initData {
    [self firstGetData]; // 刷新表数据
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_card_address"]];

    imageview.contentMode = UIViewContentModeScaleAspectFit;
    return imageview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTActivityCell";
    QTActivityCell  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return APP_WIDTH / 328.0 * 164.0+40;
}

//选中操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary        *dic = self.tableDataArray[indexPath.row];
    QTWebViewController *controller = [QTWebViewController new];
    controller.isNeedLogin = YES;
    controller.url = dic.str(@"url");

    [self.navigationController pushViewController:controller animated:YES];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无活动";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma  mark - json

- (NSString *)listKey {
    return @"activity_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    [service post:@"article_activity" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];
    }];
}

@end
