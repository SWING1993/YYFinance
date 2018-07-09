//
//  QTJsonUtil+Login.m
//  qtyd
//
//  Created by stephendsw on 16/1/11.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTJsonUtil+Login.h"
#import "QTJsonUtil.h"
#import "GVUserDefaults.h"
#import "MJExtension.h"
#import "SystemConfigDefaults.h"
#import "NSString+model.h"

@implementation QTJsonUtil (other)

- (void)loginPara:(NSDictionary *)para done:(loginBlock)block {
    
    [[GVUserDefaults shareInstance] clear];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"user_name"] = para.str(@"user_name");
    dic[@"password"] = [para.str(@"password") desEncryptkey:deskey];
    dic[@"device_id"] = [AppUtil getOpenUDID];
    dic[@"device_name"] = [AppUtil getDeviceName];
    dic[@"login_type"] = para.str(@"login_type");
    dic[@"client_system_version"] = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
    dic[@"client_resolution"] = [AppUtil getResolution];
    dic[@"app_version"] = [AppUtil getAPPVersion];
    dic[@"client_name"] = [AppUtil getDeviceName];
    dic[@"client_network"] = [AppUtil getNetWorkStates];
    dic[@"client_udid"] = [AppUtil getOpenUDID];
    dic[@"login_area"] = [IPHelper deviceIPAdress];
    dic[@"client_time"] = @(@([NSDate systemDate].timeIntervalSince1970).integerValue);
    
    [self post:@"user_login" data:dic complete:^(NSDictionary *value) {
        
        [[NSUserDefaults standardUserDefaults] setValue:para.str(@"user_name") forKey:kStoreUserName];
        [[NSUserDefaults standardUserDefaults] setValue:[para.str(@"password") desEncryptkey:deskey] forKey:kStorePws];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SystemConfigDefaults sharedInstance].firstOpenTime = [NSDate date];
        
        
        [[GVUserDefaults shareInstance] clear];
       
        [[GVUserDefaults shareInstance] saveDataWithJson:value];
        
        HError *error = [[HChatClient sharedClient] registerWithUsername:kHelpDeskUserName password:kHelpDeskPassword];
        if (error) {
            NSLog(@"环信客服Error%@",error.errorDescription);
        }
       
        if (block) {
            block(value);
        }
    }];
}

/*
- (void)autoLogin:(loginBlock)block {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"user_name"] = [GVUserDefaults  shareInstance].username;
    dic[@"password"] = [[GVUserDefaults  shareInstance].pswDes desDecryptkey:deskey];
    [self loginPara:dic done:^(NSDictionary *value) {
        block(value);
    }];
}
*/


@end
