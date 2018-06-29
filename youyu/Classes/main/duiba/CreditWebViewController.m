//
//  CreditWebViewController.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditWebViewController.h"
#import "CreditWebView.h"
#import "CreditConstant.h"
#import "QTWebViewController.h"
#import "UIViewController+Share.h"
#import "QTJsonUtil.h"

@interface CreditWebViewController ()<UIWebViewDelegate, JsonUtilDelegate>

@property(nonatomic, strong) NSURLRequest   *request;
@property(nonatomic, strong) CreditWebView  *webView;
@property(nonatomic, strong) NSString       *shareUrl;
@property(nonatomic, strong) NSString       *shareTitle;
@property(nonatomic, strong) NSString       *shareSubtitle;
@property(nonatomic, strong) NSString       *shareThumbnail;

@property(nonatomic, strong) UIBarButtonItem *shareButton;

@property(nonatomic, strong) UIActivityIndicatorView *activity;

@end

static BOOL                     byPresent = NO;
static UINavigationController   *navController;
static NSString                 *originUserAgent;

@implementation CreditWebViewController
{
    QTJsonUtil *service;
}

- (id)initWithUrl:(NSString *)url {
    self = [super init];

    if (url) {
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }

    return self;
}

- (id)initWithUrlByPresent:(NSString *)url {
    self = [self initWithUrl:url];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = leftButton;
    byPresent = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];

    return self;
}

- (id)initWithRequest:(NSURLRequest *)request {
    self = [super init];
    self.request = request;

    return self;
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":originUserAgent}];
}

- (void)viewWillAppear:(BOOL)animated {
    if (originUserAgent == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        originUserAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }

    NSString *ua = [originUserAgent stringByAppendingFormat:@" Duiba/%@", DUIBA_VERSION];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":ua}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;

    service = [QTJsonUtil new];
    service.delegate = self;

    if (!byPresent && (navController == nil)) {
        if ([GVUserDefaults  shareInstance].isLogin) {
            if ([[GVUserDefaults  shareInstance].insign_flg isEqualToString:@"0"]) {
                [self setRightNavItemTitle:@"签到"];
            } else {
                [self setRightNavItemTitle:@"签到日历"];
            }
        }

        navController = self.navigationController;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setRefreshCurrentUrl:) name:@"duiba-autologin-visit" object:nil];

    self.webView = [[CreditWebView alloc]initWithFrame:self.view.bounds andUrl:[[self.request URL] absoluteString]];
    [self.view addSubview:self.webView];

    self.webView.webDelegate = self;

    self.title = @"加载中";

    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];// 指定进度轮的大小
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activity hidesWhenStopped];
    [self.activity setCenter:self.view.center];                                         // 指定进度轮中心点

    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];    // 设置进度轮显示类型
    self.activity.color = [UIColor blackColor];

    [self.view addSubview:self.activity];

    if (self.request) {
        [self.webView loadRequest:self.request];
    } else {
        [self commonJson];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.webView.frame = self.view.bounds;

    if (self.needRefreshUrl != nil) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.needRefreshUrl]]];
        self.needRefreshUrl = nil;
    }
}

- (void)setRefreshCurrentUrl:(NSNotification *)notify {
    if ([notify.userInfo objectForKey:@"webView"] != self.webView) {
        self.needRefreshUrl = self.webView.request.URL.absoluteString;
    }
}

- (void)refreshParentPage:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    if ((navController != nil) && !byPresent) {
        NSInteger   count = navController.viewControllers.count;
        BOOL        containCredit = NO;

        for (int i = 0; i < count; i++) {
            UIViewController *vc = [navController.viewControllers objectAtIndex:i];

            if ([vc isKindOfClass:[CreditWebViewController class]]) {
                containCredit = YES;
                break;
            }
        }

        if (!containCredit) {
            navController = nil;
        }
    }
}

#pragma mark - ui

- (void)setRightNavItemTitle:(NSString *)str {
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];

    self.navigationItem.rightBarButtonItem = itembar;
}

- (void)setRightNavItemImage:(UIImage *)image {
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];

    self.navigationItem.rightBarButtonItem = itembar;
}

#pragma mark WebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('duiba-share-url').getAttribute('content');"];

    if (content.length > 0) {
        NSArray *d = [content componentsSeparatedByString:@"|"];

        if (d.count == 4) {
            self.shareUrl = [d objectAtIndex:0];
            self.shareThumbnail = [d objectAtIndex:1];
            self.shareTitle = [d objectAtIndex:2];
            self.shareSubtitle = @"www.hrcfu.com";

            if (self.shareButton == nil) {
                //                self.shareButton = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(onShareClick)];
            }

            if (self.navigationItem.rightBarButtonItem == nil) {
                // self.navigationItem.rightBarButtonItem = self.shareButton;
            }
        }
    } else {
        if ((self.shareButton != nil) && (self.shareButton == self.navigationItem.rightBarButtonItem)) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }

    [self.activity stopAnimating];
}

- (void)onShareClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:self.shareUrl forKey:@"url"];
    [dict setObject:self.shareThumbnail forKey:@"img"];
    [dict setObject:self.shareTitle forKey:@"title"];
    [dict setObject:self.shareSubtitle forKey:@"content"];

    [self share:dict];
}

- (UINavigationController *)getNavCon {
    if (byPresent) {
        return self.navigationController;
    }

    return navController;
}

