//
//  QTBaseViewController.h
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+model.h"
#import "NSDictionary+ServerInfo.h"
#import "GVUserDefaults.h"

#import "QTJsonUtil.h"
#import "QTJsonUtil+Login.h"

#import "UIViewController+page.h"
#import "UIViewController+menu.h"
#import "UIViewController+toast.h"
#import "UIViewController+BackButtonHandler.h"
#import "QTTheme.h"

#import "SystemConfigDefaults.h"
#import "AppDelegate.h"
#import "BaseViewController.h"


#define WEAKSELF __weak typeof(self) weakSelf = self


@interface QTBaseViewController : BaseViewController<JsonUtilDelegate>
{
    QTJsonUtil *service;
    NSDictionary *jsonDic;
}

@property (nonatomic, assign) BOOL canRefresh;

// 关闭应用后是否需要手势密码，默认NO
@property (nonatomic, assign) BOOL isLockPage;

- (void)setRefreshScrollView;

- (void)autoInputNext;


#pragma mark - init
- (void)initUI;

- (void)initData;

- (void)initScrollView;

#pragma mark - ui

- (void)setRightNavItemTitle:(NSString *)str;

- (void)setRightNavItemImage:(UIImage *)image;

- (void)rightClick;

#pragma mark -resfresh
- (void)scrollViewRrefresh;

#pragma mark - json
- (void)commonJson;

/**
 *  首次加载页面请求数据
 */
- (void)firstGetData;



@end
