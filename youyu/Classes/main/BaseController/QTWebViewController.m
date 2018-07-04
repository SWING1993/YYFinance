//
//  QTActivityDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 15/8/4.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTWebViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "MJRefresh.h"
#import "QTBaseViewController+Activity.h"
#import "UIViewController+Share.h"
#import "YYFinanceController.h"
#import <UShareUI/UShareUI.h>

@implementation NativeAPIs

- (void)target:(NSString *)info {
    kDISPATCH_MAIN_THREAD(^{
        if ([info isEqualToString:@"appRegist"]) {
            [AppDelegate toLoginController];
        } else if ([info isEqualToString:@"appInvest"]) {
            YYFinanceController *controller = [[YYFinanceController alloc] init];
            [AppDelegate pushVC:controller];
        }
    });
}
- (NSString *)getUserInfo {
    NSDictionary *userInfo = @{@"user_id":[GVUserDefaults  shareInstance].user_id?:@"",
                               @"phone":[GVUserDefaults  shareInstance].phone?:@"",
                               @"access_id":[GVUserDefaults  shareInstance].access_id?:@""};
    NSString *result = [userInfo mj_JSONString];
    return result;
}

- (void)goShare:(NSString *)json {
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
                    [QMUITips showInfo:@"分享失败"];
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
        }];
    }));
    
}

@end

@interface QTWebViewController ()<IMYWebViewDelegate>

@end

@implementation QTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)rightClick {
    ShareModel *obj = [ShareModel new];
    obj.title = @"有余金服";
    obj.url = self.url;
    obj.content = self.shareContent;
    obj.img = @"code";
    [self umShare:obj];
}

- (void)initUI {
    if (!self.webView) {
        if (self.cutHeight > 0) {
            self.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.cutHeight) usingUIWebView:YES];
        } else {
            self.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - APP_NAVHEIGHT) usingUIWebView:YES];
        }
    }
    
//    MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadData];
//    }];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    self.webView.scrollView.mj_header = header;
    
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)initData {
    [self loadData];
}

- (BOOL)navigationShouldPopOnBackButton {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return NO;
    } else {
        return YES;
    }
}

- (void)loadData {
    [self.webView.scrollView.mj_header endRefreshing];
    if (!kStringIsEmpty(self.url)) {
        NSMutableDictionary *dicPara = [NSMutableDictionary dictionary];
        if (self.isNeedLogin) {
            if ([GVUserDefaults shareInstance].isLogin) {
                dicPara[@"redis_key"] = [GVUserDefaults  shareInstance].redis_key;
            }
        }
        if ([self.url containsString:@"pay.sina.com.cn"]) {
            NSURL *url = [NSURL URLWithString:self.url];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
            [request addValue:@"https://www.hrcfu.com/mine" forHTTPHeaderField:@"Referer"];
            [self.webView loadRequest:request];
        } else {
            dicPara[@"device_port"] = @"ios";
            NSString *qturl = [self.url urlAddParameter:dicPara];
            NSURL *url = [NSURL URLWithString:[qturl getEncodeUrl]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
            [self.webView loadRequest:request];
        }
    } else if (self.htmlContent) {
        [self.webView loadHTMLString:self.htmlContent baseURL:nil];
    }
}

#pragma mark -delegate

- (void)webViewDidStartLoad:(IMYWebView *)webView {
    [self loadNativeAPIs];
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    self.webView.scalesPageToFit = self.isScale;
    [self.webView.scrollView setContentSize:CGSizeMake(0, self.webView.scrollView.contentSize.height)];
    [self loadNativeAPIs];
}

- (void)loadNativeAPIs {
    NativeAPIs *model  = [[NativeAPIs alloc] init];
    [self.webView.jsContext setObject:model forKeyedSubscript:@"app"];
    [self.webView evaluateJavaScript:@"app" completionHandler:^(id objc, NSError *error) {
        
    }];
    self.webView.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    JSValue *value = [self.webView.jsContext evaluateScript:@"document.title"];
    self.titleView.title = value.toString;
}

- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    
    if ([url isEqualToString:@"app:login"]) {
        // 登陆
        [self loginedAction:^{
            NSString *href = self.url;
            NSMutableDictionary *dicPara = [NSMutableDictionary new];
            dicPara[@"redis_key"] = [GVUserDefaults  shareInstance].redis_key;
            href = [href urlAddParameter:dicPara];
            self.url = href;
            [self loadData];
        }];
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
    
    //登录页面
    if([url containsString:@"applogin"]) {
        [self loginedAction:^{
            NSString *href = self.url;
            NSMutableDictionary *dicPara = [NSMutableDictionary new];
            dicPara[@"redis_key"] = [GVUserDefaults  shareInstance].redis_key;
            href = [href urlAddParameter:dicPara];
            self.url = href;
            [self.webView removeFromSuperview];
            self.webView = nil;
            [self initUI];
            [self loadData];
        }];
        return NO;
    }

    return [self webToAppPage:url];
}

@end
