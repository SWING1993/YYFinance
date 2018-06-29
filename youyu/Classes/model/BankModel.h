//
//  BankModel.h
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /**
     * 银行绑定
     */
    QTbankStateBank_bind = 1 << 0,

        /**
         *  开通快捷
         */
        QTbankStateQuick_bind = 1 << 1,

        /**
         *  网银支付
         */
        QTbankStateOnline_pay = 1 << 2,

        /**
         *  快捷支付
         */
        QTbankStateQuick_pay = 1 << 3,

        /**
         *  提现
         */
        QTbankStateCash_apply = 1 << 4
} QTbankState;

@interface BankModel : NSObject


+ (NSString *)getTipForCode:(NSDictionary *)bankInfo state:(QTbankState)state;
+ (NSString *)getTipFormateForCode:(NSDictionary *)bankInfo state:(QTbankState)state;

@end
