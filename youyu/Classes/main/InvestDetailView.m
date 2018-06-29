//
//  InvestDetailView.m
//  qtyd
//
//  Created by stephendsw on 15/9/8.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "InvestDetailView.h"
#import "NSString+quick.h"
#import "NSString+model.h"
#import "QTTheme.h"
#import "GVUserDefaults.h"

#import "QTCirlceView.h"
@interface InvestDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *lbtitle;

@property (weak, nonatomic) IBOutlet UILabel *lbarp;

@property (weak, nonatomic) IBOutlet UILabel *lbTitlemoney;

@property (weak, nonatomic) IBOutlet UILabel *lbpmoney;

@property (weak, nonatomic) IBOutlet UILabel *lbdays;

@property (weak, nonatomic) IBOutlet UILabel *lblimitMoney;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIView     *lineView;
@property (weak, nonatomic) IBOutlet UILabel    *lbArpTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbStartTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbDateTitle;

@end

@implementation InvestDetailView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];
}

- (void)bind:(NSDictionary *)value {
    if ([NSString tenderType:value]) {
        self.image.image = [UIImage imageNamed:[NSString tenderType:value]];
    } else {
        self.image.image = nil;
    }

    NSString                    *title = [value.str(@"borrow_name") firstBorrowNameNoFormat].add(@" ");
    NSMutableAttributedString   *attStr = [[NSMutableAttributedString alloc]initWithString:title];

    if (value.fl(@"apr_add") > 0) {
        [attStr appendImageName:@"icon_apr_add"];
    }

    self.lbtitle.attributedText = attStr;

    if (value.fl(@"apr_add") > 0) {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%% +%@%%", value.str(@"apr"), value.str(@"apr_add")]];

        [attstr setFont:[UIFont systemFontOfSize:14] string:[NSString stringWithFormat:@"%% +%@%%", value.str(@"apr_add")]];
        self.lbarp.attributedText = attstr;
    } else {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%%", value.str(@"apr")]];

        [attstr setFont:[UIFont systemFontOfSize:14] string:@"%"];
        self.lbarp.attributedText = attstr;
    }

    if ([value.str(@"borrow_type") isEqualToString:@"840"] || [value.str(@"borrow_type") isEqualToString:@"900"]) {
        self.lbdays.text = [NSString stringWithFormat:@"≤%@ 天", value.str(@"borrow_rest_time")];
    } else {
        self.lbdays.text = [NSString stringWithFormat:@"%@ 天", value.str(@"borrow_rest_time")];
    }

    self.lblimitMoney.text = [NSString stringWithFormat:@"%@元", value.str(@"invest_minimum")];

    if ([value.str(@"operate.name") isEqualToString:@"已回款"] || [value.str(@"operate.name") isEqualToString:@"已满标"]) {
        self.lbTitlemoney.text = @"项目总额";
        self.lbpmoney.text = [value.str(@"borrow_account") moneyFormatShow].add(@"元");
    } else {
        self.lbTitlemoney.text = @"可投金额";
        self.lbpmoney.text = [value.str(@"invest_balance") moneyFormatShow].add(@"元");
    }
}

- (void)bindDetailPage:(NSDictionary *)value {
    self.lineView.hidden = YES;

    self.lbarp.transform = CGAffineTransformMakeTranslation(0, -30);
    self.lbArpTitle.transform = CGAffineTransformMakeTranslation(0, 28);

    self.lbpmoney.transform = CGAffineTransformMakeTranslation(0, -25);
    self.lbTitlemoney.transform = CGAffineTransformMakeTranslation(0, 22);

    self.lblimitMoney.transform = CGAffineTransformMakeTranslation(0, -25);
    self.lbStartTitle.transform = CGAffineTransformMakeTranslation(0, 22);

    self.lbdays.transform = CGAffineTransformMakeTranslation(0, -25);
    self.lbDateTitle.transform = CGAffineTransformMakeTranslation(0, 22);

    if ([NSString tenderType:value]) {
        self.image.image = [UIImage imageNamed:[NSString tenderType:value]];
    } else {
        self.image.image = nil;
    }

    NSString *title = [value.str(@"borrow_name") lastBorrowName].add(@" ");

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:title];

    self.lbtitle.attributedText = attStr;


        if (value.fl(@"apr_add") > 0) {
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%% +%@%%", value.str(@"apr"), value.str(@"apr_add")]];

            [attstr setFont:[UIFont systemFontOfSize:14] string:[NSString stringWithFormat:@"%% +%@%%", value.str(@"apr_add")]];
            self.lbarp.attributedText = attstr;
        } else {
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%%", value.str(@"apr")]];

            [attstr setFont:[UIFont systemFontOfSize:14] string:@"%"];
            self.lbarp.attributedText = attstr;
        }

    if ([value.str(@"borrow_type") isEqualToString:@"840"] ||[value.str(@"borrow_type") isEqualToString:@"900"] ) {
        self.lbdays.text = [NSString stringWithFormat:@"≤%@ 天", value.str(@"loan_period.num")];
    } else {
        self.lbdays.text = [NSString stringWithFormat:@"%@ 天", value.str(@"loan_period.num")];
    }

    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc]init];
    [attStr2 appendAttributedString:[[NSString stringWithFormat:@"%@", value.str(@"invest_minimum")] moneyFormatZeroShow]];
    [attStr2 appendAttributedString:[[NSAttributedString alloc] initWithString:@" 元"]];
    self.lblimitMoney.attributedText = attStr2;

    if ([value[@"operate"] isEqualToString:@"已回款"] || [value[@"operate"] isEqualToString:@"已满标"]) {
        self.lbTitlemoney.text = @"项目总额";

        NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc]init];
        [attStr3 appendAttributedString:[[NSString stringWithFormat:@"%@", value.str(@"loan_amount")] moneyFormatZeroShow]];
        [attStr3 appendAttributedString:[[NSAttributedString alloc] initWithString:@" 元"]];
        self.lbpmoney.attributedText = attStr3;
    } else {
        self.lbTitlemoney.text = @"可投金额";
        NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc]init];
        [attStr3 appendAttributedString:[[NSString stringWithFormat:@"%@", value.str(@"invest_balance")] moneyFormatZeroShow]];
        [attStr3 appendAttributedString:[[NSAttributedString alloc] initWithString:@" 元"]];
        self.lbpmoney.attributedText = attStr3;
    }
}

@end
