//
//  QTBankCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBankCell.h"
#import "BankModel.h"
#import "QTTheme.h"
#import "BankModel.h"
#import "GVUserDefaults.h"


@interface QTBankCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel    *lbBankName;
@property (weak, nonatomic) IBOutlet UILabel    *lbBankNum;

@property (weak, nonatomic) IBOutlet UILabel *lbVerified;

@end

@implementation QTBankCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    NSString *cardNum = obj[@"account"];

    self.lbBankNum.text = @"尾号".add([cardNum stringByReplacingCharactersInRange:NSMakeRange(0, cardNum.length - 4) withString:@""]);

    if ([obj[@"is_verified"] isEqualToString:@"N"]) {
        self.lbVerified.text = @" 开通快捷支付 ";
        self.lbVerified.backgroundColor = Theme.redColor;
        self.is_verified = NO;

        [self.lbVerified addTapGesture:^{
            [self.bankdelegate BankVerified:obj[@"card_id"]];
        }];

        [QTTheme lbStyle3:self.lbVerified];
    } else {
        self.lbVerified.text = @"快捷卡";
        self.is_verified = YES;
        [self.lbVerified addTapGesture:^{
           
        }];
        [QTTheme lbStyle1:self.lbVerified];
    }

    if ([obj.str(@"safe_card") isEqualToString:@"Y"]) {
        self.lbVerified.text = @"安全卡";
        [self.lbVerified addTapGesture:^{
            
        }];
    }

    NSString *imgname = @"icon_".add(obj[@"bank_code"]).add(@"_bank");
    self.image.image = [UIImage imageNamed:imgname];

    self.lbBankName.text = self.lbBankName.text = obj.str(@"bank_detail.bank_name");

    // 维护中
    NSString *text = [BankModel getTipFormateForCode:obj.dic(@"bank_detail") state:QTbankStateQuick_bind];

    if (text) {
        self.lbVerified.text = @"升级中";
        self.lbVerified.backgroundColor = Theme.redColor;
        self.isUpdate = YES;
        [QTTheme lbStyle3:self.lbVerified];
        [self.lbVerified addTapGesture:^{
            [self.bankdelegate BankUpdate:text];
        }];
    } else {
        self.isUpdate = NO;
    }
}

@end
