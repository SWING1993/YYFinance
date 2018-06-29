//
//  NSDate+quick.m
//  qtyd
//
//  Created by stephendsw on 15/9/24.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "NSDate+quick.h"

@implementation NSDate (quick)

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSDateComponents *)components {
    NSDate              *now = self;
    NSCalendar          *cal = [NSCalendar currentCalendar];
    unsigned int        unitFlags = NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents    *dd = [cal components:unitFlags fromDate:now];

    return dd;
}

- (NSString *)longTimeString {
    return [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)shortTimeString {
    return [self stringWithFormat:@"yyyy-MM-dd"];
}

@end
