//
//  QTTicketCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTTicketCell.h"
#import "NSString+model.h"
#import  "QTTheme.h"
#import "UIViewController+page.h"

@interface QTTicketCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *title;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UILabel    *lbtime;
@property (weak, nonatomic) IBOutlet UILabel    *lbmoney;

@property (weak, nonatomic) IBOutlet UIButton   *btn;
@property (weak, nonatomic) IBOutlet UILabel    *lbtype;
@property (weak, nonatomic) IBOutlet UILabel    *lbCondition;
@property (weak, nonatomic) IBOutlet DWrapView *wrap;

@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@end

@implementation QTTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btn click:^(id value) {
        [self.viewController toInvest];
    }];
}

- (void)bind:(NSDictionary *)obj {
    self.lbtime.text = [NSString stringWithFormat:@"有效期至: %@", [obj.str(@"timeout") dateValue]];

    self.lbmoney.text = [NSString stringWithFormat:@"%@%%", obj.str(@"coupon")];

    self.lbtype.text = [NSString stringWithFormat:@"获得方式:%@", obj.str(@"coupon_name")];

    NSString        *is_use = obj.str(@"is_use");
    NSDate          *timeout = [NSDate dateWithTimeIntervalSince1970:[obj[@"timeout"] integerValue]];
    NSTimeInterval  offtime = [[NSDate systemDate] timeIntervalSinceDate:timeout];
    
    BOOL isGray = YES;

    if ([is_use isEqualToString:@"0"] && ([[obj[@"timeout"] stringValue] isEqualToString:@"0"] || (offtime <= 0))) { // 未使用
        [QTTheme btnRedStyle:self.btn];
        [self.btn setTitle:@"立即使用" forState:UIControlStateNormal];
        self.lbmoney.textColor = [UIColor whiteColor];
        self.image.image = [UIImage imageNamed:@"icon_annual-coupon_red"];
        self.btn.enabled = YES;
        isGray = NO;
    } else if ([is_use isEqualToString:@"0"] && (offtime > 0)) { // 已过期
        [QTTheme btnGrayStyle:self.btn];
        [self.btn setTitle:@"已过期" forState:UIControlStateDisabled];
        self.image.image = [UIImage imageNamed:@"icon_annual_coupon_gray"];
        self.lbmoney.textColor = Theme.grayColor;
        self.btn.enabled = NO;
        self.lbtime.text = @"过期时间: ".add([obj.str(@"timeout") dateValue]);
        isGray = YES;
    } else if ([is_use isEqualToString:@"1"]) {
        [QTTheme btnGrayStyle:self.btn];
        [self.btn setTitle:@"已使用" forState:UIControlStateDisabled];
        self.image.image = [UIImage imageNamed:@"icon_annual_coupon_gray"];
        self.lbmoney.textColor = Theme.grayColor;
        self.btn.enabled = NO;
        self.lbtime.text = @"使用时间: ".add([obj.str(@"usedtime") dateValue]);
        isGray = YES;
    } else if (obj.i(@"is_freeze") == 1) {
        [QTTheme btnGrayStyle:self.btn];
        self.lbmoney.textColor = [UIColor whiteColor];
        self.image.image = [UIImage imageNamed:@"icon_annual-coupon_red"];
        self.btn.enabled = YES;
        self.btn.enabled = NO;
        [self.btn setTitle:@"冻结" forState:UIControlStateDisabled];
        isGray = YES;
    }
    
    NSString *limitMoney;

    if (obj.i(@"money_limit") > 0) {
        limitMoney = [NSString stringWithFormat:@"投资≤%@万元", [[@(obj.fl(@"money_limit") / 10000)stringValue] moneyFormatShow]];
    } else {
        limitMoney = @"投资≥0.1万元";
    }

    NSString *limitDays;

    NSMutableAttributedString *attstr;
    if (obj.i(@"money_limit")!=0) {
        if (obj.i(@"borrow_days") > 0) {
            limitDays = [NSString stringWithFormat:@"标的期限≥%@天", obj.str(@"borrow_days")];
        } else {
            limitDays = @"标的期限:不限";
        }

        attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", limitMoney, limitDays]];
    }else{
        
        if (obj.i(@"borrow_days") > 0) {
            limitDays = [NSString stringWithFormat:@"标的期限≥%@天", obj.str(@"borrow_days")];
        } else {
            limitDays = @"标的期限:不限";
        }

        attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", limitDays]];
        
    }
    

    [attstr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 1;
    }];

    self.lbCondition.attributedText = attstr;
    
    NSMutableArray *borrow_limit = [[NSMutableArray alloc]initWithArray:[obj.str(@"borrow_limit") separatedByString:@","]];
    
    [self.wrap clearSubviews];
    if (obj[@"money_minimun_limit"] && [obj[@"money_minimun_limit"] integerValue] == 0) {
        self.minLabel.text = @"最低使用金额:不限";
    }else{
        self.minLabel.text = [NSString stringWithFormat:@"最低使用金额:%@万元",[[@(obj.fl(@"money_minimun_limit") / 10000)stringValue] moneyFormatShow]];
    }
    self.wrap.subHeight = 10;
    NSDictionary *typedic = @{
                                  @"0":@"全场通用",
                                  @"1":@"新手标",
                                  @"244":@"配资贷",
                                  @"245":@"票据贷",
                                  @"246":@"车抵贷",
                                  @"247":@"企业过桥",
                                  @"248":@"垫资贷",
                                  @"508":@"流资贷",
                                  @"509":@"活动体验标",
                                  @"827":@"房抵贷"
                                  };

    
    for (NSString *item in borrow_limit) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = typedic[item];
        
        if (isGray) {
            label.font = [UIFont systemFontOfSize:8];
            label.textColor = [Theme darkGrayColor];
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = [Theme darkGrayColor].CGColor;
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
        } else {
            label.font = [UIFont systemFontOfSize:8];
            label.textColor = [Theme darkOrangeColor];
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = [Theme darkOrangeColor].CGColor;
            label.layer.cornerRadius = 2;
            label.layer.masksToBounds = YES;
        }
        
        [label sizeToFit];
        label.width += 6;
        label.height += 4;
        [self.wrap addView:label padding:UIEdgeInsetsMake(2, 2, 2, 2)];
    }
}

