//
//  NSString+regularExpression.h
//  Car_ZJ
//
//  Created by stephen on 15/4/29.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kRegIDCard;

FOUNDATION_EXPORT NSString *const kRegPassword;

FOUNDATION_EXPORT NSString *const kRegValidCode;

FOUNDATION_EXPORT NSString *const kRegPhone;

FOUNDATION_EXPORT NSString *const kRegNumber;

FOUNDATION_EXPORT NSString *const kBankCard;

FOUNDATION_EXPORT NSString *const kBandEmail;

FOUNDATION_EXPORT NSString *const kUserName;



/**
 *  3位正整数
 */
FOUNDATION_EXPORT NSString *const kPositiveInteger_3;

/**
 *  正整数
 */
FOUNDATION_EXPORT NSString *const kPositiveInteger;

FOUNDATION_EXPORT NSString *const kMoney;

FOUNDATION_EXPORT NSString *const kRegNumber;

typedef void (^ regBlock)(NSRange range);

@interface NSString (regularExpression)

/**
 *  替换
 */
- (NSString *)match:(NSString *)regex replace:(NSString *)replace;

/**
 *  匹配
 */
- (void)match:(NSString *)regex done:(regBlock)block;

/**
 *  首个匹配
 */
- (void)matchFirst:(NSString *)regex done:(regBlock)block;

/**
 *  是否匹配
 */
- (BOOL)isMatch:(NSString *)regex;

@end
