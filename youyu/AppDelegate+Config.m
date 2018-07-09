//
//  AppDelegate+Config.m
//  youyu
//
//  Created by 宋国华 on 2018/6/21.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "AppDelegate+Config.h"
#import <UMSocialCore/UMSocialCore.h>
#import <XHLaunchAd/XHLaunchAd.h>
#import "QMUIConfigurationTemplate.h"
//table && key
#define kAdConfigStore @"AdConfig.db"
#define kAdConfigTable @"AdConfig_table"
#define kAdConfigKey @"AdConfigKey"
#define kAdConfigIndex @"kAdConfigIndex"

@interface YYAdConfigModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *href;
@end

@implementation YYAdConfigModel

@end


@implementation AppDelegate (Config)

- (void)setConfigurationWithOptions:(NSDictionary *)launchOptions {

    [self registerUserNotification];
    
    // 友盟统计
//    UMConfigInstance.appKey = KEY_UM;
//    [MobClick setAppVersion:XcodeAppVersion];
//    [MobClick startWithConfigure:UMConfigInstance];
//    [MobClick setEncryptEnabled:YES];
//    [MobClick setLogEnabled:NO];
    
    // 友盟推送
    //    [UMessage startWithAppkey:KEY_UM launchOptions:launchOptions];
    //    [UMessage registerForRemoteNotifications];
    
    
    // 打开日志，方便调试
    //    [UMessage setLogEnabled:YES];
    //    if ([GVUserDefaults  shareInstance].isLogin) {
    //        [UMessage addTag:@"login" response:^(id responseObject, NSInteger remain, NSError *error) {}];
    //        [UMessage removeTag:@"unlogin" response:^(id responseObject, NSInteger remain, NSError *error) {}];
    //    } else {
    //        [UMessage addTag:@"unlogin" response:^(id responseObject, NSInteger remain, NSError *error) {}];
    //        [UMessage removeTag:@"login" response:^(id responseObject, NSInteger remain, NSError *error) {}];
    //    }
    
    [self configUSharePlatforms];
    
    // iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (granted) {
            // 点击允许
            // 这里可以添加一些自己的逻辑
        } else {
            // 点击不允许
            // 这里可以添加一些自己的逻辑
        }
    }];

    
    // 环信客服
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
    
    HOptions *option = [[HOptions alloc] init];
    // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.appkey = kHelpDeskAppKey;
    // 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    option.tenantId = kHelpDeskTenantId;
    //推送证书名字 (集成离线推送必填)
    option.apnsCertName = @"your apnsCerName";
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HError *initError = [[HChatClient sharedClient] initializeSDKWithOptions:option];
    if (initError) { // 初始化错误
        NSLog(@"客服SDK错误%@",initError.errorDescription);
    }
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    //    config.baseUrl = @"http://www.uyujf.com:8888";
    config.baseUrl = kBaseUrl;
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/css", nil];
    NSString *keypath = @"jsonResponseSerializer.acceptableContentTypes";
    [agent setValue:acceptableContentTypes forKeyPath:keypath];
    
    [self customizeAppearance];
    [self autoLoginAction];
}

#pragma mark - 注册推送通知
- (void)registerUserNotification {
    if (ios10x) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取当前的通知设置，UNNotificationSettings是只读对象，不能直接修改，只能通过以下方法获取
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                }];
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


#pragma mark - 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[HChatClient sharedClient] bindDeviceToken:deviceToken];
}

#pragma mark - 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

#pragma mark - 处理通知在前台运行时的情况 UNUserNotificationCenterDelegate
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        completionHandler(UNNotificationPresentationOptionAlert);
        NSLog(@"//应用处于前台时的远程推送接受关闭U-Push自带的弹出框");
    } else {
        //应用处于前台时的本地推送接受
        NSLog(@"//应用处于前台时的本地推送接受");
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}

#pragma mark - 处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICEWEB object:self userInfo:userInfo];
        
    } else {
        //应用处于后台时的本地推送接受
        NSLog(@"//应用处于后台时的本地推送接受");
    }
}


#pragma mark - 处理通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    // 显示在icon上的红色圈中的数子
    [UIApplication sharedApplication].applicationIconBadgeNumber = userInfo.i(@"aps.badge");
    notification.userInfo = userInfo;
    // 添加推送到UIApplication
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    if (application.applicationState != UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTICEWEB object:self userInfo:userInfo];
    }
}

- (void)customizeAppearance {
}

- (void)setupXHLaunchAd {
    NSString *key = @"kShowIntroVersion";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:key];
    if (![value isEqualToString:kVersion]) {
        return;
    }
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:kAdConfigStore];
    NSArray *adConfigurationMs = [YYAdConfigModel mj_objectArrayWithKeyValuesArray:[store getObjectById:kAdConfigKey fromTable:kAdConfigTable]];
    if (adConfigurationMs.count > 0) {
        // 顺序配置 上次的索引
        NSInteger index = [[store getNumberById:kAdConfigIndex fromTable:kAdConfigTable] integerValue];
        if (index < 0 || index >= adConfigurationMs.count) {
            index = 0;
        }
        [self setupAdWithConfiguration:[adConfigurationMs objectAtIndex:index%adConfigurationMs.count]];
        index += 1;
        [store putNumber:@(index) withId:kAdConfigIndex intoTable:kAdConfigTable];
    }
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self storeAdConfiguration];
    });
}