#pragma mark 5 activite

- (void)shouldNewOpen:(NSNotification *)notification {
    UIViewController *last = [[self getNavCon].viewControllers lastObject];

    NSString *url = [notification.userInfo objectForKey:@"url"];

    if (![url containsString:@"www.duiba.com.cn"]) {
        QTWebViewController *controller = [QTWebViewController controllerFromXib];
        controller.isNeedLogin = YES;
        controller.url = url;
        [[self getNavCon] pushViewController:controller animated:YES];
    } else {
        CreditWebViewController *newvc = [[CreditWebViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        UIBarButtonItem         *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];

        [last.navigationItem setBackBarButtonItem:backItem];

        [[self getNavCon] pushViewController:newvc animated:YES];
    }
}

- (void)shouldBackRefresh:(NSNotification *)notification {
    NSInteger count = [[self getNavCon].viewControllers count];

    if (count > 1) {
        CreditWebViewController *second = [[self getNavCon].viewControllers objectAtIndex:count - 2];
        second.needRefreshUrl = [notification.userInfo objectForKey:@"url"];
    }

    [[self getNavCon] popViewControllerAnimated:YES];
}

- (void)shouldBack:(NSNotification *)notification {
    [[self getNavCon] popViewControllerAnimated:YES];
}

- (void)shouldBackRoot:(NSNotification *)notification {
    NSInteger               count = [self getNavCon].viewControllers.count;
    CreditWebViewController *rootVC = nil;

    for (int i = 0; i < count; i++) {
        UIViewController *vc = [[self getNavCon].viewControllers objectAtIndex:i];

        if ([vc isKindOfClass:[CreditWebViewController class]]) {
            rootVC = (CreditWebViewController *)vc;
            break;
        }
    }

    if (rootVC != nil) {
        [[self getNavCon] popToViewController:rootVC animated:YES];
    } else {
        [[self getNavCon] popViewControllerAnimated:YES];
    }
}

- (void)shouldBackRootRefresh:(NSNotification *)notification {
    NSInteger               count = [self getNavCon].viewControllers.count;
    CreditWebViewController *rootVC = nil;

    for (int i = 0; i < count; i++) {
        UIViewController *vc = [[self getNavCon].viewControllers objectAtIndex:i];

        if ([vc isKindOfClass:[CreditWebViewController class]]) {
            rootVC = (CreditWebViewController *)vc;
            break;
        }
    }

    if (rootVC != nil) {
        rootVC.needRefreshUrl = [notification.userInfo objectForKey:@"url"];
        [[self getNavCon] popToViewController:rootVC animated:YES];
    } else {
        [[self getNavCon] popViewControllerAnimated:YES];
    }
}

- (void)rightClick {
    if ([GVUserDefaults  shareInstance].isLogin) {
        if ([[GVUserDefaults  shareInstance].insign_flg isEqualToString:@"0"]) {
            [self  puser_insign];
        } else {
            [self  toSignIn];
        }
    }
}

#pragma  mark - json
- (void)puser_insign {
    [self showHUD];
    [service post:@"puser_insign" data:nil complete:^(NSDictionary *value) {
        [self hideHUD];
        [GVUserDefaults  shareInstance].insign_flg = @"1";
        NSString *tip = [NSString stringWithFormat:@"成长值+%@，您连续签到%@天，明日签到即可获得%@", value.str(@"growth_value"), value.str(@"insign_days"), value.str(@"tomorrow_growth")];
        [self showToast:tip duration:3 done:^{
            [self setRightNavItemTitle:@"签到日历"];
            [self toSignIn];
        }];
    }];
}

- (void)commonJson {
    [self showHUD];
    [service post:@"duiBa_url" data:nil complete:^(NSDictionary *value) {
        [self hideHUD];
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:value.str(@"url")]];
        [self.webView loadRequest:self.request];
    }];
}

#pragma  mark - jsondelegate

- (void)jsonFailureTimeout {
    [self hideHUD];
    [self showToast:NETERROR duration:3];
}

- (void)jsonFailure:(NSDictionary *)dic {
    [self hideHUD];
    [dic handleError];
    /*
    if ([dic isKindOfClass:[NSDictionary class]]) {
        // 后台错误提示
        NSInteger code = [dic code];
        NSLog(@"错误代码 --------------------------------------  %ld", (long)code);

        // 重新登录
        if ((code == 110025) || (code == 110026) || (code == 110019)) {
            NSString *errorTip = @"";

            if ((code == 110025) || (code == 110019)) {
                // 被踢了
                errorTip = LOGINOTHERTIP;
            } else if (code == 110026) {
                // 超时
                errorTip = UNLOGINTIP;
            }

            [GVUserDefaults shareInstance].isLogin = NO;
            self.tabBarController.tabBar.userInteractionEnabled = NO;
            [self showToast:errorTip done:^{
                [self loginTimeout];
                self.tabBarController.tabBar.userInteractionEnabled = YES;
            }];
            return;
        }

        NSString *msg = [dic msg];

        if (msg.length > 0) {
            [self showToast:msg];
        }
    } else {
        // 本地错误提示
        [self showToast:NETERROR duration:2];
    }
     */
}

- (void)netFailure {
    [self hideHUD];
    [self showMeg:NETTIP];
}

@end
