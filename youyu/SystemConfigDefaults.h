//
//  SystemConfigDefaults.h
//  qtyd
//
//  Created by stephendsw on 15/11/12.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfigDefaults : NSObject

+ (instancetype)sharedInstance;

/**
 *  服务器时间
 */
@property (nonatomic, strong) NSString *server_time;

/**
 *  首次打开应用时间
 */
@property (nonatomic, strong) NSDate *firstOpenTime;

/**
 *  启动页数据
 */
@property (nonatomic, strong) NSDictionary *launchDic;

/**
 *  用户列表
 */
@property (nonatomic, strong) NSArray *userList;

- (void)saveUserName:(NSString *)userName password:(NSString *)password;

- (void)removeUserNameAndPsw;

- (NSString *)getUserName;

- (NSString *)getPsw;

@end
