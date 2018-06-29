//
//  NSObject+Error.m
//  youyu
//
//  Created by 宋国华 on 2018/6/29.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "NSObject+Error.h"

@implementation NSObject (Error)

- (void)handleError {
    NSString *errorTip = @"";
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *errorDict = (NSDictionary *)self;
        if ((errorDict.code == 110025) || (errorDict.code == 110019)) {
            // 被踢了
            errorTip = LOGINOTHERTIP;
            [self toLoginController];
        } else if (errorDict.code == 110026) {
            // 超时
            errorTip = UNLOGINTIP;
            [errorDict toLoginController];
        } else {
            errorTip = errorDict.msg;
        }        
    } else if ([self isKindOfClass:[NSString class]]){
        errorTip = [NSString stringWithFormat:@"%@",self];
    } else {
        errorTip = NETERROR;
    }
    if (kStringIsEmpty(errorTip)) {
        errorTip = NETERROR;
    }
    [QMUITips showInfo:errorTip inView:kKeyWindow hideAfterDelay:2.5];
}

- (void)toLoginController {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [AppDelegate toLoginController];
    });
}


@end
