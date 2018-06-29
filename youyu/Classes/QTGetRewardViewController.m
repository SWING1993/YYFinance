//
//  QTGetRewardViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/3.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTGetRewardViewController.h"

@interface QTGetRewardViewController ()

@property (strong, nonatomic)  WTReTextField *tfcode;

@end

@implementation QTGetRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;

    self.titleView.title = @"礼券兑换";
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfcode = [grid addRowInputWithplaceholder:@"请输入兑换码/兑换口令"];
    self.tfcode.textAlignment = NSTextAlignmentCenter;

    [grid addLineForHeight:20];

    [grid addRowButtonTitle:@"确认兑换" click:^(id value) {
        [self clickSumbit];
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.tfcode.isNeed = YES;

    self.tfcode.nilTip = @"请输入兑换码";

    self.tfcode.group = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tfcode becomeFirstResponder];
}

#pragma  mark - event
- (void)clickSumbit {
    [self.view endEditing:YES];

    if (![self.view validation:0]) {
        return;
    }

    [self commonJson];
}

#pragma  mark - json
- (void)commonJson {
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"exchage_code"] = self.tfcode.text;
    [service post:@"user_rewardexchange" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];

        NOTICE_POST(@"reward");

        NSString *msg;

        NSString *type = @"";

        if (value.i(@"type") == 1) {
            msg = [NSString stringWithFormat:@"兑换成功,%@元红包", value.str(@"reward_money")];
            type = @"0";
        } else if (value.i(@"type") == 2) {
            msg = [NSString stringWithFormat:@"兑换成功,%@元红包券", value.str(@"reward_money")];
            type = @"1";
        } else if (value.i(@"type") == 4) {
            msg = [NSString stringWithFormat:@"兑换成功,%@%%年化券", value.str(@"reward_money")];
            type = @"2";
        }

        DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"" message:msg];

        NSMutableAttributedString *str = [NSMutableAttributedString new];
        [str appendImage:[UIImage imageNamed:@"icon_selected"]];
        alert.titleLabel.attributedText = str;

        [alert addActionWithTitle:@"点击查看" handler:^(CKAlertAction *action) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NoticeQuan" object:type];
            [self.navigationController popViewControllerAnimated:YES];
        }];

        [alert show];
    }];
}

@end
