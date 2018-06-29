//
//  QTUser_rewardinfoCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTUser_rewardinfoCellQuan.h"
#import "QTTheme.h"
#import "NSString+model.h"
#import "UIViewController+page.h"

@interface QTUser_rewardinfoCellQuan ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UILabel    *lbNum;
@property (weak, nonatomic) IBOutlet UILabel    *lbmoney;

@property (weak, nonatomic) IBOutlet UIButton       *btn;
@property (weak, nonatomic) IBOutlet UIImageView    *backimage;

@property (weak, nonatomic) IBOutlet UIView         *view;
@property (weak, nonatomic) IBOutlet DWrapView      *warp;
@property (weak, nonatomic) IBOutlet UIImageView    *imageQuestion;
@property (weak, nonatomic) IBOutlet UIView         *tapView;

@end

@implementation QTUser_rewardinfoCellQuan

- (void)awakeFromNib {
    [super awakeFromNib];
    [QTTheme btnRedStyle:self.btn];
    self.backgroundColor = Theme.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = Theme.backgroundColor;
    self.view.backgroundColor = Theme.backgroundColor;

    [self.btn click:^(id value) {
        [self.viewController toInvest];
    }];

    self.subtitle.numberOfLines = 0;
    self.lbNum.textColor = Theme.grayColor;
}

- (void)bind:(NSDictionary *)obj {
    self.title.text = obj.str(@"reward_name");

    NSMutableAttributedString *moneyAttstr = [[NSMutableAttributedString alloc]initWithString:[obj.str(@"money") moneyFormatShow]];

    [moneyAttstr setFont:[UIFont systemFontOfSize:22] string:@".00"];
    self.lbmoney.attributedText = moneyAttstr;
    self.lbNum.text = obj.str(@"reward_no");

    NSInteger       is_use = obj.i(@"is_use");
    NSDate          *timeout = [NSDate dateWithTimeIntervalSince1970:[obj[@"timeout"] integerValue]];
    NSTimeInterval  offtime = [[NSDate systemDate] timeIntervalSinceDate:timeout];

    BOOL isGray = YES;

    if ((is_use == 0) && ([[obj[@"timeout"] stringValue] isEqualToString:@"0"] || (offtime <= 0))) {
        // 未使用

        [self setStyle:0];
        isGray = NO;
    }
    if ((is_use == 0) && (offtime > 0)) {
        // 已过期
        [self setStyle:1];
        isGray = YES;
    }
    if (is_use == 1) {
        // 已使用
        [self setStyle:2];
        isGray = YES;
    }
    if (obj.i(@"is_freeze") == 1) {
        [self setStyle:3];
        isGray = YES;
    }

    if (isGray && [obj.str(@"reward_name") containsString:@"合并红包券"]) {
        self.imageQuestion.image = [UIImage imageNamed:@"icon_gray_question"];
    } else if (!isGray && [obj.str(@"reward_name") containsString:@"合并红包券"]) {
        self.imageQuestion.image = [UIImage imageNamed:@"icon_red_question"];
    } else {
        self.imageQuestion.image = [UIImage new];
    }

    NSMutableString *subtitleAttr = [NSMutableString new];

    if ([obj.str(@"timeout") isEqualToString:@"0"]) {
        [subtitleAttr appendFormat:@"有效期: 无限期"];
    } else {
        [subtitleAttr appendFormat:@"有效期:%@至%@", obj.str(@"addtime").dateValue, obj.str(@"timeout").dateValue];
    }

    [subtitleAttr appendFormat:@"\n投资≥%@元", obj.str(@"money_limit")];

    if (obj.i(@"borrow_days") > 0) {
        [subtitleAttr appendFormat:@" 标的期限≥%@天", obj.str(@"borrow_days")];
    } else {
        [subtitleAttr appendFormat:@" 标的期限:不限"];
    }

    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:subtitleAttr];
    [attstr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 6;
    }];

    self.subtitle.attributedText = attstr;

    NSArray *special_borrow_id_list = [obj.str(@"special_borrow_id") separatedByString:@";"];

    if (![special_borrow_id_list containsObject:@"0"] && (special_borrow_id_list.count > 0)) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = obj.str(@"special_remark");
        [label sizeToFit];
        label.width += 4;

        if (isGray) {
            [QTTheme lbStyle4:label];
        } else {
            [QTTheme lbStyle2:label];
        }

        [self.warp addView:label];
    } else {
        NSDictionary *typedic = @{
            @"0":@"全场通用",
            @"1":@"新手标",
            @"246":@"车抵贷",
            @"508":@"流资贷",
            @"245":@"票据贷",
            @"827":@"房抵贷"
        };

        NSMutableArray *borrow_limit = [[NSMutableArray alloc]initWithArray:[obj.str(@"borrow_limit") separatedByString:@";"]];

        if ([borrow_limit containsObject:@"0"] && (obj.i(@"newhand_limit") == 0)) {
            // 全场通用（新手标除外）
            [borrow_limit removeObject:@"0"];
            [borrow_limit addObjectsFromArray:@[@"508",@"827"]];
        } else if ([borrow_limit containsObject:@"0"] && (obj.i(@"newhand_limit") == 1)) {
            // 全场通用
            borrow_limit = [[NSMutableArray alloc]initWithObjects:@"0", nil];
        } else {
            // 指定标
            if (obj.i(@"newhand_limit") == 1) {
                [borrow_limit addObject:@"1"];
            }
        }

        [self.warp clearSubviews];
        self.warp.subHeight = 10;

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
            [self.warp addView:label padding:UIEdgeInsetsMake(0, 2, 2, 2)];
        }
    }
}

