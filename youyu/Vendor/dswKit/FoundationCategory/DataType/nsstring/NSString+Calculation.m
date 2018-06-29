//
//  NSString+Calculation.m
//  qtyd
//
//  Created by stephendsw on 15/10/30.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "NSString+Calculation.h"

@implementation NSString (Calculation)

- (BOOL)compareExpression:(NSString *)operateStr {
    NSString *sql = operateStr;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];

    if ([predicate evaluateWithObject:self]) {
        return YES;
    }

    return NO;
}

- (BOOL)compareExpressionWithFormat:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2) {
    va_list arglist;

    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);

    return [self compareExpression:outStr];
}

@end
