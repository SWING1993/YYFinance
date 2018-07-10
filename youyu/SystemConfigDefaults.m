//
//  SystemConfigDefaults.m
//  qtyd
//
//  Created by stephendsw on 15/11/12.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "SystemConfigDefaults.h"

@implementation SystemConfigDefaults

+ (instancetype)sharedInstance {
    static SystemConfigDefaults *instance = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (NSString *)server_time {
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"server_time"];

    if ([NSString isEmpty:time]) {
        return [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970];
    } else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"server_time"];
    }
}

- (void)setServer_time:(NSString *)server_time {
    [[NSUserDefaults  standardUserDefaults] setObject:server_time forKey:@"server_time"];
}

- (NSDate *)firstOpenTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"firstOpenTime"];
}

- (void)setFirstOpenTime:(NSDate *)firstOpenTime {
    [[NSUserDefaults  standardUserDefaults] setObject:firstOpenTime forKey:@"firstOpenTime"];
}

- (NSDictionary *)launchDic {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"launchDic"];
}

- (void)setLaunchDic:(NSDictionary *)launchDic {
    [[NSUserDefaults  standardUserDefaults] setObject:launchDic forKey:@"launchDic"];
}

- (NSArray *)userList {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"userList"];
}

- (void)setUserList:(NSArray *)userList {
    [[NSUserDefaults  standardUserDefaults] setObject:userList forKey:@"userList"];
}

- (void)saveUserName:(NSString *)userName password:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userpws"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUserNameAndPsw {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpws"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getUserName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *)getPsw {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userpws"];
}

@end
