//
//  NSObject+quick.h
//  Car_ZJ
//
//  Created by stephen on 15/3/9.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (quick)

@property (nonatomic, readonly) NSString *__nonnull stringValue;

/**
 *  模型转字典
 *
 *  @return 字典
 */
- (NSDictionary *__nonnull)dictionaryValue;

/**
 *  带model的数组或字典转字典
 *
 *  @param object 带model的数组或字典转
 *
 *  @return 字典
 */
- (id __nonnull)idFromObject:(nonnull id)object;

@end
