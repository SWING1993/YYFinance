//
//  YYArticleModel.m
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMediaModel.h"

@implementation YYMediaModel

- (NSTimeInterval)sinceTimeInterval {
    NSTimeInterval since;
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSDate *nowTime = [NSDate dateWithString:self.now format:format];
    NSDate *startTime = [NSDate dateWithString:self.start_time format:format];
    since = -[nowTime timeIntervalSinceDate:startTime];
    return since;
}

@end
