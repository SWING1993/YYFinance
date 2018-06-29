//
//  WTReTextField+Add.m
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "WTReTextField+Add.h"
#import "NSString+regularExpression.h"
#import "AppUtil.h"

@implementation WTReTextField (Add)

- (void)setPhone {
    self.isNeed = YES;
    self.pattern = kRegPhone;
    self.errorTip = @"手机号码格式错误";
    self.nilTip = @"请输入手机号码";

    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setPwd {
    self.isNeed = YES;
    self.pattern = kRegPassword;
    self.errorTip = @"密码应为6-24位字符";
    self.nilTip = @"请输入密码";
    self.keyboardType = UIKeyboardTypeASCIICapable;
    [self setSecureTextEntry:YES];
}

- (void)setValidationCode {
    self.isNeed = YES;
    self.pattern = kRegValidCode;
    self.errorTip = @"验证码格式错误(6位纯数字)";
    self.nilTip = @"请输入手机验证码";
    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setEmail {
    self.isNeed = YES;
    self.pattern = kBandEmail;
    self.errorTip = @"邮箱格式错误,请重新输入";
    self.nilTip = @"请输入邮箱";
    self.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)setNickName {
    self.isNeed = YES;

    self.errorTip = @"昵称应为4-18位中英文字符或数字";
    self.nilTip = @"请输入昵称";
}

- (void)setRealName {
    self.isNeed = YES;
    self.pattern = kUserName;
    self.errorTip = @"真实姓名格式错误";
    self.nilTip = @"请输入真实姓名";
}

- (void)setIDCard {
    self.isNeed = YES;
    self.pattern = kRegIDCard;
    self.errorTip = @"身份证号格式错误";
    self.nilTip = @"请输入身份证号码";
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

- (void)setMoney {
    self.isNeed = YES;
    self.pattern = kMoney;
    self.errorTip = @"金额必须为数字，小数点后不超过2位";
    self.nilTip = @"请输入金额";
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setPositiveInteger:(NSInteger)length {
    self.isNeed = YES;

    if (length > 0) {
        self.pattern = [NSString stringWithFormat:kPositiveInteger, [NSString stringWithFormat:@"%lu", (long)length]];
    } else {
        self.pattern = [NSString stringWithFormat:kPositiveInteger, @""];
    }

    self.errorTip = @"必须为大于0的整数";
    self.nilTip = @"请输入整数";
    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setBankCard {
    self.isNeed = YES;
    self.pattern = kBankCard;
    self.errorTip = @"银行卡号格式错误(15-19位纯数字)";
    self.nilTip = @"请输入银行卡号";
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

@end
