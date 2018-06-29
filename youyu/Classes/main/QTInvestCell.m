//
//  QTInvestCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestCell.h"
#import "QTCirlceView.h"
#import "QTTheme.h"
#import "NSString+model.h"
#import "GVUserDefaults.h"

@interface QTInvestCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *lbRate;

@property (weak, nonatomic) IBOutlet UILabel *lbDay;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbmoney;

@property (weak, nonatomic) IBOutlet QTCirlceView *processview;

@property (weak, nonatomic) IBOutlet UILabel    *state;
@property (weak, nonatomic) IBOutlet UIView     *lineView;
@property (weak, nonatomic) IBOutlet UILabel    *lbRateTip;
@property (weak, nonatomic) IBOutlet UILabel    *lbArpAdd;

@end

@implementation QTInvestCell
{
    NSTimer *time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.processview.backgroundColor = [UIColor whiteColor];
    self.processview.ringWidth = 2;

    [self hideLine];
    self.contentView.width = APP_WIDTH;
    [self.contentView setTopLine:Theme.borderColor];
    self.lineView.width = APP_WIDTH;
    [self.lineView setTopLine:Theme.borderColor];
    self.lineView.backgroundColor = Theme.backgroundColor;
}

- (void)bind:(NSDictionary *)obj {
    if (time) {
        [time invalidate];
    }

    self.enable = YES;

    // ================状态 ========================================

    // 0等待审核、1审核失败、2投资中、3投资已结束、4已流标、5还款中、6已回款
    NSInteger state = ([obj containsKey:@"borrow_state"] ? obj.str(@"borrow_state") : obj.str(@"real_state")).integerValue;

    if (state == 0) {
        self.state.text = @"等待审核";
    } else if (state == 1) {
        self.state.text = @"审核失败";
    } else if (state == 2) {
        self.state.text = @"立即投资";
    } else if (state == 3) {
        self.state.text = @"已满标";
    } else if (state == 4) {
        self.state.text = @"已流标";
    } else if (state == 5) {
        self.state.text = @"还款中";
    } else if (state == 6) {
        self.state.text = @"已回款";
    } else if (state == 7) {
        self.state.text = @"满标待审";
    }

    NSString *operate = self.state.text;

    if ([operate isEqualToString:@"立即投资"]) {
        self.state.textColor = Theme.redColor;
        self.processview.ringColor = Theme.darkOrangeColor;
        self.processview.rate = obj.fl(@"invent_percent") / 100.0f;
        NSString    *hasMoney = @(obj.fl(@"account") - obj.fl(@"account_yes")).stringValue;
        NSString    *invest_balance = [obj containsKey:@"invest_balance"] ? obj.str(@"invest_balance") : hasMoney;
        self.lbmoney.text = @"可投金额:￥".add([invest_balance moneyFormatShow]);
    } else {
        self.state.textColor = Theme.grayColor;
        self.processview.ringColor = Theme.grayColor;
        self.processview.rate = 1;
        NSString *allMoney = [obj containsKey:@"account"] ? obj.str(@"account") : obj.str(@"loan_amount");
        self.lbmoney.text = @"项目金额".add([allMoney moneyFormatShow]).add(@"元");
    }

    // ================其他 ========================================

    if (obj.fl(@"apr_add") > 0) {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%% +%@%%", obj.str(@"apr"), obj.str(@"apr_add")]];

        [attstr setFont:[UIFont systemFontOfSize:14] string:[NSString stringWithFormat:@"%% +%@%%", obj.str(@"apr_add")]];
        self.lbRate.attributedText = attstr;
        self.lbArpAdd.hidden = NO;
    } else {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%%", obj.str(@"apr")]];

        [attstr setFont:[UIFont systemFontOfSize:14] string:@"%"];
        self.lbRate.attributedText = attstr;
        self.lbArpAdd.hidden = YES;
    }

    if ([obj.str(@"new_hand") isEqualToString:@"1"]
        &&
        ![obj.str(@"investable_users") containsString:[GVUserDefaults shareInstance].user_id]

        ) {
        self.lbRateTip.hidden = YES;
    } else {
        self.lbRateTip.hidden = NO;
    }

    if ([obj.str(@"borrow_type") isEqualToString:@"840"] || [obj.str(@"borrow_type") isEqualToString:@"900"]) {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@"≤".add(obj[@"loan_period"][@"num"]).add(@" 天")];

        [attstr setFont:[UIFont systemFontOfSize:12] string:@"天"];

        self.lbDay.attributedText = attstr;
    } else {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:obj.str(@"loan_period.num").add(@" 天")];

        [attstr setFont:[UIFont systemFontOfSize:12] string:@"天"];

        self.lbDay.attributedText = attstr;
    }

    NSString *borrow_name = obj.str(@"borrow_name");
    self.lbTitle.text = [borrow_name firstBorrowName];

    if ([NSString tenderType:obj]) {
        self.image.image = [UIImage imageNamed:[NSString tenderType:obj]];
    } else {
        self.image.image = nil;
    }

    // ================倒计时========================================================
    if (obj[@"server_time"]) {
        __block NSTimeInterval offtime = obj.i(@"publish_time") - obj.i(@"server_time");

        [time invalidate];

        if (offtime > 0) {
            self.enable = NO;
            time = [NSTimer timerExecuteCountPerSecond:offtime done:^(NSInteger vlaue) {
                    if (vlaue == 0) {
                        self.state.text = obj[@"operate"];
                        self.enable = YES;
                        self.image.image = nil;
                        [time invalidate];
                    } else {
                        self.state.text = [[@(vlaue)stringValue] secondToTimeFormat];
                    }
                }];
        }
    }
}

@end
