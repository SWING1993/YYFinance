//
//  NSString+quick.h
//  Car_ZJ
//
//  Created by stephen on 15/3/9.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+regularExpression.h"
#import <UIKit/UIKit.h>

#define strings(firstStr, ...) [@[firstStr, ## __VA_ARGS__] componentsJoinedByString : @""]

typedef NSString *(^ mapStrBlock)(NSString *value);

@interface NSString (quick)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

#pragma mark  添加删除

/**
 *  拼接字符串（对象）
 */
@property(nonatomic, readonly) NSString *(^add)(NSObject *str);

/**
 *  删除指定字符串间的字符
 */
@property(nonatomic, readonly) NSString *(^removeRange)(NSString *startstr, NSString *endstr);

#pragma  mark 转化
- (NSString *)map:(mapStrBlock)Block;

- (NSArray *)separatedByString:(NSString *)str;

#pragma mark 编码

- (NSString *)filterHTML;

#pragma mark tojsonString
+ (NSString *)toJsonFromNSData:(id)object;

+ (BOOL)isEmpty:(NSString *)str;

#pragma mark 纯数字
+ (BOOL)isPureInt:(NSString *)string;



@end
