//
//  NSString+Data.m
//  qtyd
//
//  Created by stephendsw on 15/11/18.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "NSString+Data.h"

@implementation NSString (Data)

+ (NSString *)stringFormValue:(double)value {
    return [NSString stringWithFormat:@"%f", value];
}

@end
