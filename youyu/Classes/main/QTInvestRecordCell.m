//
//  QTInvestRecordCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestRecordCell.h"
#import "NSString+model.h"
#import "QTTheme.h"

@interface QTInvestRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel    *lbTip;
@property (weak, nonatomic) IBOutlet UILabel    *lbMoney1;

@property (weak, nonatomic) IBOutlet UILabel    *lbmoney2;
@property (weak, nonatomic) IBOutlet UILabel    *lbTimeS;

@property (weak, nonatomic) IBOutlet UILabel    *lbTimeEnd;
@property (weak, nonatomic) IBOutlet UILabel    *lbTipMoney1;
@property (weak, nonatomic) IBOutlet UILabel    *lbTipMoney2;
@property (weak, nonatomic) IBOutlet UILabel    *lbPay;
@property (weak, nonatomic) IBOutlet UILabel    *lbTipLazy;

@end

@implementation QTInvestRecordCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [QTTheme lbStyle2:self.lbTip];
    [QTTheme lbStyle2:self.lbTipLazy];

    self.contentView.layer.masksToBounds = YES;
    self.layer.masksToBounds = YES;
}

- (void)bind:(NSDictionary *)obj {
    [self.lbState setRotation:-M_PI_4];

    self.lbTitle.text = obj.str(@"borrow_name");

    NSString *tip = obj.str(@"borrow_style");

    if ([tip integerValue] == 1) {
        self.lbTip.text = @" 到期付 ";
    } else {
        self.lbTip.text = @" 按月付 ";
    }

    if (obj.i(@"is_lazy_tender") == 1) {
        self.lbTipLazy.hidden = NO;
    } else {
        self.lbTipLazy.hidden = YES;
    }

    self.lbTimeS.text = [obj.str(@"tender_add_time") dateValue];

    if ([obj.str(@"borrow_type") isEqualToString:@"840"] || [obj.str(@"borrow_type") isEqualToString:@"900"] ) {
        self.lbTimeEnd.text = [obj.str(@"tender_end_time") dateValue].add(@"之前");
    } else {
        self.lbTimeEnd.text = [obj.str(@"tender_end_time") dateValue];
    }

    self.lbMoney1.text = [obj.str(@"tender_money") moneyFormatShow];

    //  标真实状态(0等待审核、1审核失败、2投资中、3投资已结束、4已流标、5还款中、6已回款)
    if ([obj.str(@"real_state") isEqualToString:@"6"]) {
        self.lbState.backgroundColor = [Theme grayColor];
        self.lbState.text = @"已回款";
        self.lbTipMoney1.text = @"已收本金(元)";
        self.lbTipMoney2.text = @"已收收益(元)";
        self.lbmoney2.text = [obj.str(@"tender_interest") moneyFormatShow];
    } else if ([obj.str(@"real_state") isEqualToString:@"4"]) {
        self.lbState.backgroundColor = [Theme grayColor];
        self.lbState.text = @"已流标";
        self.lbTipMoney1.text = @"投资金额(元)";
        self.lbTipMoney2.text = @"待收收益(元)";
        self.lbmoney2.text = [obj.str(@"tender_wait_interest") moneyFormatShow];
    } else if ([obj.str(@"real_state") isEqualToString:@"5"]) {
        self.lbState.backgroundColor = [Theme darkOrangeColor];
        self.lbState.text = @"还款中";
        self.lbTipMoney1.text = @"待收本金(元)";

        if ([obj.str(@"borrow_type") isEqualToString:@"840"] || [obj.str(@"borrow_type") isEqualToString:@"900"] ) {
            self.lbTipMoney2.text = @"预计收益(元)";
        } else {
            self.lbTipMoney2.text = @"待收收益(元)";
        }

        self.lbmoney2.text = [obj.str(@"tender_wait_interest") moneyFormatShow];
    } else {
        self.lbState.backgroundColor = [Theme darkOrangeColor];
        self.lbState.text = @"履约中";
        self.lbTipMoney1.text = @"待收本金(元)";

        if ([obj.str(@"borrow_type") isEqualToString:@"840"] || [obj.str(@"borrow_type") isEqualToString:@"900"]) {
            self.lbTipMoney2.text = @"预计收益(元)";
        } else {
            self.lbTipMoney2.text = @"待收收益(元)";
        }

        self.lbmoney2.text = [obj.str(@"tender_wait_interest") moneyFormatShow];
    }

    self.lbPay.text = [NSString stringWithFormat:@"%@/%@", obj.str(@"pay_count"), obj.str(@"all_count")];
}

@end
