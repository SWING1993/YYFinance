//
//  QTExpressModel.m
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTExpressModel.h"

@implementation QTExpressModel

+ (NSDictionary *)getExpressDic {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"圆通快递", @"1",
                         @"申通快递", @"2",
                         @"韵达快递", @"3",
                         @"中通快递", @"4",
                         @"顺丰快递", @"5",
                         @"天天快递", @"6",
                         @"EMS", @"7",
                         @"全峰快递", @"8",
                         @"汇通", @"9",
                         @"E邮宝", @"10",
                         @"UPS", @"11",
                         @"宅急送", @"12",
                         @"邮政包裹", @"13", nil];
    
    return dic;
}

+ (NSString *)getName:(NSInteger)num {
    NSArray *list = @[@"圆通快递",
    @"申通快递",
    @"韵达快递",
    @"中通快递",
    @"顺丰快递",
    @"天天快递",
    @"EMS",
    @"全峰快递",
    @"汇通",
    @"E邮宝",
    @"UPS",
    @"宅急送",
    @"邮政包裹"];

    if (num > list.count) {
        return @"";
    }

    return list[num - 1];
}

+ (NSString *)getType:(NSInteger)num {
    NSArray *list = @[
        @"yuantong",
        @"shentong",
        @"yunda",
        @"zhongtong",
        @"shunfeng",
        @"tiantian",
        @"ems",
        @"quanfengkuaidi",
        @"huitongkuaidi",
        @"ems",
        @"ups",
        @"zhaijisong",
        @"youzhengguonei"];

    if (num > list.count) {
        return @"";
    }

    return list[num - 1];
}

@end
