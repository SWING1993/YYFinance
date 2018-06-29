//
//  NSString+Calculation.h
//  qtyd
//
//  Created by stephendsw on 15/10/30.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Calculation)

/**
 *  值比较
 *
 *  @param operateStr 表达式
 *
 */
- (BOOL)compareExpression:(NSString *)operateStr;

/**
 *  值比较
 *
 */
- (BOOL)compareExpressionWithFormat:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

@end
