//
//  YYWebViewController.m
//  youyu
//
//  Created by 宋国华 on 2018/7/6.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma ide diagnostic ignored "CannotResolve"

#import "YYWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import <UShareUI/UShareUI.h>
#import "YYFinanceController.h"

@interface YYWebViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *urlStr;
@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;

@end

@interface YYWebViewController ()

@end

@implementation YYWebViewController

- (id)initWithUrlStr:(NSString *)urlStr {
    self = [super init];
    if (self) {
        self.urlStr = [urlStr hasPrefix:@"http"] ? urlStr : WEB_URL(urlStr);;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**基础设置，并初始化bridge*/
    [self baseConfig];
    /**配置WebBridge*/
    [self bridgeConfig];
    /**加载本地网页*/
    [self loadUrl];
    // Do any additional setup after loading the view.
}

/**常规设置，添加网页*/
- (void)baseConfig {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = kColorWhite;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

/**加载网页*/
- (void)loadUrl {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [self.webView loadRequest:request];
}

/**配置WebBridge*/
- (void)bridgeConfig {
    /**初始化bridge*/
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:(WVJB_WEBVIEW_TYPE *) self.webView];
    [self.bridge setWebViewDelegate:self];
    [WebViewJavascriptBridge enableLogging];
    
    

    // 向Web发送数据data，并接收Web返回的数据responseData
    // data: 发送给Web的数据
    // responseData:Web接收到数据后执行了callHandler，带回来responseData数据
    /*
    NSDictionary *customData = @{@"ACTION": @"tokenValue",
                                 @"ww": @"iPhone7P"};
    [self.bridge callHandler:@"iOSToWeb" data:customData responseCallback:^(id responseData) {
        NSLog(@"发送给Web的内容为:%@,接收到网页的内容为:%@", customData, responseData);
    }];
     */
    
    // JS主动调用OjbC的方法
    // 这是JS会调用WebToiOS方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"WebToiOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        NSDictionary *jsonDict = [data mj_JSONObject];
        NSString *action = jsonDict[@"action"];
        if ([action isEqualToString:@"getUserInfo"]) {
            if (responseCallback) {
                NSDictionary *userInfo = @{@"user_id":[GVUserDefaults  shareInstance].user_id?:@"",
                                           @"phone":[GVUserDefaults  shareInstance].phone?:@"",
                                           @"access_id":[GVUserDefaults  shareInstance].access_id?:@""};
                NSString *result = [userInfo mj_JSONString];
                responseCallback(result);
            }
        }
        if ([action isEqualToString:@"goShare"]) {
            [self shareActionWithJson:jsonDict[@"parameters"]];
        }
        if ([action isEqualToString:@"toAppRegist"]) {
            [AppDelegate toLoginController];
        }
        
        if ([action isEqualToString:@"toAppInvest"]) {
            YYFinanceController *controller = [[YYFinanceController alloc] init];
            [AppDelegate pushVC:controller];
        }
    }];
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.titleView.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    
    if ([url isEqualToString:@"app:login"] || [url isEqualToString:@"applogin"]) {
        [AppDelegate toLoginController];
        return NO;
    }
    
    if ([url containsString:RETURN_URL(@"app_")]) {
        url = [url stringByReplacingOccurrencesOfString:RETURN_URL(@"app_") withString:@"app:"];
    }
    
    if ([url containsString:@"phone/account/lazy_settings"]) {
        [GVUserDefaults shareInstance].isAgreeBook = YES;
        url = @"app:back";
    }
    
    //投资列表
    if ([url containsString:@"appborrow_list"]) {
        url = @"app:borrow_list";
    }
    //充值页面
    if ([url containsString:@"apppay"]) {
        url = @"app:pay";
    }
    //首页
    if ([url containsString:@"apphome"]) {
        url = @"app:home";
    }
    //注册页面
    if ([url containsString:@"appregister"]) {
        url = @"app:register";
    }
    //账户页面
    if ([url containsString:@"appaccount"]) {
        url = @"app:account";
    }
    //投资记录页面
    if ([url containsString:@"appinvestRecord"]) {
        url = @"app:investRecord";
    }
    
    if ([url containsString:@"/mobile/amaze/recash"]) {
        url = @"app:borrow_list";
    }
    
    if ([url containsString:@"/mobile/amaze/product"]) {
        url = @"app:borrow_list";
    }
    return [self webToAppPage:url];
}