- (void)setStyle:(NSInteger)type {
    if (type == 0) {
        // 未使用
        [QTTheme btnRedStyle:self.btn];
        [self.btn setTitle:@"立即使用" forState:UIControlStateNormal];
        self.backimage.image = [UIImage imageNamed:@"bg_ios_hongbaoquan_hongse"];
        self.title.textColor = [Theme redColor];
        self.lbmoney.textColor = Theme.darkOrangeColor;
        self.subtitle.textColor = [UIColor colorHex:@"808080"];
    } else if (type == 1) {
        // 已过期
        [QTTheme btnGrayStyle:self.btn];
        [self.btn setTitle:@"已过期" forState:UIControlStateDisabled];
        self.title.textColor = [UIColor colorHex:@"999999"];
        self.lbmoney.textColor = [UIColor colorHex:@"b2b2b2"];
        self.backimage.image = [UIImage imageNamed:@"bg_ios_hongbaoquan_huisese"];
        self.subtitle.textColor = [UIColor colorHex:@"999999"];
    } else if (type == 2) {
        // 已使用
        [QTTheme btnLightGreenStyle:self.btn];
        [self.btn setTitle:@"已使用" forState:UIControlStateDisabled];
        self.backimage.image = [UIImage imageNamed:@"bg_ios_hongbaoquan_lvse"];
        self.title.textColor = [UIColor colorHex:@"999999"];
        self.subtitle.textColor = [UIColor colorHex:@"999999"];
        self.lbmoney.textColor = [Theme lightGreenColor];
    } else if (type == 3) {
        // 冻结
        [QTTheme btnGrayStyle:self.btn];
        [self.btn setTitle:@"冻结" forState:UIControlStateDisabled];
        self.backimage.image = [UIImage imageNamed:@"bg_ios_hongbaoquan_hongse"];
        self.title.textColor = [Theme redColor];
        self.lbmoney.textColor = Theme.darkOrangeColor;
        self.subtitle.textColor = [UIColor colorHex:@"808080"];
    }

    self.btn.titleLabel.font = [UIFont systemFontOfSize:12];

    self.btn.layer.cornerRadius = self.btn.height / 2;
}

- (void)setSelectStyle {
    self.btn.backgroundColor = [UIColor colorHex:@"8fc320"];
    self.btn.enabled = NO;
    [self.btn setImage:[UIImage imageNamed:@"icon_select_reward"] forState:UIControlStateDisabled];
    [self.btn setTitle:@"" forState:UIControlStateDisabled];
}

- (void)setUnselectStyle {
    self.btn.backgroundColor = [UIColor colorHex:@"cccccc"];
    self.btn.enabled = NO;
    [self.btn setImage:[UIImage imageNamed:@"icon_select_reward"] forState:UIControlStateDisabled];
    [self.btn setTitle:@"" forState:UIControlStateDisabled];
}

- (void)setMergeStyle {
    [QTTheme btnRedStyle:self.btn];
    [self.btn setTitle:@"已合并" forState:UIControlStateNormal];
    self.btn.userInteractionEnabled = NO;
}

- (void)setInvestStyle {
    [self.btn setTitle:@"立即投资" forState:UIControlStateNormal];
    self.imageQuestion.image = [UIImage new];
    self.btn.userInteractionEnabled = NO;
}

- (void)setTap {
    [self.tapView addTapGesture:^{
        [self.viewController toInvest];
    }];
    self.tapView.userInteractionEnabled = self.btn.enabled;
}

@end
