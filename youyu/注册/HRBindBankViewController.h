//
//  HRRegisterViewController.h
//  hr
//
//  Created by 慧融 on 19/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@interface HRBindBankViewController : QTBaseViewController

/**
 *  银行列表页
 */
@property (nonatomic, strong) UIViewController *controller;
// 是否返回前一页
@property (nonatomic, assign) BOOL isGoBack;

//标志跳转入口
@property (nonatomic, copy) NSString *from;
@end
