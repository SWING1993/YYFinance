//
//  NSDictionary+quick.h
//  Car_ZJ
//
//  Created by stephen on 15/3/18.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (quick)

/**
 *   获取 url参数格式字符串
 */
@property(nonatomic, readonly) NSString *urlParaStringValue;

#pragma mark  数据转化
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;

- (NSString *)convertToJSONData;

/**
 *  是否包含key
 *
 */
- (BOOL)containsKey:(NSString *)key;

#pragma mark - model

/**
 *  字符串类型
 */
@property(nonatomic, readonly) NSString *(^str)(NSString *keypath);

/**
 *  数组
 */
@property(nonatomic, readonly) NSArray *(^arr)(NSString *keypath);

/**
 *  字典
 */
@property(nonatomic, readonly) NSDictionary *(^dic)(NSString *keypath);

/**
 *  number
 */
@property(nonatomic, readonly) NSNumber *(^num)(NSString *keypath);

/**
 *  float类型
 */
@property(nonatomic, readonly) CGFloat (^fl)(NSString *keypath);

/**
 *  double类型
 */
@property(nonatomic, readonly) double (^d)(NSString *keypath);

/**
 *  int类型
 */
@property(nonatomic, readonly) NSInteger (^i)(NSString *keypath);

/**
 *   时间戳->日期
 */
@property (nonatomic, readonly) NSDate *(^date)(NSString *keyPath);

@end
