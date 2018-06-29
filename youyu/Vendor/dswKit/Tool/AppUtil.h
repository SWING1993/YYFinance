//
//  WLAppStoreUtil.h
//  Util
//
//  Created by stephen on 13-11-4.
//  Copyright (c) 2014年 dsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ firstLuanchBlock)();

// ****************************************device****************************************
#pragma mark - device

#define IOS_VERSION_7_OR_ABOVE  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? (YES) : (NO))

#define IOS_VERSION_8_OR_ABOVE  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? (YES) : (NO))

#define  IOS_VERSION_9_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? (YES) : (NO))

#define IOS_VERSION_7           (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) ? (YES) : (NO))

#define IOS_VERSION_6           (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)) ? (YES) : (NO))

// **************************************屏幕******************************************
#pragma mark -  屏幕

#define APP_FRAEM   ([UIScreen mainScreen].bounds)
#define APP_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define APP_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
//状态栏高度
#define APP_STATUSBARHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define APP_NAVIGATIONBARHEIGHT self.navigationController.navigationBar.frame.size.height
//标签栏高度
#define APP_TABBARHEIGHT self.tabBarController.tabBar.frame.size.height

//状态栏高度
#define APP_STATUSBARHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define APP_NAVIGATIONBARHEIGHT self.navigationController.navigationBar.frame.size.height

#define APP_NAVHEIGHT (APP_STATUSBARHEIGHT==20?64:88)

//标签栏高度
#define APP_TABBARHEIGHT self.tabBarController.tabBar.frame.size.height

// **************************************屏幕******************************************
#define IPHONE4     ((APP_HEIGHT == 480) ? (YES) : (NO))

#define IPHONE5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)


#define IPHONE6PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface AppUtil : NSObject

#pragma mark device

/**
 *  获取openUDID
 *
 */
+ (NSString *)getOpenUDID;

/**
 *  获取设备名
 *
 */
+ (NSString *)getDeviceName;

/**
 *  是否联网
 *
 */
+ (BOOL)isConnectedToNetwork;

/**
 *  网络类型
 *
 */
+ (NSString *)getNetWorkStates;

/**
 *  分辨率
 *
 */
+ (NSString *)getResolution;

#pragma mark app

/**
 *  获取app版本
 *
 */
+ (NSString *)getAPPVersion;

/**
 *  获取app内部版本
 *
 */
+ (NSString *)getAPPBuild;

/**
 *  APP Store 上打开应用
 *
 */
+ (BOOL)appStoreWithAppId:(NSString *)appId;

/**
 *  safari 打开链接
 *
 */
+ (void)safari:(NSString *)urlString;

/**
 *  拨打电话
 *
 */
+ (BOOL)dial:(NSString *)tel;

/**
 *  打开APP
 *
 */
+ (BOOL)openApp:(NSString *)url;

/**
 *  获取IDFA
 *
 */
+  (NSString*)getAPPIDFA;


/**
 *  跳转评论
 *
 *
 */
+ (void)openAPPComment:(NSString *)appid;

#pragma mark other
+ (void)onceAction:(NSString *)key block:(firstLuanchBlock)block;

+ (void)onceAction:(NSString *)key block:(firstLuanchBlock)block otherBlock:(firstLuanchBlock)blockOther;

@end
