//
//  BankDeailView.m
//  qtyd
//
//  Created by stephendsw on 15/8/18.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "BankDeailView.h"
#import "BankModel.h"
#import "QTTheme.h"

@interface BankDeailView ()
@property (weak, nonatomic) IBOutlet UIImageView    *bankImg;
@property (weak, nonatomic) IBOutlet UIImageView    *backgroundimg;

@property (weak, nonatomic) IBOutlet UILabel    *lbBankName;
@property (weak, nonatomic) IBOutlet UILabel    *lbBankNum;
@property (weak, nonatomic) IBOutlet UIButton   *btnGo;
@end

@implementation BankDeailView

- (void)setIsUpdate:(BOOL)isUpdate {
    _isUpdate = isUpdate;
    [self.btnGo setTitle:@"升级中" forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTopLine:Theme.borderColor];
    [self setBottomLine:Theme.borderColor];
    self.btnGo.enabled = NO;

    self.backgroundColor = [UIColor whiteColor];
}

- (void)reset {
    [self.btnGo setTitle:@"" forState:UIControlStateNormal];
    self.lbBankName.text = @"";
    self.lbBankNum.text = @"";
    self.bankImg.image = nil;
    self.backgroundimg.hidden = NO;
    [self.btnGo setImage:nil forState:UIControlStateNormal];
    self.isSelected = NO;
    self.isSafe = NO;
    self.backgroundColor = [UIColor whiteColor];
    [self.btnGo setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.btnGo setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)safeBind:(NSDictionary *)bankinfo {
    [self bind:bankinfo];
    self.isSafe = YES;
    [self.btnGo setTitle:@"安全卡" forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
    [self.btnGo setImage:[UIImage imageNamed:@"icon_suo"] forState:UIControlStateNormal];

    [self.btnGo setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.btnGo setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    self.backgroundColor = [UIColor colorHex:@"FFE7E7"];
}

- (void)bind:(NSDictionary *)bankinfo {
    self.backgroundColor = [UIColor whiteColor];
    self.isSelected = YES;
    self.userInteractionEnabled = YES;
    self.isSafe = NO;
    self.backgroundimg.hidden = YES;

    self.bankid = bankinfo[@"card_id"];

    self.bankcode = bankinfo.str(@"bank_detail.bank_code");
    self.lbBankName.text = bankinfo.str(@"bank_detail.bank_name");

    NSString *cardNum = bankinfo[@"account"];

    self.lbBankNum.text = @"尾号".add([cardNum stringByReplacingCharactersInRange:NSMakeRange(0, cardNum.length - 4) withString:@""]);

    NSString *imgname = @[@"icon_", bankinfo.str(@"bank_detail.bank_code"), @"_bank"].joinedString;
    self.bankImg.image = [UIImage imageNamed:imgname];

    [self.btnGo setTitle:@"快捷卡" forState:UIControlStateNormal];
    self.isValidte = YES;

    [self.btnGo setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [self.btnGo setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [self.btnGo setImage:[UIImage imageNamed:@"icon-arrows-"] forState:UIControlStateNormal];
}

@end
