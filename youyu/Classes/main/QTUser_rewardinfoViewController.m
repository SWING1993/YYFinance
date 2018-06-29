//
//  QTUser_rewardinfoViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTUser_rewardinfoViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTUserRewardinfoCell.h"
#import "QTUser_rewardinfoCellQuan.h"
#import "QTAddItemView.h"
#import "QTMergeTicketViewController.h"

@interface QTUser_rewardinfoViewController ()

@property (strong, nonatomic) IBOutlet UIView *sessionHeadView;

@property (weak, nonatomic) IBOutlet UIButton   *sbtn;
@property (weak, nonatomic) IBOutlet UILabel    *slbmoney;
@property (strong, nonatomic) IBOutlet UIView   *rewordHeadView;
@property (weak, nonatomic) IBOutlet UILabel    *lbRewardCount;

@property (strong, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UILabel    *lbSelectMoney;
@property (weak, nonatomic) IBOutlet UIButton   *selectBtn;

@end

@implementation QTUser_rewardinfoViewController
{
    NSMutableArray<NSIndexPath *> *selectList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.segment == 2) {
        self.titleView.title = @"合并红包券";
    } else if (self.segment == 3) {
        self.titleView.title = @"合并红包券详情";
    }

    self.navigationItem.rightBarButtonItem = nil;

    [self.tableView registerClass:[QTUserRewardinfoCell class] forCellReuseIdentifier:[QTUserRewardinfoCell cellIdentifier]];
//    TABLEReg(QTUserRewardinfoCell, @"QTUserRewardinfoCell");
    TABLEReg(QTUser_rewardinfoCellQuan, @"QTUser_rewardinfoCellQuan");

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commonJson) name:@"reward" object:nil];
}

