//
//  QtRecordCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QtRecordCell.h"
#import "NSString+model.h"
#import "RecordModel.h"

@interface QtRecordCell ()

#pragma mark  充值等

@property (weak, nonatomic) IBOutlet UIImageView    *imageState;
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel        *lbtime;
@property (weak, nonatomic) IBOutlet UILabel        *lbMoney;
@property (weak, nonatomic) IBOutlet UILabel        *lbState;

#pragma mark 投资记录

@end

@implementation QtRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    RecordModel *model = [RecordModel new];

    NSString *name = [model getName:obj[@"account_type"]];

    if (name) {
        self.lbTitle.text = name;
    }

    NSString *statue = obj.str(@"status");

    NSString *m = obj.str(@"money");

    if ([statue containsString:@"失败"]) {
        self.lbState.textColor = [Theme redColor];
    } else {
        self.lbState.textColor = [Theme greenColor];
    }

    // + or -  nil
    if ([name containsString:@"提现"]) {
        self.lbMoney.text = @"-".add([m moneyFormatShow]);
        self.imageState.image = [[UIImage imageNamed:@"icon_tixian"] imageWithColor:[Theme redColor]];
    } else if ([name containsString:@"投资"]) {
        self.lbMoney.text = @"-".add([m moneyFormatShow]);
        self.imageState.image = [[UIImage imageNamed:@"qiandai"]imageWithColor:[Theme redColor]];
    } else if ([name containsString:@"还款"]) {
        self.lbMoney.text = @"+".add([m moneyFormatShow]);
        self.imageState.image = [[UIImage imageNamed:@"icon_return_money"] imageWithColor:[Theme redColor]];
    } else {
        self.lbMoney.text = @"+".add([m moneyFormatShow]);
        self.imageState.image = [[UIImage imageNamed:@"icon_chongzhi"] imageWithColor:[Theme redColor]];
    }

    self.lbtime.text = [obj.str(@"addtime") timeValue];

    self.lbState.text = obj.str(@"status");
}

- (void)bindOrder:(NSDictionary *)obj {
    self.lbTitle.text = @"投资".add([obj.str(@"borrow_name")  firstBorrowName]);
    NSString *m = obj.str(@"tender_money");

    NSInteger status = obj.i(@"tender_status");

    if (status == 0) {
        self.lbMoney.text = @"-".add([m moneyFormatShow]);
        self.imageState.image = [UIImage imageNamed:@"icon_daizhifu_touzijilu_2x_03"];
        self.lbState.text = @"未完成";
        self.lbState.textColor = [Theme darkOrangeColor];
    } else if (status == 1) {
        self.lbMoney.text = @"-".add([m moneyFormatShow]);
        self.imageState.image = [UIImage imageNamed:@"icon_touzichenggong_touzijilu_2x_03"];
        self.lbState.text = @"投资成功";
        self.lbState.textColor = [Theme greenColor];
    } else if (status == 2) {
        self.lbMoney.text = @"-".add([m moneyFormatShow]);
        self.imageState.image = [UIImage imageNamed:@"icon_touzishibai_touzijilu_2x_03"];
        self.lbState.text = @"投资失败";
        self.lbState.textColor = [Theme grayColor];
    }

    self.lbtime.text = [obj.str(@"addtime") timeValue];
}

@end
