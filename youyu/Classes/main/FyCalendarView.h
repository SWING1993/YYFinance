//
//  FyCalendarView.h
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyCalendarView : UIView

// set 选择日期
@property (nonatomic, strong) NSDate    *date;
@property (nonatomic, strong) UIColor   *dateColor;
// 年月label
@property (nonatomic, strong) UILabel   *headlabel;
@property (nonatomic, strong) UIColor   *headColor;
// weekView
@property (nonatomic, strong) UIView    *weekBg;
@property (nonatomic, strong) UIColor   *weekDaysColor;

// 部分时段可用
@property (nonatomic, strong) NSArray   *partDaysArr;
@property (nonatomic, strong) UIColor   *partDaysColor;
@property (nonatomic, assign) CGFloat   *partDaysAlpha;
@property (nonatomic, strong) UIImage   *partDaysImage;

// 圆圈标记
@property (nonatomic, strong) NSArray   *partCircleDaysArr;
@property (nonatomic, strong) UIColor   *partCircleDaysColor;
@property (nonatomic, assign) CGFloat   *partCircleDaysAlpha;

// 是否只显示本月日期,默认->NO
@property (nonatomic, assign) BOOL isShowOnlyMonthDays;

// 创建日历
- (void)createCalendarViewWith:(NSDate *)date;

- (NSDate *)nextMonth:(NSDate *)date;

- (NSDate *)lastMonth:(NSDate *)date;

@property (nonatomic, copy) void (^nextMonthBlock)();
@property (nonatomic, copy) void (^lastMonthBlock)();

/**
 *  点击返回日期
 */
@property (nonatomic, copy) void (^calendarBlock)(NSDate *date);

@end
