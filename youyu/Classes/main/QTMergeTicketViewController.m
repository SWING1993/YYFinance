//
//  QTMergeTicketViewController.m
//  qtyd
//
//  Created by stephendsw on 2017/1/16.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "QTMergeTicketViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTUser_rewardinfoCellQuan.h"

@interface QTMergeTicketViewController ()

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation QTMergeTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTUser_rewardinfoCellQuan, @"QTUser_rewardinfoCellQuan");
    self.titleView.title = @"合并确定";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];

    [QTTheme btnRedStyle:self.confirmBtn];
    [QTTheme btnWhiteStyle:self.cancelBtn];
    self.bottomView.backgroundColor = [Theme backgroundColor];
}

- (void)initData {
    [self.confirmBtn click:^(id value) {
        [self commonJson];
    }];
    [self.cancelBtn click:^(id value) {
        self.navigationController.tabBarController.selectedIndex = MY_TAG;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self toUserReward];
    }];

    [self commonJsonPreview];
}

#pragma mark table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString             *Identifier = @"QTUser_rewardinfoCellQuan";
    QTUser_rewardinfoCellQuan   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSDictionary                *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic];
    [cell setInvestStyle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.bottomView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 110;
}

#pragma  mark json
- (void)commonJsonPreview {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"reward_all_id"] = self.reward_all_id;
    [service post:@"reward_mergePreview" data:dic complete:^(id value) {
        self.tableDataArray = @[value];
        [self.tableView reloadData];
        [self hideHUD];
    }];
}

- (void)commonJson {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"reward_all_id"] = self.reward_all_id;
    [service post:@"reward_merge" data:dic complete:^(id value) {
        [self hideHUD];
        [self showToast:@"合并成功" duration:1 done:^{
            self.navigationController.tabBarController.selectedIndex = MY_TAG;
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self toUserReward];
        }];
    }];
}

@end
