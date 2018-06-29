//
//  QTUserListViewController.m
//  qtyd
//
//  Created by stephendsw on 2016/11/3.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTUserListViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTUserListCell.h"

@interface QTUserListViewController ()

@end

@implementation QTUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"userlistreload" object:nil];

    TABLEReg(QTUserListCell, @"QTUserCell");
}

- (void)initUI {
    [self initTable];
    self.view.width = APP_WIDTH;
}

- (void)initData {
    [self bindKeyPath:@"tableDataArray" object:self block:^(id newobj){
        if (self.tableDataArray.count <= 3) {
            self.view.height = 44 * self.tableDataArray.count;
        } else {
            self.view.height = 44 * 3 + 5;
        }
    }];
}

- (void)refreshData {
    self.tableDataArray = SYSTEM_CONFIG.userList;
    [self.tableView reloadData];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTUserCell";
    QTUserListCell  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row];

    [self.delegate UserList:self didSelect:dic];
}

@end
