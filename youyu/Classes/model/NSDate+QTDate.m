//
//  NSDate+QTDate.m
//  qtyd
//
//  Created by stephendsw on 16/7/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "NSDate+QTDate.h"
#import "SystemConfigDefaults.h"

@implementation NSDate (QTDate)

+ (NSDate *)systemDate {
    return [SystemConfigDefaults sharedInstance].server_time.dateTypeValue;
}

@end
