//
//  NSDate+RMCalendarLogic.h
//  RMCalendar
//
//  Created by  on 15/7/15.
//  Copyright © 2015年  ( ) All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RMCalendarLogic)

#pragma mark - 获取特殊日期

/**
 *  计算这个月有多少天
 *
 */
- (NSUInteger)numberOfDaysInCurrentMonth;

/**
 *  获取这个月有多少周
 *
 */
- (NSUInteger)numberOfWeeksInCurrentMonth;

/**
 *  计算这个月的第一天是礼拜几
 *
 */
- (NSUInteger)weeklyOrdinality;

/**
 *  计算这个月最开始的一天
 *
 */
- (NSDate *)firstDayOfCurrentMonth;

/**
 *   计算这个月最后的一天
 *
 */
- (NSDate *)lastDayOfCurrentMonth;

/**
 *  上一个月
 *
 */
- (NSDate *)dayInThePreviousMonth;

/**
 *  下一个月
 *
 */
- (NSDate *)dayInTheFollowingMonth;

/**
 *  获取当前日期之后的几个月
 */
- (NSDate *)dayInTheFollowingMonth:(int)month;

/**
 *  获取当前日期之后的几个天
 */
- (NSDate *)dayInTheFollowingDay:(int)day;

#pragma mark 转化

/**
 *
 *
 */
- (NSDateComponents *)YMDComponents;

/**
 *  NSString转NSDate
 *
 */
- (NSDate *)dateFromString:(NSString *)dateString;// NSString转NSDate

/**
 *  NSDate转NSString
 *
 */
- (NSString *)stringFromDate:(NSDate *)date;

/**
 *
 *
 */
+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

/**
 *  日期相减
 *
 */
+ (NSInteger)numberOfDays:(NSDate *)date1 reduce:(NSDate *)date2;

#pragma mark week

/**
 *  获取星期几数字
 *
 */
- (int)getWeekIntValueWithDate;

/**
 * 判断日期是今天,明天,后天,周几
 */
- (NSString *)compareIfTodayWithDate;

/**
 *  通过数字返回星期几
 */
+ (NSString *)getWeekStringFromInteger:(int)week;

@end