- (BOOL)webToAppPage:(NSString *)url {
    if ([url containsString:@"app:"]) {
        if ([url isEqualToString:@"app:borrow_list"]) {
            // 投资列表
            [self toInvest];
            return NO;
        }
        else if ([url isEqualToString:@"app:recordOrder"]) {
            // recordOrder
            [self toTrendOrder];
            return NO;
        }
        else if ([url isEqualToString:@"app:login"]) {
            //登录
            [self toLogin];
            return NO;
        }
        else if ([url isEqualToString:@"app:pay"]) {
            // 充值
            [self toPay];
            return NO;
        }
        else if ([url isEqualToString:@"app:withdrew"]) {
            // 提现
            [self toWithdrew];
            return NO;
        } else if ([url isEqualToString:@"app:home"]) {
            // 首页
            [self toHome];
            return NO;
        } else if ([url isEqualToString:@"app:register"]) {
            // 注册
            [self toRegister];
            return NO;
        } else if ([url isEqualToString:@"app:account"]) {
            // 账户中心
            [self toAccount];
            return NO;
        } else if ([url isEqualToString:@"app:Friend"]) {
            // 邀请好友
            [self toFriendPage];
            return NO;
        } else if ([url isEqualToString:@"app:userReward"]) {
            // 红包券
            [self toUserReward];
            return NO;
        } else if ([url isEqualToString:@"app:ticket"]) {
            // 年化倦
            [self toTicket];
            return NO;
        } else if ([url isEqualToString:@"app:safe"]) {
            // 安全中心
            [self toSafe];
            return NO;
        } else if ([url isEqualToString:@"app:fund"]) {
            // 我的资金
            [self toFund];
            return NO;
        } else if ([url isEqualToString:@"app:banklist"]) {
            // 银行卡列表
            [self toBank];
            return NO;
        } else if ([url isEqualToString:@"app:investRecord"]) {
            // 投资记录
            [self toInvestRecord];
            return NO;
        } else if ([url isEqualToString:@"app:record"]) {
            // 交易记录
            [self toRecord];
            return NO;
        } else if ([url isEqualToString:@"app:gift"]) {
            // 新手大礼包
            [self toGift];
            return NO;
        } else if ([url isEqualToString:@"app:calc"]) {
            // 计算器
            [self toCalc];
            return NO;
        } else if ([url isEqualToString:@"app:email"]) {
            // 绑定邮箱
            [self toBandEmail];
            return NO;
        } else if ([url isEqualToString:@"app:paypwd"]) {
            // 支付密码
            [self toPayPwd];
            return NO;
        } else if ([url isEqualToString:@"app:receivingAddress"]) {
            // 收货地址
            [self toReceivingAddress];
            return NO;
        } else if ([url isEqualToString:@"app:setLoginPwd"]) {
            // 登陆密码
            [self toSetLoginPwd];
            return NO;
        } else if ([url isEqualToString:@"app:openSina"]) {
            // 实名认证
            [self toOpenSina];
            return NO;
        } else if ([url isEqualToString:@"app:myinfo"]) {
            // 我的资料
            [self toMyInfo];
            return NO;
        } else if ([url isEqualToString:@"app:mallhome"]) {
            // 商城首页
            [self toMallHome];
            return NO;
        } else if ([url isEqualToString:@"app:vipHome"]) {
            // VIP首页
            [self toVipHome];
            return NO;
        } else if ([url isEqualToString:@"app:toPointRecrod"]) {
            // 积分
            [self toPointRecrod];
            return NO;
        } else if ([url isEqualToString:@"app:toGrow"]) {
            // 成长值
            [self toGrow];
            return NO;
        } else if ([url isEqualToString:@"app:toSignIn"]) {
            // 签到日历
            [self toSignIn];
            return NO;
        }
        else if ([url isEqualToString:@"app:back"]) {
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}


- (void)shareActionWithJson:(NSString *)json {
    if (kStringIsEmpty(json)) {
        return;
    }
    NSDictionary *jsonDict = [json mj_JSONObject];
    NSString *title = jsonDict[@"title"]?:@"";
    NSString *descr = jsonDict[@"des"]?:@"";
    NSString *thumbURL = jsonDict[@"pic"]?:@"";
    NSString *webpageUrl = jsonDict[@"url"]?:@"";
    kDISPATCH_MAIN_THREAD((^{
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
        
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumbURL];
            shareObject.webpageUrl = webpageUrl;
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[AppDelegate presentingVC] completion:^(id data, NSError *error) {
                if (error) {
                    [QMUITips showInfo:[NSString stringWithFormat:@"分享失败 %@",error.userInfo[@"message"]]];
                    NSLog(@"************分享失败 %@*********",error);
                }else{
                    [QMUITips showSucceed:@"分享成功"];
                    NSLog(@"response data is %@",data);
                }
            }];
        }];
    }));
}

@end
