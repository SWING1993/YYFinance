//
//  QTMyVipListViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/31.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMyVipListViewController.h"
#import "QTInvestCell.h"
#import "QTBaseViewController+Table.h"
#import "QTInvestDetailViewController.h"

@interface QTMyVipListViewController ()

@end

@implementation QTMyVipListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleView.title = @"我的VIP订制";
    self.navigationItem.rightBarButtonItem = nil;
    TABLEReg(QTInvestCell, @"QTInvestCell");
}

- (void)initUI {
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initData {
    self.isLockPage = YES;
    [self firstGetData];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTInvestCell";

    QTInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"borrow_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"borrow_info"];

    QTInvestCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (!cell.enable) {
        [self showToast:@"项目还没开始，敬请期待"];
        return;
    } else {
        QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
        controller.borrow_id = dic[@"borrow_id"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSString *)listKey {
    return @"borrow_list";
}

#pragma  mark - json

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;

    dic[@"customization_id"] = self.customization_id;

    [service post:@"vipcustom_borrow" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];
    }];
}

@end