- (void)storeAdConfiguration {
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"apphome_splashScreenList" requestArgument:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            NSArray *pic_list = resultDict.content[@"pic_list"];
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:kAdConfigStore];
            [store createTableWithName:kAdConfigTable];
            if (pic_list.count > 0) {
                [store putObject:pic_list withId:kAdConfigKey intoTable:kAdConfigTable];
            } else {
                [store deleteObjectById:kAdConfigKey fromTable:kAdConfigTable];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

- (void)setupAdWithConfiguration:(YYAdConfigModel *)configM {
    if (configM == nil || kStringIsEmpty(configM.url)) {
        [XHLaunchAd removeAndAnimated:YES];
        return;
    }
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 4.0f;
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    NSString *urlStr = configM.url;
    imageAdconfiguration.imageNameOrURLString = urlStr;
    //广告点击打开链接
    imageAdconfiguration.openModel = configM;
    //allowReturn 添加跳过按钮
    imageAdconfiguration.customSkipView = [self customSkipView];
    
    //广告frame
    imageAdconfiguration.frame = kScreenBounds;
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

#pragma mark - customSkipView
//自定义跳过按钮
-(UIView *)customSkipView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:UIImageMake(@"skipBtn") forState:UIControlStateNormal];
    
    CGFloat btnWidth = kScaleFrom_iPhone6_Desgin(75.0f);
    CGFloat btnHeight = btnWidth * 25.0f/63.0f;
    CGFloat y = 25.0f;
    CGFloat x = kScreenW - btnWidth - y;
    
    button.frame = CGRectMake(x, y, btnWidth, btnHeight);
    [button addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - XHLaunchAd delegate - 跳过按钮点击事件
-(void)skipAction {
    [XHLaunchAd removeAndAnimated:YES];
    
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"apphome_popList" requestArgument:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        if (resultDict.code == 100000) {
            NSArray *pic_list = resultDict.content[@"pic_list"];
            if (pic_list.count > 0) {
                YYAdConfigModel *configM = [YYAdConfigModel mj_objectWithKeyValues:pic_list[0]];
                [self handleWindowShowingWithImageUrl:configM.url actionUrl:configM.href];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

- (void)handleWindowShowingWithImageUrl:(NSString *)imageUrl actionUrl:(NSString *)actionUrl {

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScaleFrom_iPhone6_Desgin(258), kScaleFrom_iPhone6_Desgin(272)+50)];
    contentView.backgroundColor = kColorClear;
    contentView.layer.cornerRadius = 6;
    
    QMUIButton *closeBtn = [[QMUIButton alloc] init];
    [closeBtn setImage:UIImageMake(@"home_close_btn") forState:UIControlStateNormal];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(contentView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.layer.cornerRadius = 6;
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:YYURLWithStr(imageUrl) placeholderImage:kPlaceholderImage];
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(272));
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 UIWindow 的形式来展示
    [modalViewController showWithAnimated:YES completion:nil];
    
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [modalViewController hideWithAnimated:YES completion:^(BOOL finished) {
            
        }];
    }];
    
    [imageView bk_whenTapped:^{
        [modalViewController hideWithAnimated:YES completion:^(BOOL finished) {
            [AppDelegate toWebViewControllerWithUrl:actionUrl];
        }];
    }];
}

#pragma mark - XHLaunchAd delegate - 其他

/**
 *  广告点击事件 回调
 */

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    YYAdConfigModel *configM = openModel;
    if (!kStringIsEmpty(configM.href)) {
        [AppDelegate toWebViewControllerWithUrl:configM.href];
    }
    
}

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  XHLaunchAd
 *  @param imageSize image
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image {
    //    DebugLog(@"XHLaunchAd图片本地读取/或下载完成回调");
}

/**
 *  广告显示完成
 */
-(void)xhLaunchShowFinish:(XHLaunchAd *)launchAd {
}

- (void)configUSharePlatforms {
    // 友盟分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:KEY_UM];
    // WX
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KEY_WXAppId appSecret:KEY_WXSecret redirectURL:@"http://mobile.umeng.com/social"];
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:KEY_QQAPPId appSecret:KEY_QQSecret redirectURL:@"http://mobile.umeng.com/social"];
    // Weibo
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:KEY_SinaAPPId appSecret:KEY_SinaSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    // 移除相应平台的分享，如微信收藏
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
}

- (void)autoLoginAction {

    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kStoreUserName];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:kStorePws];

    if (!kStringIsEmpty(username) && !kStringIsEmpty(password)) {
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"user_name"] = username;
        dic[@"password"] = password;
        dic[@"device_id"] = [AppUtil getOpenUDID];
        dic[@"device_name"] = [AppUtil getDeviceName];
        dic[@"login_type"] = @"1";
        dic[@"client_system_version"] = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
        dic[@"client_resolution"] = [AppUtil getResolution];
        dic[@"app_version"] = [AppUtil getAPPVersion];
        dic[@"client_name"] = [AppUtil getDeviceName];
        dic[@"client_network"] = [AppUtil getNetWorkStates];
        dic[@"client_udid"] = [AppUtil getOpenUDID];
        dic[@"login_area"] = [IPHelper deviceIPAdress];
        dic[@"client_time"] = @(@([NSDate systemDate].timeIntervalSince1970).integerValue);
        [[GVUserDefaults shareInstance] clear];

        YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"user_login" requestArgument:dic];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary *resultDict = (NSDictionary *)request.responseObject;
            if (resultDict.code == 100000) {
                if (resultDict.content.allKeys > 0) {
                    [[GVUserDefaults shareInstance] saveDataWithJson:resultDict.content];
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
  
}

@end
