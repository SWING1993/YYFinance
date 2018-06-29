//
//  RMCalendarLogic.h
//  RMCalendar
//
//  Created by   on 15/7/15.
//  Copyright © 2015年  ( ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMCalendarModel.h"

/**
 *  日历显示的月数
 */
typedef NS_ENUM(NSInteger, CalendarShowType){
    /**
     *  只显示当月
     */
    CalendarShowTypeSingle,
    /**
     *  显示多个月数
     */
    CalendarShowTypeMultiple
};

@interface RMCalendarLogic : NSObject

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable priceModelArr:(NSArray *)arr;

- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type priceModelArr:(NSArray *)arr;


- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type;
- (void)selectLogic:(RMCalendarModel *)dayModel;

@end
