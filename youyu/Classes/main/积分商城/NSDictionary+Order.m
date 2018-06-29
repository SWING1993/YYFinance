//
//  QTOrderModel.m
//  qtyd
//
//  Created by stephendsw on 16/4/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "NSDictionary+Order.h"

@implementation NSDictionary (Order)

- (NSInteger)getCanBuyNum {
    NSInteger result = 100000;

    /**
     *  已兑换
     */
    NSInteger exchange_count = self.i(@"user_exchanged_count");

    /**
     *  兑换限制
     */
    NSInteger exchange_limit = self.i(@"good_info.exchange_limit");

    if (exchange_limit != 0) {
        result = exchange_limit - exchange_count;
    }

    /**
     *  库存
     */
    NSInteger inventory = self.i(@"good_info.inventory");

    if (result > inventory) {
        result = inventory;
    }
    

    /**
     *  用户能兑换
     */
    NSInteger userCanExchange = self.i(@"user_point") / self.i(@"good_info.need_point");

    if (result > userCanExchange) {
        result = userCanExchange;
    }

    return result;
}

@end
