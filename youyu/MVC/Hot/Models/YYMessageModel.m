//
//  YYMessageModel.m
//  youyu
//
//  Created by 宋国华 on 2018/6/15.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMessageModel.h"

@implementation YYMessageModel

- (NSString *)sendtime {
    NSString *formatStr = @"yyyy-MM-dd HH:mm";
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[_sendtime integerValue]];
    return [sendDate stringWithFormat:formatStr];
}

@end
