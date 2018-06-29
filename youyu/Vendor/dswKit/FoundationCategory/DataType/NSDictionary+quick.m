//
//  NSDictionary+quick.m
//  Car_ZJ
//
//  Created by stephen on 15/3/18.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "NSDictionary+quick.h"
#import "NSString+quick.h"
#import "NSObject+quick.h"

@implementation NSDictionary (quick)

#pragma  mark - model
- (NSArray *(^)(NSString *))arr {
    return ^(NSString *keypath) {
               id item = [self valueForKeyPath:keypath];

               if (![item isKindOfClass:[NSArray class]]) {
                   return [NSArray new];
               } else {
                   return (NSArray *)item;
               }
    };
}

- (NSString *(^)(NSString *))str {
    return ^(NSString *keypath) {
               id item = [self valueForKeyPath:keypath];

               return [item stringValue];
    };
}

- (NSDictionary *(^)(NSString *))dic {
    return ^(NSString *keypath) {
               id item = [self valueForKeyPath:keypath];

               return (NSDictionary *)item;
    };
}

- (NSNumber *(^)(NSString *))num {
    return ^(NSString *keypath) {
               id item = [self valueForKeyPath:keypath];

               return (NSNumber *)item;
    };
}

- (CGFloat (^)(NSString *))fl {
    return ^(NSString *keypath) {
               CGFloat item = [self.str(keypath) floatValue];

               return item;
    };
}

- (double (^)(NSString *))d {
    return ^(NSString *keypath) {
               return self.str(keypath).doubleValue;
    };
}

- (NSInteger (^)(NSString *))i {
    return ^(NSString *keypath) {
               return self.str(keypath).integerValue;
    };
}

- (NSDate * (^)(NSString *))date {
    return ^(NSString *keypath) {
               NSTimeInterval item = [[[self valueForKeyPath:keypath] stringValue] doubleValue];
               return [NSDate dateWithTimeIntervalSince1970:item];
    };
}

#pragma  mark -

- (BOOL)containsKey:(NSString *)key {
    return [[self allKeys] containsObject:key];
}

- (NSString *)urlParaStringValue {
    NSMutableString *str = [NSMutableString new];

    for (NSString *keys in self.allKeys) {
        if (str.length > 0) {
            [str appendString:@"&"];
        }

        [str appendString:keys];
        [str appendString:@"="];
        [str appendString:[self[keys] stringValue]];
    }

    return str;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData          *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError         *err;
    NSDictionary    *dic = [NSJSONSerialization JSONObjectWithData:jsonData
        options :NSJSONReadingMutableContainers
        error   :&err];

    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }

    return dic;
}

+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData {
    if (jsonData && [jsonData isKindOfClass:[NSData class]]) {
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        return object;
    } else {
        return nil;
    }
}

- (NSString *)convertToJSONData {
    NSError *error;
    NSData  *jsonData = [NSJSONSerialization    dataWithJSONObject:self
                                                options :NSJSONWritingPrettyPrinted       // Pass 0 if you don't care about the readability of the generated string
                                                error   :&error];

    NSString *jsonString = @"";

    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  // 去除掉首尾的空白字符和换行字符

    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    return jsonString;
}

@end
