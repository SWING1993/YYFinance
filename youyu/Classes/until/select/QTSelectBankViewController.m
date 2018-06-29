//
//  QTSelectBankViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/23.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTSelectBankViewController.h"
#import "QTBaseViewController+Table.h"
#import "BankModel.h"
#import "QTBankSelectCell.h"
#import "QTBaseViewController+BankDetail.h"

@interface QTSelectBankViewController ()

@end

@implementation QTSelectBankViewController

- (void)viewDidLoad {
    self.titleView.title = @"选择银行";
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;

    TABLEReg(QTBankSelectCell, @"QTBankSelectCell");
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
}

- (void)initData {
    [self firstGetData];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString     *Identifier = @"QTBankSelectCell";
    QTBankSelectCell    *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSMutableDictionary *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString    *name = self.tableDataArray[indexPath.row][@"bank_name"];
    NSString    *code = self.tableDataArray[indexPath.row][@"bank_code"];

    QTBankSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.updateTip) {
        [self showToast:cell.updateTip duration:bankTipTime];
    } else {
        [self.delegate selectBankCode:code name:name];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)commonJson {
    [service post:@"bank_limit" data:nil complete:^(NSDictionary *value) {
        self.tableDataArray = [value.arr(@"bank_list") getArrayForKey:@"bank_info"];
        self.tableDataArray = [self.tableDataArray where:@" self.status==1 &&  self.quick_pay==1 "];

        [self tableHandle];
    }];
}

@end
