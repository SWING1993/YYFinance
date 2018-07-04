//
//  QTActivityDetailViewController.h
//  qtyd
//
//  Created by stephendsw on 15/8/4.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMYWebView.h"
#import "QTBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol NativeApisProtocol <JSExport>

- (void)target:(NSString *)info;

- (void)goShare:(NSString *)json;

- (NSString *)getUserInfo;

@end

@interface NativeAPIs : NSObject <NativeApisProtocol>

@property(weak, nonatomic) JSContext *jsContext;

@end

@interface QTWebViewController : QTBaseViewController

@property (strong, nonatomic)  IMYWebView *webView;

- (void)loadData;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *htmlContent;

@property (nonatomic, assign) BOOL isScale;

@property (nonatomic, assign) BOOL isNeedLogin;

@property (nonatomic, assign) BOOL showShareBtn;

//@property (nonatomic , assign) BOOL backAccount;
//@property (nonatomic , assign) BOOL backInvest;

@property (nonatomic,copy) NSString *shareContent;

@property (nonatomic,assign) CGFloat cutHeight;//视图需要减少的高度

@end
