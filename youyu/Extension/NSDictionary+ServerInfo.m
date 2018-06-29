//
//  NSDictionary+ServerInfo.m
//  youyu
//
//  Created by 宋国华 on 2018/6/13.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "NSDictionary+ServerInfo.h"

@implementation NSDictionary (ServerInfo)

-(NSDictionary *)info {
    return self[@"response"][@"info"];
}

- (NSString *)msg {
    return self[@"response"][@"info"][@"msg"];
}

- (NSString *)serversion {
    return self[@"response"][@"info"][@"serversion"];
}

- (NSInteger)code {
    return [self[@"response"][@"info"][@"code"] integerValue];
}

- (NSDictionary *)content {
    return self[@"response"][@"content"];
}

- (void)handleError {
    NSString *errorTip = @"";
    if ((self.code == 110025) || (self.code == 110019)) {
        // 被踢了
        errorTip = LOGINOTHERTIP;
        [self toLoginController];
    } else if (self.code == 110026) {
        // 超时
        errorTip = UNLOGINTIP;
        [self toLoginController];
    } else {
        errorTip = self.msg;
        if (kStringIsEmpty(errorTip)) {
            errorTip = NETERROR;
        }
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
