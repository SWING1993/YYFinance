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

@end
