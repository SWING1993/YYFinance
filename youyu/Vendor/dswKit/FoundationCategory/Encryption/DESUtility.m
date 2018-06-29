//
//  DESUtil.m
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "DESUtility.h"

static NSString *_key = @"";
@implementation DESUtility

// data转16进制
+ (NSString *)hexStringFromData:(NSData *)myD {
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";

    for (int i = 0; i < [myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i] & 0xff];///16进制数

        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }

    return hexStr;
}

// 16进制转data
+ (NSData *)stringToHexData:(NSString *)myStr {
    int             len = (int)([myStr length] / 2); // Target length
    unsigned char   *buf = malloc(len);
    unsigned char   *whole_byte = buf;
    char            byte_chars[3] = {'\0', '\0', '\0'};

    int i;

    for (i = 0; i < [myStr length] / 2; i++) {
        byte_chars[0] = [myStr characterAtIndex:i * 2];
        byte_chars[1] = [myStr characterAtIndex:i * 2 + 1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }

    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}

+ (NSString *)encryptStr:(NSString *)str key:(NSString *)key {
    _key = key;

    return [DESUtility doCipher:str key:_key context:kCCEncrypt];
}

+ (NSString *)decryptStr:(NSString *)str key:(NSString *)key {
    _key = key;
    return [DESUtility doCipher:str key:_key context:kCCDecrypt];
}

+ (NSString *)  doCipher:(NSString *)sTextIn key:(NSString *)sKey
                context :(CCOperation)encryptOrDecrypt {
    NSStringEncoding EnC = NSUTF8StringEncoding;

    NSMutableData *dTextIn;

    if (encryptOrDecrypt == kCCDecrypt) {
        //        dTextIn = [[sTextIn dataUsingEncoding:EnC] mutableCopy];
        dTextIn = [[DESUtility stringToHexData:sTextIn] mutableCopy];
    } else {
        dTextIn = [[sTextIn dataUsingEncoding:EnC] mutableCopy];
    }

    NSMutableData *dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t  bufferPtrSize1 = 0;
    size_t  movedBytes1 = 0;
    // uint8_t iv[kCCBlockSizeDES];
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    CCCrypt(encryptOrDecrypt,   // CCOperation op
        kCCAlgorithmDES,        // CCAlgorithm alg
        kCCOptionPKCS7Padding,  // CCOptions options
        [dKey bytes],           // const void *key
        [dKey length],          // size_t keyLength
        iv,                     // const void *iv
        [dTextIn bytes],        // const void *dataIn
        [dTextIn length],       // size_t dataInLength
        (void *)bufferPtr1,     // void *dataOut
        bufferPtrSize1,         // size_t dataOutAvailable
        &movedBytes1);          // size_t *dataOutMoved

    NSString *sResult;

    if (encryptOrDecrypt == kCCDecrypt) {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        sResult = [[NSString alloc] initWithData:dResult encoding:EnC];
    } else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        sResult = [DESUtility hexStringFromData:dResult];
    }

    return sResult;
}

@end
