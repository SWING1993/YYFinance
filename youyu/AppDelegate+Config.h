//
//  AppDelegate+Config.h
//  youyu
//
//  Created by 宋国华 on 2018/6/21.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Config)<UNUserNotificationCenterDelegate>

- (void)setConfigurationWithOptions:(NSDictionary *)launchOptions;

- (void)setupXHLaunchAd;

@end
