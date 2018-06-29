//
//  NSString+money.h
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+quick.h"

@interface NSString (model)

#pragma mark - 金额

/**
 *  格式化金额(xxx,xxx,xx),用于显示数据
 */
- (NSString *)moneyFormatShow;

- (NSString *)moneyFormatShowWithInt;

/**
 *  格式化金额，保留2位小数，用于计算数据
 */
- (NSString *)moneyFormatData;

// 金额取整

- (NSString*)moneyFormatDataWithIntegerValue;

/**
 * 格式化金额(xxx,xxx,xx),用于显示数据 小数点后字体小
 *
 */
-(NSAttributedString *)moneyFormatZeroShow;

#pragma mark - 时间

/**
 *  秒戳转时间
 *
 */
- (NSString *)secondToTimeFormat;

/**
 *  秒戳转时间
 *
 */
-(NSString *)secondToTimeFormatChinese;

#pragma mark - 加密

/**
 *  加密
 *
 */
- (NSString *)enValue;

/**
 *  解密
 *
 */
- (NSString *)dnValue;

#pragma mark - 标

/**
 *  标期名 无【】
 *
 */
- (NSString *)firstBorrowNameNoFormat;

/**
 *  标期名 有【】
 *
 */
- (NSString *)firstBorrowName;

/**
 *  标名
 *
 */
- (NSString *)lastBorrowName;

/**
 *  标类别
 *
 */
+ (NSString *)tenderType:(NSDictionary *)dic;

#pragma mark - 其他

- (NSString *)realNameFormat;

- (NSString *)phoneFormat;

+ (NSString *)safeRank;

/**
 *  隐藏字符串，替换为*
 *
 *  @param start 开始位置
 *  @param end   结束位置
 */
- (NSString *)hideValue:(NSInteger)start end:(NSInteger)end;
@end
