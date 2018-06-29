//
//  NSNumber+model.m
//  qtyd
//
//  Created by stephendsw on 2016/12/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "NSNumber+model.h"

@implementation NSNumber (model)

- (NSString *)moneyFormatData {
    return [NSString stringWithFormat:@"%.2f", [self doubleValue]];
}

- (NSString *)moneyFormatShow {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];

    [currencyFormatter setPositiveFormat:@"###,##0.00;"];
    return [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
}

/**
 * 格式化金额(xxx,xxx,xx),用于显示数据 小数点后字体小
 *
 */
- (NSAttributedString *)moneyFormatZeroShow {
    NSString                    *str = [self moneyFormatShow];
    NSMutableAttributedString   *attstr = [[NSMutableAttributedString alloc]initWithString:str];
    NSString                    *floatNum = [str substringFromIndex:[str rangeOfString:@"."].location];

    [attstr setFont:[UIFont systemFontOfSize:13] string:floatNum];
    return attstr;
}

@end
