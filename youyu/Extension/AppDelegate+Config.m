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

    // 友盟统计
    UMConfigInstance.appKey = KEY_UM;
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setEncryptEnabled:YES];
    [MobClick setLogEnabled:NO];
    
    // 友盟分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:KEY_UM];
    // WX
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KYE_WXAppId appSecret:KEY_WXSecret redirectURL:nil];
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:KEY_QQAPPId/*设置QQ平台的appID*/  appSecret:KEY_QQSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    // 友盟推送
    [UMessage startWithAppkey:KEY_UM launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    
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
    
    // 打开日志，方便调试
    [UMessage setLogEnabled:YES];
    if ([GVUserDefaults  shareInstance].isLogin) {
        [UMessage addTag:@"login" response:^(id responseObject, NSInteger remain, NSError *error) {}];
        [UMessage removeTag:@"unlogin" response:^(id responseObject, NSInteger remain, NSError *error) {}];
    } else {
        [UMessage addTag:@"unlogin" response:^(id responseObject, NSInteger remain, NSError *error) {}];
        [UMessage removeTag:@"login" response:^(id responseObject, NSInteger remain, NSError *error) {}];
    }
    
    
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
}


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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userNotification" object:self userInfo:userInfo];
    }
}

//iOS10新增：处理前台收到通知的代理方法
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
    }else{
        //应用处于前台时的本地推送接受
        NSLog(@"//应用处于前台时的本地推送接受");
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    //    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userNotification" object:self userInfo:userInfo];
        
    } else {
        //应用处于后台时的本地推送接受
        NSLog(@"//应用处于后台时的本地推送接受");
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
    [store createTableWithName:kAdConfigTable];
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



@end
