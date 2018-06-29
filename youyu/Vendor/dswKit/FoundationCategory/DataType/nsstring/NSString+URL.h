//
//  NSString+URL.h
//  qtyd
//
//  Created by stephendsw on 15/12/10.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 *  添加url参数
 */
- (NSString *)urlAddParameter:(NSDictionary *)dic;

/**
 *  获取url参数
 */
- (NSDictionary *)getUrlParameter;

/**
 *  获取编码后的url
 */
- (NSString *)getEncodeUrl;

/**
 *  解码后的url
 *
 */
-(NSString *)getDecodeUrl;

@end
