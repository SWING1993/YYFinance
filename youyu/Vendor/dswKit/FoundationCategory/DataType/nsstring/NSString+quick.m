//
//  NSString+quick.m
//  Car_ZJ
//
//  Created by stephen on 15/3/9.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "NSString+quick.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (quick)
@dynamic add;
@dynamic  removeRange;

- (NSString *(^)(NSObject *))add {
    return ^(NSObject *str) {
               if (!str) {
                   str = @"";
                   NSLog(@"================参数为nil==================");
               }

               return [self stringByAppendingFormat:@"%@", str];
    };
}

- (NSString *(^)(NSString *, NSString *))removeRange {
    return ^(NSString *startstr, NSString *endstr)
           {
               NSString *regstr = [NSString stringWithFormat:@"['%@'].*['%@']", startstr, endstr];

               return [self match:regstr replace:@""];
           };
}

- (NSString *)map:(mapStrBlock)Block {
    NSString *str = Block(self);

    return str;
}

- (NSArray *)separatedByString:(NSString *)str {
    NSArray<NSString *> *list = [self componentsSeparatedByString:str];

    NSMutableArray *array = [NSMutableArray new];

    for (NSString *item in list) {
        if (item.length > 0) {
            [array addObject:item];
        }
    }

    return array;
}

+ (NSString *)toJsonFromNSData:(id)object {
    if (!object) {
        return @"";
    }

    NSString    *jsonString = nil;
    NSError     *error;
    NSData      *jsonData = [NSJSONSerialization    dataWithJSONObject:object
                                                    options :NSJSONWritingPrettyPrinted   // Pass 0 if you don't care about the readability of the generated string
                                                    error   :&error];

    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    return jsonString;
}

- (NSString *)filterHTML {
    NSString    *html = self;
    NSScanner   *scanner = [NSScanner scannerWithString:html];
    NSString    *text = nil;

    while ([scanner isAtEnd] == NO) {
        // 找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        // 找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        // 替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }

    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (BOOL)containsString:(NSString *)content {
    if (![content isKindOfClass:[NSString class]]) {
        return NO;
    }

    NSRange range = [self rangeOfString:content];

    return range.location != NSNotFound;
}

+ (BOOL)isEmpty:(NSString *)str {
    NSString *string = str;

    if ((string == nil) || (string == NULL)) {
        return YES;
    }

    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }

    return NO;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    if (self.length <= idx) {
        return nil;
    } else {
        return [self substringWithRange:NSMakeRange(idx, 1)];
    }
}

+ (BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}

@end
