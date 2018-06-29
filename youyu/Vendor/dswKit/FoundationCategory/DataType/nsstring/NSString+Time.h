//
//  NSString+Time.h
//  qtyd
//
//  Created by stephendsw on 15/11/12.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

/**
 *  获取 yyyy-MM-dd
 */
@property (nonatomic, readonly) NSString *dateValue;

/**
 *  获取 yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, readonly) NSString *timeValue;

/**
 *  获取年
 */
@property (nonatomic, readonly) NSString *yearValue;

/**
 *  获取月
 */
@property (nonatomic, readonly) NSString *monthValue;

/**
 *  获取日
 */
@property (nonatomic, readonly) NSString *dayValue;

/**
 *  获取小时
 */
@property (nonatomic, readonly) NSString *hourValue;

/**
 *  获取分
 */
@property (nonatomic, readonly) NSString *minuteValue;

/**
 *  获取秒
 */
@property (nonatomic, readonly) NSString *secondValue;

/**
 *  获取NSDate 值
 */
@property (nonatomic, readonly) NSDate *dateTypeValue;

/**
 *  获取时间戳
 */
@property (nonatomic, readonly) NSTimeInterval timeIntervalValue;

/**
 *  日期 转 string
 */
+ (NSString *)stringFromDate:(NSDate *)date Format:(NSString *)Format;

/**
 *  日期转格式
 */
- (NSString *)stringWithDateFormat:(NSString *)format;

@end
