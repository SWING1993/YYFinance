//
//  NSArray+Linq.h
//  linq
//
//
// ============================用法=========================
// Format：
// (1)比较运算符>,<,==,>=,<=,!=
// 可用于数值及字符串
// 例：@"number > 100"
//
//
// (2)范围运算符：IN、BETWEEN
// 例：@"number BETWEEN {1,5}"
// @"address IN {'shanghai','beijing'}"
//
//
// (3)字符串本身:SELF
// 例：@“SELF == ‘APPLE’"
//
//
// (4)字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
// 例：@"name CONTAIN[cd] 'ang'"   //包含某个字符串
// @"name BEGINSWITH[c] 'sh'"     //以某个字符串开头
// @"name ENDSWITH[d] 'ang'"      //以某个字符串结束
// 注:[c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
//
//
// (5)通配符：LIKE
// 例：@"name LIKE[cd] '*er*'"    //*代表通配符,Like也接受[cd].
// @"name LIKE[cd] '???er*'"
//
// (6)正则表达式：MATCHES
// 例：NSString *regex = @"^A.+e$";   //以A开头，e结尾
// @"name MATCHES %@",regex
//
// ============================用法=========================
//
//  Created by stephendsw on 15/8/26.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ mapBlock)(id obj);

@interface NSArray (Linq)

/**
 *  排序
 *
 *  @param asc       yes 升序  no 降序
 *
 */
- (id)sort:(NSString *)condition ascending:(BOOL)asc;

- (BOOL)any:(NSString *)condition;

- (NSArray *)where:(NSString *)condition;

- (id)single:(NSString *)condititon;

//- (id)min:(NSString *)condition;
//
//- (id)max:(NSString *)condition;

- (NSArray *)map:(mapBlock)block;

/**
 *  获取 子元素（字典类型） 指定键 的值 列表
 */
- (NSArray *)getArrayForKey:(NSString *)keypath;

- (NSArray *)add:(id)item;

- (NSArray *)remove:(id)item;

- (NSArray*)getArrayForKey:(NSString *)keypath value:(NSString*)value;

@property (nonatomic, readonly) NSString *joinedString;

@end
