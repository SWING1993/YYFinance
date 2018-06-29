//
//  QTProject.m
//  qtyd
//
//  Created by stephendsw on 15/8/5.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBorrowTenderLogCell.h"
#import "NSString+model.h"
#import "QTTheme.h"

@interface QTBorrowTenderLogCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbphone;

@property (weak, nonatomic) IBOutlet UILabel *lbmoney;

@property (weak, nonatomic) IBOutlet UILabel *lbtime;

@end

@implementation QTBorrowTenderLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    NSString *user = obj.str(@"user");

    CGFloat money = obj.fl(@"first_reward") + obj.fl(@"last_reward") + obj.fl(@"max_reward") + obj.fl(@"second_reward");

    NSString                    *text = user;
    NSMutableAttributedString   *attrStr = [[NSMutableAttributedString alloc]initWithString:text];

    if (obj.i(@"tender_resource") == 1) {
        [attrStr appendImageName:@"mobile_ico"];
    }

    if (money > 0) {
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];

        [attrStr appendImageName:@"icon_rmb_03"];

        NSMutableAttributedString *strMoney = [[NSMutableAttributedString alloc]initWithString:[[NSString stringWithFormat:@"%f元", money] moneyFormatShow]];
        [strMoney addAttribute:NSForegroundColorAttributeName value:Theme.redColor range:NSMakeRange(0, strMoney.string.length)];

        [attrStr appendAttributedString:strMoney];
    }

    self.lbphone.attributedText = attrStr;

    self.lbmoney.text = [obj.str(@"invest_amount") moneyFormatShow].add(@"元");
    self.lbtime.text = [obj.str(@"invest_time") timeValue];
}

@end
