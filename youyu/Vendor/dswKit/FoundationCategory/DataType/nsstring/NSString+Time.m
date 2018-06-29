//
//  NSString+Time.m
//  qtyd
//
//  Created by stephendsw on 15/11/12.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "NSString+Time.h"
#import "NSString+regularExpression.h"
#import "NSDate+quick.h"
#import "NSDateFormatter+quick.h"

@implementation NSString (Time)

- (NSDateComponents *)toNSDateComponents {
    NSDate              *now = self.dateTypeValue;
    NSCalendar          *cal = [NSCalendar currentCalendar];
    unsigned int        unitFlags = NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents    *dd = [cal components:unitFlags fromDate:now];

    return dd;
}

+ (NSString *)stringFromDate:(NSDate *)date Format:(NSString *)Format {
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance];

    formatter.dateFormat = Format;
    return [formatter stringFromDate:date];
}

- (NSString *)stringWithDateFormat:(NSString *)format {
    return [self.dateTypeValue stringWithFormat:format];
}

- (NSString *)dateValue {
    return [self.dateTypeValue stringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)timeValue {
    return [self.dateTypeValue stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)yearValue {
    return [NSString stringWithFormat:@"%li", (long)[self toNSDateComponents].year];
}

- (NSString *)monthValue {
    return [NSString stringWithFormat:@"%li", (long)[self toNSDateComponents].month];
}

- (NSString *)dayValue {
    return [NSString stringWithFormat:@"%li", (long)[self toNSDateComponents].day];
}

- (NSString *)hourValue {
    return [NSString stringWithFormat:@"%li", (long)[self toNSDateComponents].hour];
}

- (NSString *)minuteValue {
    return [NSString stringWithFormat:@"%li", (long)[self toNSDateComponents].minute];
}

- (NSString *)secondValue {
    return [NSString stringWithFormat:@"%li", (long)[self toNSDateComponents].second];
}

- (NSTimeInterval)timeIntervalValue {
    NSDate *date = self.dateTypeValue;

    if (date) {
        return date.timeIntervalSince1970;
    } else {
        return 0;
    }
}

- (NSDate *)dateTypeValue {
    // 时间戳转nsdate

    if ([self isMatch:kRegNumber]) {
        return [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    }
    // 时间转nsdate
    else {
        NSDateFormatter *formatter = [NSDateFormatter sharedInstance];

        NSDate  *date;
        NSArray *formatList = @[@"yyyy-MM-dd HH:mm:ss", @"yyyy-MM-dd", @"yyyy-MM"];

        for (int i = 0; i < formatList.count; i++) {
            [formatter setDateFormat:formatList[i]];
            date = [formatter dateFromString:self];

            if (date) {
                return date;
            }
        }

        return nil;
    }
}

@end
