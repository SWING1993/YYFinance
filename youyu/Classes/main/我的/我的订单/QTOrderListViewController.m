//
//  QTOrderListViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTOrderListViewController.h"
#import "QTOrderCell.h"
#import "QTBaseViewController+Table.h"
#import "QTOrderDetailViewController.h"

@interface QTOrderListViewController ()<DSegmentedControlDelegate>

@end

@implementation QTOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTOrderCell, @"QTOrderCell");
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"我的订单";

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstGetData) name:NOTICEORDER object:nil];
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
}

- (void)initData {
    self.isLockPage = YES;
    [self tableRrefresh];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTOrderCell";
    QTOrderCell     *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"order_info"];

    [cell bind:dic];

    cell.block = ^(NSInteger value) {
        if (value == 1) {
            DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"" message:@"确认收货?"];

            [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];

            [alert addActionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                [self commonJsonOrderreceipt:dic.str(@"order_id")];
            }];

            [alert show];
        } else if (value == 2) {
            [self toMallComment:dic.str(@"order_no")];
        }
    };

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QTOrderDetailViewController *controller = [QTOrderDetailViewController controllerFromXib];
    NSDictionary                *dic = self.tableDataArray[indexPath.row][@"order_info"];

    controller.orderID = dic.str(@"order_id");
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma  mark - json

- (NSString *)listKey {
    return @"order_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"status"] = self.status;
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    [service post:@"mall_orderlist" data:dic complete:^(id value) {
        [self tableHandleValue:value];
    }];
}

- (void)commonJsonOrderreceipt:(NSString *)orderid {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"order_id"] = orderid;
    [service post:@"mall_orderreceipt" data:dic complete:^(id value) {
        NOTICE_POST(NOTICEORDER);
        [self hideHUD];
        [self showToast:@"确定收货成功"];
    }];
}

@end
