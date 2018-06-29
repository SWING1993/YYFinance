//
//  NSString+Encry.m
//  qtyd
//
//  Created by stephendsw on 15/9/18.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "NSString+Encry.h"
#import "DESUtility.h"
#import "NSData+Encryption.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Encry)

#pragma  mark - DES

- (NSString *)desEncryptkey:(NSString *)key{
    return [DESUtility encryptStr:self key:key];
}

- (NSString *)desDecryptkey:(NSString *)key {
    return [DESUtility decryptStr:self key:key];
}

+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key {
    key = [key substringToIndex:8];
    NSData *cipherdata = [NSString hexToBytes:cipherText];
    
    unsigned char buffer[1024];
    
    memset(buffer, 0, sizeof(char));
    
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(
                                          kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          [key UTF8String],
                                          [cipherdata bytes],
                                          [cipherdata length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    
    NSString *plaintext = nil;
    
    if (cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        
        plaintext = [[NSString alloc] initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    
    return plaintext;
}

+ (NSData *)hexToBytes:(NSString *)str {
    NSMutableData   *data = [NSMutableData data];
    int             idx;
    
    for (idx = 0; idx + 2 <= str.length; idx += 2) {
        NSRange         range = NSMakeRange(idx, 2);
        NSString        *hexStr = [str substringWithRange:range];
        NSScanner       *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int    intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}

#pragma  mark - AES
-(NSString *)AES256EncryptWithKey:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data AES256EncryptWithKey:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

-(NSString *)AES256DecryptWithKey:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES256DecryptWithKey:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


#pragma mark - MD5
- (NSString *)md5HexDigest {
    const char      *original_str = [self UTF8String];
    unsigned char   result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
    //return [hash uppercaseString];
}


//计算NSData 的MD5值
+(NSString*)getMD5WithData:(NSData*)data
{
   
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5([data bytes], (uint32_t)data.length, digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

@end