- (void)initUI {
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [QTTheme btnRedStyle:self.sbtn];

    [self.sbtn click:^(id value) {
        [self toInvest];
    }];

    [QTTheme btnGrayStyle:self.selectBtn];
    self.selectBtn.cornerRadius = 0;

    if (self.segment == 2) {
        [self addBottomView:self.bottomView];
        self.canRefresh = NO;
    }

    [self.selectBtn click:^(id value) {
        NSMutableString *idstr = [NSMutableString new];

        for (NSIndexPath *index in selectList) {
            NSDictionary *dic = self.tableDataArray[index.row];
            [idstr appendString:dic.str(@"reward_info.id")];
            [idstr appendString:@","];
        }

        [self showHUD];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"reward_all_id"] = idstr;
        [service post:@"reward_mergePreview" data:dic complete:^(id value) {
            [self hideHUD];
            QTMergeTicketViewController *controller = [QTMergeTicketViewController controllerFromXib];
            controller.reward_all_id = idstr;
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }];
}

- (void)initData {
    selectList = [NSMutableArray new];
    self.isLockPage = YES;
    [self tableRrefresh];
}

- (void)setSelectMoney {
    CGFloat sum = 0;

    for (NSIndexPath *index in selectList) {
        NSDictionary *dic = self.tableDataArray[index.row];
        sum += dic.fl(@"reward_info.money");
    }

    NSString *money = [[NSString stringWithFormat:@"%f", sum]moneyFormatShow];

    self.lbSelectMoney.text = [NSString stringWithFormat:@"合并总额:%@元", money];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segment == 0) {
//        QTUserRewardinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[QTUserRewardinfoCell cellIdentifier]];
//        if (!cell) {
//            cell = [[QTUserRewardinfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[QTUserRewardinfoCell cellIdentifier]];
//        }
//        NSDictionary *dic = self.tableDataArray[indexPath.row][@"reward_info"];
//        [cell bind:dic];
//        return cell;
        static NSString *Identifier = @"QTUser_rewardinfoCellQuan";
        QTUser_rewardinfoCellQuan *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        NSDictionary *dic = self.tableDataArray[indexPath.row][@"reward_info"];
        [cell bind:dic];
        return cell;
    } else if (self.segment == 1) {
        static NSString *Identifier = @"QTUser_rewardinfoCellQuan";
        QTUser_rewardinfoCellQuan *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        NSDictionary *dic = self.tableDataArray[indexPath.row][@"reward_info"];
        [cell bind:dic];
        [cell setTap];
        return cell;
    } else if (self.segment == 2) {
        static NSString *Identifier = @"QTUser_rewardinfoCellQuan";
        QTUser_rewardinfoCellQuan *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        NSDictionary *dic = self.tableDataArray[indexPath.row][@"reward_info"];
        [cell bind:dic];
        if ([selectList containsObject:indexPath]) {
            [cell setSelectStyle];
        } else {
            [cell setUnselectStyle];
        }
        return cell;
    } else {
        // self.segment == 3
        static NSString *Identifier = @"QTUser_rewardinfoCellQuan";
        QTUser_rewardinfoCellQuan *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        NSDictionary *dic = self.tableDataArray[indexPath.row];
        [cell bind:dic];
        [cell setMergeStyle];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.sessionHeadView.backgroundColor = Theme.backgroundColor;
    if (self.segment == 0) {
        return self.sessionHeadView;
    } else if (self.segment == 1) {
        return self.rewordHeadView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segment == 0) {
        return 80;
    } else if (self.segment == 1) {
        return 55;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segment == 1) {
        NSDictionary *dic = self.tableDataArray[indexPath.row][@"reward_info"];
        if ([dic.str(@"reward_name") containsString:@"合并红包券"]) {
            QTUser_rewardinfoViewController *controller = [QTUser_rewardinfoViewController controllerFromXib];
            controller.segment = 3;
            controller.rewardID = dic[@"id"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    if (self.segment == 2) {
        QTUser_rewardinfoCellQuan *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([selectList containsObject:indexPath]) {
            [selectList removeObject:indexPath];
            [cell setUnselectStyle];
        } else {
            [selectList addObject:indexPath];
            [cell setSelectStyle];
        }
        [self setSelectMoney];
        if (selectList.count >= 2) {
            [QTTheme btnRedStyle:self.selectBtn];
        } else {
            [QTTheme btnGrayStyle:self.selectBtn];
        }
        self.selectBtn.cornerRadius = 0;
    }

}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无券";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    [str setFont:[UIFont systemFontOfSize:12] string:text];
    return str;
}

#pragma  mark - json

- (NSString *)listKey {
    return @"reward_list";
}

- (void)commonJson {
    if (self.segment == 3) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"reward_id"] = self.rewardID;

        [service post:@"reward_mergeDetail" data:dic complete:^(NSDictionary *value) {
            [self tableHandleValue:value];
        }];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        if (self.segment == 0) {
            dic[@"reward_type"] = @"1";
        } else {
            dic[@"reward_type"] = @"2";
        }

        dic[@"cur_page"] = self.current_page;
        dic[@"page_size"] = PAGES_SIZE;

        if (self.segment == 2) {
            dic[@"reward_status"] = @"can_merge";

            if ([self.current_page isEqualToString:@"1"]) {
                [selectList removeAllObjects];
                [QTTheme btnGrayStyle:self.selectBtn];
                self.selectBtn.cornerRadius = 0;
                [self setSelectMoney];
            }
        }

        [service post:@"user_rewardlist" data:dic complete:^(NSDictionary *value) {
            [self tableHandleValue:value];
        }];
        [self commonJsonGet];
    }
}

- (void)commonJsonGet {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"reward_type"] = @"1";
    [service post:@"user_rewardinfo" data:dic complete:^(NSDictionary *value) {
        self.slbmoney.text = [NSString stringWithFormat:@"%@元", [value.str(@"non_use_reward_money") moneyFormatShow]];

        self.lbRewardCount.text = value.str(@"non_use_reward_tickets_count");
    }];
}

@end
