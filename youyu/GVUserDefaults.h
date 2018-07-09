//
//  GVUserDefaults.h
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  weakright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GVUserDefaults : NSObject

#pragma mark - 用户信息

/**
 *  标识用户是否登录
 */
@property (nonatomic, assign) BOOL isLogin;

/**
 *  用户手机号码
 */
@property (nonatomic, copy) NSString *phone;

/**
 *  访问access_id
 */
@property (nonatomic, copy) NSString *access_id;

/**
 *  访问access_key
 */
@property (nonatomic, copy) NSString *access_key;

/**
 *  用户身份证号
 */
@property (nonatomic, copy) NSString *card_id;

/**
 *  用户是否有收货地址(1.存在 2.不存在)
 */
@property (nonatomic, copy) NSString *address_exists;

@property (nonatomic, assign) NSInteger is_lender;

/**
 *  新浪账户账号
 */
//@property (nonatomic, strong) NSString *sina_uid;

/**
 *  用户Id
 */
@property (nonatomic, copy) NSString *user_id;

/**
 *  支付密码状态(1.已设置)
 */
@property (nonatomic, assign) BOOL paypwd_status;

@property (nonatomic, assign) BOOL phone_status;

/**
 *  解密key
 */
@property (nonatomic, copy) NSString *des_key;

@property (nonatomic, assign) NSInteger logintime;

/**
 *  用户真实姓名
 */
@property (nonatomic, copy) NSString *realname;

/**
 *  用户邀请好友短链接
 */
@property (nonatomic, copy) NSString *card_type;

/**
 *  用户邮箱地址
 */
@property (nonatomic, copy) NSString *email;

/**
 *  用户邮箱地址状态  0 无邮箱  1 已绑定  2 未激活
 */
@property (nonatomic, copy) NSString *email_status;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nick_name;

/**
 *  实名认证状态
 */
@property (nonatomic, assign) BOOL real_status;

/**
 *  用户名(手机号)
 */
@property (nonatomic, copy) NSString *username;

/**
 *  用户第一次投资时间  0 未投
 */
@property (nonatomic, copy) NSString *first_tender_time;

/**
 *  头像URL
 */
@property (nonatomic, copy) NSString *litpic;

/**
 *  头像URL
 */
@property (nonatomic, copy) NSString *app_litpic;

/**
 *  是否签到(1已签到 2未签到)
 */
@property (nonatomic, copy) NSString *insign_flg;

/**
 *  是否签到(1已签到 2未签到)
 */
@property (nonatomic, copy) NSString *insign_time;

/**
 *  经过DES加密的登录信息共享key
 */
@property (nonatomic, copy) NSString *redis_key;

/**
 *  加密后的密码
 */
//@property (nonatomic, copy) NSString *pswDes;

/**
 *  是否开通智慧投
 */
@property (nonatomic, assign) BOOL is_lazy_tender;

/**
 *  是否开通委托扣款
 */
@property (nonatomic, assign) BOOL withhold;

/**
 *  是否阅读协议
 */
@property (nonatomic, assign) BOOL isAgreeBook;

+ (instancetype)shareInstance;
//- (instancetype)init NS_UNAVAILABLE;
//+ (instancetype)new NS_UNAVAILABLE;

- (void)saveDataWithJson:(NSDictionary *)json;
- (void)clear;

- (BOOL)isSetPayPassword;

@end
