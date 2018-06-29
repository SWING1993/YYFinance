//
//  NSString+time.m
//  hsd
//
//  Created by 杨旭冉 on 2017/11/2.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "NSString+time.h"

@implementation NSString (date)

/*
 
 *判断时间是否在指定时间段内
 
 * startTime 开始时间
 * expireTime 结束时间
 */
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDate *todayDate = [NSDate date];
    NSTimeZone *todayZone = [NSTimeZone systemTimeZone];
    NSInteger todayInterval = [todayZone secondsFromGMTForDate: todayDate];
    NSDate *today = [todayDate dateByAddingTimeInterval: todayInterval];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTime doubleValue]];
    NSTimeZone *startZone = [NSTimeZone systemTimeZone];
    NSInteger startInterval = [startZone secondsFromGMTForDate: startDate];
    NSDate *start = [startDate dateByAddingTimeInterval: startInterval];
    
    NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:[expireTime doubleValue]];
    NSTimeZone *expireZone = [NSTimeZone systemTimeZone];
    NSInteger expireInterval = [expireZone secondsFromGMTForDate: expireDate];
    NSDate *expire = [expireDate dateByAddingTimeInterval: expireInterval];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
