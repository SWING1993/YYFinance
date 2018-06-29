//
//  DESUtil.h
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface DESUtility : NSObject
                        // + (NSString *) udid;
                        // + (NSString *) md5:(NSString *)str;
+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
+ (NSString *)encryptStr:(NSString *)str key:(NSString *)key;
+ (NSString *)decryptStr:(NSString *)str key:(NSString *)key;

// data转16进制
+ (NSString *)hexStringFromData:(NSData *)myD;

// 16进制转data
+ (NSData *)stringToHexData:(NSString *)myStr;
@end
