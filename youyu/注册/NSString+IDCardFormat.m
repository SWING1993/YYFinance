//
//  NSString+IDCardFormat.m
//  hr
//
//  Created by 慧融 on 21/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "NSString+IDCardFormat.h"

@implementation NSString (IDCardFormat)
+ (NSString*) IdCardFormat:(NSString*)str{
    NSString *preText = str;
    //去“-”后的文字
    NSString *currentStr = [preText stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //转临时可变字符串
    NSMutableString *tempStr = [currentStr mutableCopy];
    
    //计算拥有“-”的个数
    int spaceCount = 0;
    if (currentStr.length < 4 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 3) {
        spaceCount = 1;
    }else if (currentStr.length < 11 && currentStr.length > 6) {
        spaceCount = 2;
    }else if (currentStr.length < 15 && currentStr.length > 10) {
        spaceCount = 3;
    }else if (currentStr.length < 19 && currentStr.length > 15) {
        spaceCount = 4;
    }
    
    //循环添加“-”
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr insertString:@"-" atIndex:3];
        }else if (i == 1) {
            [tempStr insertString:@"-" atIndex:7];
        }else if (i == 2){
            [tempStr insertString:@"-" atIndex:12];
        }else if (i == 3){
            [tempStr insertString:@"-" atIndex:17];
        }else if (i == 4){
            [tempStr insertString:@"-" atIndex:22];
        }

    }
    return tempStr;
}

@end
