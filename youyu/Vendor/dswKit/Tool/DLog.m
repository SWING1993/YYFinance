//
//  NSArray+DLog.m
//  qtyd
//
//  Created by stephendsw on 15/11/24.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "DLog.h"
#import "NSString+quick.h"
#import <objc/runtime.h>

@implementation NSArray (DLog)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个[
    [string appendString:@"[\n"];
    
    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    
    // 结尾有个]
    [string appendString:@"]"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
}

@end

@implementation NSDictionary (DLog)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个{
    [string appendString:@"{\n"];
    
    // 遍历所有的键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"\t%@", key];
        [string appendString:@" : "];
        [string appendFormat:@"%@,\n", obj];
    }];
    
    // 结尾有个}
    [string appendString:@"}"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
}

@end
