//
//  HRLoginPwdViewController.h
//  hr
//
//  Created by 慧融 on 19/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

typedef void(^popActionBlock)();

@interface HRLoginPwdViewController : QTBaseViewController
@property (nonatomic ,strong) NSString *phone;

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
