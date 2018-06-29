//
//  NSString+money.m
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "NSString+model.h"
#import "GVUserDefaults.h"
#import "GVUserDefaults.h"

@implementation NSString (model)

- (NSString *)realNameFormat {
    NSString *temp;

    if (self.length >= 2) {
        temp = [self stringByReplacingCharactersInRange:NSMakeRange(1, self.length - 1) withString:@""];
        NSInteger len = self.length - 1;

        for (NSInteger i = 0; i < len; i++) {
            temp = temp.add(@"*");
        }
    } else {
        temp = self;
    }

    return temp;
}

- (NSString *)phoneFormat {
    NSString *temp = self;

    if (temp.length == 11) {
        temp = [temp stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }

    return temp;
}

- (NSString *)moneyFormatShow {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];

    [currencyFormatter setPositiveFormat:@"###,##0.00;"];
    return [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
}

- (NSString *)moneyFormatShowWithInt{

    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    
    [currencyFormatter setPositiveFormat:@"###,##0;"];
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

    [attstr setFont:[UIFont systemFontOfSize:12] string:floatNum];
    return attstr;
}

- (NSString *)moneyFormatData {
    return [NSString stringWithFormat:@"%.2f", [self doubleValue]];
}

- (NSString*)moneyFormatDataWithIntegerValue{
  
    return [NSString stringWithFormat:@"%ld", [self integerValue]];
    
}

- (NSString *)enValue {
    NSString *_key;

    if ([GVUserDefaults shareInstance].isLogin) {
        _key = [GVUserDefaults shareInstance].des_key;
    } else {
        _key = deskey;
    }

    return [self desEncryptkey:_key];
}

- (NSString *)dnValue {
    if (self.length == 0) {
        return @"";
    }
    NSString *_key;
    if ([GVUserDefaults shareInstance].isLogin) {
        _key = [GVUserDefaults shareInstance].des_key;
    } else {
        _key = deskey;
    }
    return [self desDecryptkey:_key];
}

+ (NSString *)safeRank {
    NSInteger speed = 0;

    GVUserDefaults *data = [GVUserDefaults shareInstance];

    if (data.real_status == 1) {
        speed += 1;
    }

    if (data.phone_status) {
        speed += 1;
    }

    if ([[GVUserDefaults shareInstance] isSetPayPassword]) {
        speed += 1;
    }

    if ([data.email_status isEqualToString:@"1"]) {
        speed += 1;
    }

    if (data.nick_name) {
        speed += 1;
    }

    if ([data.address_exists isEqualToString:@"1"]) {
        speed += 1;
    }

    if (speed <= 3) {
        return @"低";
    } else if (speed <= 5) {
        return @"中";
    } else {
        return @"高";
    }
}

+ (NSString *)tenderType:(NSDictionary *)obj {
    NSString *operate;

    if ([obj[@"operate"] isKindOfClass:[NSDictionary class]]) {
        operate = obj.str(@"operate.name");
    } else {
        operate = obj.str(@"operate");
    }

    // 已满标
    if ([operate isEqualToString:@"已满标"]) {
        return @"icon_ausgebucht_invest";
    }

    // 预告标
    if (obj[@"publish_time"]) {
        NSString                *stime = obj.str(@"publish_time");
        NSDate                  *publish_time = [NSDate dateWithTimeIntervalSince1970:[stime integerValue]];
        __block NSTimeInterval  offtime = [[NSDate systemDate] timeIntervalSinceDate:publish_time];

        if (offtime < 0) {
            return @"icon_foreshow_invest";
        }
    }

    // 新手标
    if (obj.i(@"new_hand") == 2) {
        return @"icon_new_invest";
    } else if (obj.i(@"new_hand") == 1) {
         return @"icon_voppp";
    }
    return nil;
}

- (NSString *)firstBorrowNameNoFormat {
    NSString *temp = [self firstBorrowName];
    temp = [temp stringByReplacingOccurrencesOfString:@"【" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"】" withString:@""];
    return temp;
}

- (NSString *)firstBorrowName {
    NSRange range = [self rangeOfString:@"】"];
    if (range.location != NSNotFound) {
        return [self substringToIndex:range.length + range.location];
    } else {
        return @"";
    }
}

- (NSString *)lastBorrowName {
    return self.removeRange(@"【", @"】");
}

- (NSString *)hideValue:(NSInteger)start end:(NSInteger)end {
    if ((self == nil) || (self.length == 0)) {
        return @"";
    }

    NSString *str = [self substringToIndex:start];
    NSInteger i = end;
    NSInteger length = self.length;

    if (start + end > length) {
        i = i - 1;
    }
    while (i > 0) {
        str = [NSString stringWithFormat:@"%@%@", str, @"*"];
        i = i - 1;
    }
    @try {
        NSInteger   loc = start + end;
        NSInteger   len = length - loc;
        NSRange     range = NSMakeRange(loc, len <= 0 ? 1 : len);
        return [NSString stringWithFormat:@"%@%@", str, [self substringWithRange:range]];
    } @catch(NSException *exception) {
        return @"";
    }
}

/**
 *  秒戳转时间
 *
 */
- (NSString *)secondToTimeFormat {
    NSInteger secCount = [self integerValue];
    NSString *tmphh = [NSString stringWithFormat:@"%ld", secCount / 3600];
    if ([tmphh length] == 1) {
        tmphh = [NSString stringWithFormat:@"0%@", tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%ld", (secCount / 60) % 60];
    if ([tmpmm length] == 1) {
        tmpmm = [NSString stringWithFormat:@"0%@", tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%ld", secCount % 60];
    if ([tmpss length] == 1) {
        tmpss = [NSString stringWithFormat:@"0%@", tmpss];
    }
    NSString *str = [NSString stringWithFormat:@"%@:%@:%@", tmphh, tmpmm, tmpss];
    return str;
}

/**
 *  秒戳转时间
 *
 */
- (NSString *)secondToTimeFormatChinese {
    NSInteger offtime = [self integerValue];
    NSInteger d = offtime / (24 * 3600);
    offtime = offtime - d * ((24 * 3600));
    NSInteger h = offtime / 3600;
    NSInteger m = (offtime - h * 3600) / 60;
    NSInteger s = offtime - h * 3600 - m * 60;
    NSString *text = [NSString stringWithFormat:@"%ld天%ld小时%ld分%ld秒", (long)d, (long)h, (long)m, (long)s];
    return text;
}

@end
