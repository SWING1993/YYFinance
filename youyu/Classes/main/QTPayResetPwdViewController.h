//
//  QTPayResetPwdViewController.h
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@interface QTPayResetPwdViewController : QTBaseViewController
//标志是否跳回投资详情页
@property (nonatomic,assign) BOOL isToInvestDetail;

//标志是否跳回主页面
@property (nonatomic,assign) BOOL isToHome;

//标志是否跳回账户页面
@property (nonatomic,assign) BOOL isToAccount;

//标志是否跳回安全中心页面
@property (nonatomic,assign) BOOL isToSafeCenter;
@end
