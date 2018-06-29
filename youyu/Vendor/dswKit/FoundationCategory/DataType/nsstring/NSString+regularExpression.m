//
//  NSString+regularExpression.m
//  Car_ZJ
//
//  Created by stephen on 15/4/29.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "NSString+regularExpression.h"

NSString *const kRegIDCard = @"^\\d{17}[0-9xX]$";

NSString *const kRegPassword = @"^[\\S\\s]{6,24}$";

NSString *const kRegValidCode = @"^\\d{6}$";

NSString *const kRegPhone = @"^1[345789]\\d{9}$";

NSString *const kBankCard = @"^\\d{15,19}$";

NSString *const kRegNumber = @"^[0-9\\.]+";

NSString *const kPositiveInteger = @"^[1-9][0-9]{0,%@}$";

NSString *const kMoney = @"^(([1-9]\\d{0,9})(\\.\\d{0,2})?|0(?:\\.)(\\d{0,2})?)|0|(?:0)\\.(\\d{0,2})?$";

NSString *const kBandEmail= @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";

NSString *const kUserName = @"^([\u4e00-\u9fa5]){2,4}$";


@implementation NSString (regularExpression)

- (NSString *)match:(NSString *)reg replace:(NSString *)replace {
    NSString            *searchText = self;
    NSError             *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:&error];

    while (true) {
        NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];

        if (result.range.length > 0) {
            searchText = [searchText stringByReplacingCharactersInRange:result.range withString:replace];
        } else {
            break;
        }
    }

    return searchText;
}

- (NSArray *)match:(NSString *)matchRegex  {
    matchRegex = [matchRegex stringByReplacingOccurrencesOfString:@"^" withString:@""];

    NSString            *str = self;
    NSError             *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex
                                                    options                     :NSRegularExpressionCaseInsensitive
                                                    error                       :&error];
    NSArray *match = [reg matchesInString:str
        options :NSMatchingReportCompletion
        range   :NSMakeRange(0, [str length])];

    NSMutableArray *rangeArr = [NSMutableArray array];

    // 取得所有的NSRange对象
    if (match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            NSRange range = [matc range];
            NSValue *value = [NSValue valueWithRange:range];
            [rangeArr addObject:value];
        }
    }

    if (rangeArr.count == 0) {
        return nil;
    }

    return rangeArr;
}

- (void)matchFirst:(NSString *)reg done:(regBlock)block {
    NSArray *array = [self match:reg];

    for (NSValue *item in array) {
        block(item.rangeValue);
        break;
    }
}

- (void)match:(NSString *)reg done:(regBlock)block {
    NSArray *array = [self match:reg];

    for (NSValue *item in array) {
        block(item.rangeValue);
    }
}

- (BOOL)isMatch:(NSString *)strExpression {
    NSError             *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:strExpression
        options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];

    if ((result.range.length == self.length) && (result.range.location == 0)) {
        return YES;
    } else {
        return NO;
    }
}

@end
