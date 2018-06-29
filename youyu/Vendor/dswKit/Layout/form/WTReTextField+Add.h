//
//  WTReTextField+Add.h
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "WTReTextField.h"

@interface WTReTextField (Add)

- (void)setPhone;

- (void)setPwd;

- (void)setValidationCode;

- (void)setEmail;

- (void)setNickName;

- (void)setRealName;

- (void)setIDCard;

- (void)setMoney;

/**
 *  正整数
 *
 *  @param length 数字长度
 */
- (void)setPositiveInteger:(NSInteger)length;

- (void)setBankCard;

@end