- (void)bindSelect:(NSDictionary *)obj {
    self.lbtime.text = @"有效期至: ".add([obj.str(@"timeout") dateValue]);

    self.lbmoney.text = [NSString stringWithFormat:@"%@%%", obj[@"coupon"]];

    self.lbtype.text = @"";
    
    if (obj[@"money_minimun_limit"] && [obj[@"money_minimun_limit"] integerValue] == 0) {
        self.minLabel.text = @"最低使用金额:不限";
    }else{
        self.minLabel.text = [NSString stringWithFormat:@"最低使用金额:%@万元",[[@(obj.fl(@"money_minimun_limit") / 10000)stringValue] moneyFormatShow]];
    }
    self.wrap.hidden = YES;

    if ((obj.i(@"tender_money") == 0) || (self.money.floatValue <= obj.fl(@"tender_money"))) {
        self.image.image = [UIImage imageNamed:@"icon_annual-coupon_red"];
        self.lbmoney.textColor = [UIColor whiteColor];
    } else {
        self.image.image = [UIImage imageNamed:@"icon_annual_coupon_gray"];
        self.lbmoney.textColor = Theme.grayColor;
    }

    self.btn.hidden = YES;

    NSString *limitMoney;

    if (obj.i(@"tender_money") > 0) {
        limitMoney = [NSString stringWithFormat:@"投资≤%@万元", [[@(obj.fl(@"tender_money") / 10000)stringValue] moneyFormatShow]];
    } else {
        limitMoney = @"投资≥0.1万元";
    }
    if (obj.i(@"tender_money")!=0) {
        if(obj.i(@"borrow_days")!=0){
        self.lbCondition.text = [NSString stringWithFormat:@"%@ 标的期限≥%@", limitMoney,obj.str(@"borrow_days")];
        }else{
        self.lbCondition.text = [NSString stringWithFormat:@"%@ 标的期限:不限", limitMoney];

        }
    }else{
        if(obj.i(@"borrow_days")!=0){
            self.lbCondition.text =  [NSString stringWithFormat:@"投资:不限 标的期限≥%@天", obj.str(@"borrow_days")];

        }else{
           self.lbCondition.text =  [NSString stringWithFormat:@"投资:不限 标的期限:不限"];
        }
    }
}

@end
