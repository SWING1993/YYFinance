//
//  QTNewGiftViewController.m
//  qtyd
//
//  Created by stephendsw on 15/9/10.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTNewGiftViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTNewGiftCell.h"
#import "QTAccuntHomeViewController.h"

@interface QTNewGiftViewController ()

@end

@implementation QTNewGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"任务大礼包";

    TABLEReg(QTNewGiftCell, @"QTNewGiftCell");

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    NSMutableAttributedString *attsrt = [[NSMutableAttributedString alloc]initWithString:@"温馨提示\n1.本活动长期有效，具体截止时间以官方公告为准。\n2.微信奖励同一手机号和对应的微信号限领一次。\n3.红包券有效期以实际所得为准，请在有效期内尽快使用。"];
    [attsrt setFont:[UIFont systemFontOfSize:12]];
    [attsrt setFont:[UIFont systemFontOfSize:14] string:@"温馨提示"];
    [attsrt setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 8;
    }];

    UILabel *label = [UILabel new];
    label.attributedText = attsrt;
    label.numberOfLines = 0;
    [label sizeToFit];

    [stack addView:label margin:UIEdgeInsetsMake(16, 16, 16, 16)];

    self.tableView.tableFooterView = stack;
}

- (void)initData {
    self.isLockPage = YES;



    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    dic2[@"title"] = @"小试牛刀";
    dic2[@"subtitle"] = @"完成任务:奖励20元红包券";
    dic2[@"condition"] = @"通关秘籍:成功完成首次投资";
    dic2[@"name"] = @"立即投资";
    if ([[GVUserDefaults shareInstance].first_tender_time isEqualToString:@"0"]) {
        dic2[@"state"] = @(0);
    }else
        dic2[@"state"] = @(1);

    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    dic3[@"title"] = @"连签五天";
    dic3[@"subtitle"] = @"完成任务:奖励20元红包券";
    dic3[@"condition"] = @"通关秘籍:连续签到五天";
    dic3[@"name"] = @"立即签到";
    dic3[@"state"] = @(0);

    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    dic4[@"title"] = @"下载APP";
    dic4[@"subtitle"] = @"完成任务:奖励30元红包券";
    dic4[@"condition"] = @"通关秘籍:下载有余金服APP并成功登录";
    dic4[@"name"] = @"完成任务";
    dic4[@"state"] = @(1);

    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:dic2];
    [array addObject:dic3];
    [array addObject:dic4];

    self.tableDataArray = array;

    [self commonJson];
}

- (BOOL)navigationShouldPopOnBackButton {
    if ([[self.navigationController getPreviousController] isMemberOfClass:[QTAccuntHomeViewController class]]) {
        return YES;
    } else {
        [self toAccount];
        return NO;
    }
}

#pragma  mark - json

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IPHONE6 || IPHONE6PLUS) {
        return 100;
    } else {
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTNewGiftCell";

    QTNewGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic IndexPath:indexPath];

    return cell;
}

- (void)commonJson {

    [self showHUD];
    [service post:@"puser_insignList" data:nil complete:^(NSDictionary *value) {


//        ((NSMutableDictionary *)self.tableDataArray[0])[@"state"] =
//        @(value.i(@"first_tender_reward"));  // 首投红包发放状态
        if (value[@"insign_days"] && [value[@"insign_days"] integerValue] >= 5 ) {
            ((NSMutableDictionary *)self.tableDataArray[1])[@"state"] = @(1);
        }
//        ((NSMutableDictionary *)self.tableDataArray[1])[@"state"] =
//        @(value.i(@"sign_reward"));                                                                     // 连续签到五天红包状态
//
//        ((NSMutableDictionary *)self.tableDataArray[2])[@"state"] = @(1);        // 下载APP首次登陆

        [self hideHUD];
        [self.tableView reloadData];
    }];
}

@end
