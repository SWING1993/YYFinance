//
//  QTallMoneyViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTallMoneyViewController.h"
#import "QTallMoneyCell.h"

@interface QTallMoneyViewController ()

@property (strong, nonatomic) IBOutlet UIView   *headview;
@property (weak, nonatomic) IBOutlet UILabel    *lbAllMoney;

@end

@implementation QTallMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTallMoneyCell, @"QTallMoneyCell");
    self.titleView.title = @"账户总览";
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
    self.tableView.tableHeaderView = self.headview;
    self.headview.backgroundColor = [Theme backgroundColor];
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
    static NSString *Identifier = @"QTallMoneyCell";

    QTallMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic];

    if ((indexPath.row == 1) || (indexPath.row == 2)) {
        cell.backgroundColor = [Theme backgroundColor];
    }

    if (indexPath.row == 1) {
        cell.lbtext.transform = CGAffineTransformMakeTranslation(0, 5);
        cell.lbMoney.transform = CGAffineTransformMakeTranslation(0, 5);
    }

    if (indexPath.row == 2) {
        cell.lbtext.transform = CGAffineTransformMakeTranslation(0, -5);
        cell.lbMoney.transform = CGAffineTransformMakeTranslation(0, -5);
    }

    if ((indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2)) {
        cell.separatorInset = UIEdgeInsetsMake(0, APP_WIDTH, 0, 0);
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 1) || (indexPath.row == 2)) {
        return 33;
    } else {
        return 50;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

#pragma  mark - json
- (void)commonJson {
    [service post:@"account_home" data:nil complete:^(NSDictionary *value) {
        self.tableDataArray = @[
            @{@"name":@"余额(元)", @"money":value.str(@"account_info.account_sinapay")},
            @{@"name":@"冻结金额(元)", @"money":value.str(@"sinapay_info.freeze_money")},
            @{@"name":@"可用余额(元)", @"money":value.str(@"sinapay_info.available_money")},
            @{@"name":@"待收本金(元)", @"money":value.str(@"account_info.waiting_capital")},
            @{@"name":@"待收收益(元)", @"money":value.str(@"account_info.waiting_interest")}
//            @{@"name":@"可用红包(元)", @"money":value.str(@"account_info.useful_reward")}
            ];

        self.lbAllMoney.text = value.str(@"account_info.account_total");
        [self tableHandle];
    }];
}

@end
