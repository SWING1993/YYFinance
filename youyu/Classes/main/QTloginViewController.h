//
//  QTloginViewController.h
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTBaseViewController.h"

typedef void (^ popActionBlock)();

@interface QTloginViewController : QTBaseViewController

/**
 *  操作完成后执行
 *
 */
- (void)backAction:(popActionBlock)block;

/**
 *  返回键是否返回首页 ，默认返回上一页
 */
@property (nonatomic, assign) BOOL isBackHome;



/**
 *  登陆后是否返回账户页，默认登陆完返回上一页
 */
@property (nonatomic, assign) BOOL isLoginedToAccout;


@property (nonatomic, assign) BOOL isBackToSecondPage;

@property (nonatomic, assign) BOOL backDeviceLock;

@end
