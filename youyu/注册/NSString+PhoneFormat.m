//
//  NSString+PhoneFormat.m
//  hr
//
//  Created by 慧融 on 20/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "NSString+PhoneFormat.h"

@implementation NSString (PhoneFormat)

+ (NSString*) phoneFormat:(NSString*)str{
    NSString *preText = str;
    //去“-”后的文字
    NSString *currentStr = [preText stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //转临时可变字符串
    NSMutableString *tempStr = [currentStr mutableCopy];
    
    //计算拥有“-”的个数
    int spaceCount = 0;
    if (currentStr.length < 4 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 8 && currentStr.length > 3) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 7) {
        spaceCount = 2;
    }
    
    //循环添加“-”
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr insertString:@"-" atIndex:3];
        }else if (i == 1) {
            [tempStr insertString:@"-" atIndex:8];
        }
    }
    return tempStr;
}

@end
