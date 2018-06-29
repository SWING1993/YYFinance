//
//  NSString+URL.m
//  qtyd
//
//  Created by stephendsw on 15/12/10.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "NSString+URL.h"
#import "NSDictionary+quick.h"

@implementation NSString (URL)

- (NSString *)urlAddParameter:(NSDictionary *)dic {
    if ((self.length == 0)) {
        return nil;
    }
    if (dic.allKeys.count == 0) {
        return self;
    }
    NSString *strUrl = self;
    strUrl = [strUrl getEncodeUrl];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];

    if (url) {
        if (url.query) {
            return [NSString stringWithFormat:@"%@&%@", self, dic.urlParaStringValue];
        } else {
            return [NSString stringWithFormat:@"%@?%@", self, dic.urlParaStringValue];
        }
    } else {
        return nil;
    }
}

- (NSDictionary *)getUrlParameter {
    NSURL *url = [NSURL URLWithString:self];

    if (!url.query) {
        return nil;
    }

    NSString *propertys = url.query;

    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    // 把subArray转换为字典
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];

    for (int j = 0; j < subArray.count; j++) {
        // 在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        // 给字典加入元素
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }

    return tempDic;
}

- (NSString *)getEncodeUrl {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
}

- (NSString *)getDecodeUrl {
    NSString        *input = self;
    NSMutableString *outputStr = [NSMutableString stringWithString:input];

    [outputStr replaceOccurrencesOfString:@"+"
    withString  :@" "
    options     :NSLiteralSearch
    range       :NSMakeRange(0, [outputStr length])];

    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
