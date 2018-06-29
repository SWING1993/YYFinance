//
//  NSDictionary+ServerInfo.h
//  youyu
//
//  Created by 宋国华 on 2018/6/13.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ServerInfo)

- (NSString *)msg;

- (NSString *)serversion;

- (NSInteger)code;

- (NSDictionary *)info;

- (NSDictionary *)content;

- (void)handleError;

@end
