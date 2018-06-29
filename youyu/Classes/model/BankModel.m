//
//  BankModel.m
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "BankModel.h"
#import <UIKit/UIKit.h>
#import "GVUserDefaults.h"
#import "SystemConfigDefaults.h"

static NSArray *arrayNum;

static NSArray *bankName;

@implementation BankModel

+ (NSString *)getTipForCode:(NSDictionary *)bankInfo state:(QTbankState)state;
{
    NSString *str = [self getTipFormateForCode:bankInfo state:state];

    if (str) {
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }

    return str;
}

+ (NSString *)getTipFormateForCode:(NSDictionary *)bankInfo state:(QTbankState)state {
    // 维护中
    NSString *date = [[NSDate dateWithTimeIntervalSince1970:[SystemConfigDefaults  sharedInstance].server_time.integerValue] stringWithFormat:@"yyyy-MM-dd HH:mm"];

    BOOL        hasView = NO;
    NSString    *tempState = bankInfo.str(@"bank_channel");

    if (state & QTbankStateBank_bind) {
        if ([tempState containsString:@"bank_bind"]) {
            hasView = YES;
        }
    }

    if (state & QTbankStateCash_apply) {
        if ([tempState containsString:@"cash_apply"]) {
            hasView = YES;
        }
    }

    if (state & QTbankStateOnline_pay) {
        if ([tempState containsString:@"online_pay"]) {
            hasView = YES;
        }
    }

    if (state & QTbankStateQuick_bind) {
        if ([tempState containsString:@"quick_bind"]) {
            hasView = YES;
        }
    }

    if (state & QTbankStateQuick_pay) {
        if ([tempState containsString:@"quick_pay"]) {
            hasView = YES;
        }
    }

    NSString    *text;
    NSString    *sql;

    // 待定
    sql = [NSString stringWithFormat:@" self> '%@'", bankInfo.str(@"update_start_time")];

    if ([bankInfo.str(@"undetermined") isEqualToString:@"1"] && hasView && [date compareExpression:sql]) {
        return bankInfo.str(@"description");
    }

    // 升级
    sql = [NSString stringWithFormat:@" self <'%@' && self> '%@'", bankInfo.str(@"update_end_time"), bankInfo.str(@"update_start_time")];

    if (hasView && [date compareExpression:sql]) {
        text = [NSString stringWithFormat:@"通知:%@于\n%@至%@\n进行系统升级，请稍后再试！", bankInfo.str(@"bank_name"), bankInfo.str(@"update_start_time"), bankInfo.str(@"update_end_time")];
        return text;
    }

    return nil;
}

@end
