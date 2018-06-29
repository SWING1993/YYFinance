//
//  NSString+Encry.h
//  qtyd
//
//  Created by stephendsw on 15/9/18.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encry)

#pragma mark  - DES

/**
 *  DES 加密
 *
 */
- (NSString *)desEncryptkey:(NSString *)key;

/**
 *  DES 解密
 *
 */
- (NSString *)desDecryptkey:(NSString *)key;

#pragma mark  - AES

/**
 *  AES 加密
 *
 */
- (NSString *)AES256EncryptWithKey:(NSString *)key;

/**
 *  AES 解密
 *
 */
- (NSString *)AES256DecryptWithKey:(NSString *)key;

#pragma mark   - MD5

/**
 *  md5 加密
 *
 */
- (NSString *)md5HexDigest;

/**
 *  计算NSData 的MD5值
 */
+ (NSString *)getMD5WithData:(NSData *)data;

@end
