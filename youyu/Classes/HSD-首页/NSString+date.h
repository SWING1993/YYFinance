//
//  NSString+time.h
//  hsd
//
//  Created by 杨旭冉 on 2017/11/2.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (date)

/*
 
 *判断时间是否在指定时间段内
 
 * startTime 开始时间
 * expireTime 结束时间
 */
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;

@end
