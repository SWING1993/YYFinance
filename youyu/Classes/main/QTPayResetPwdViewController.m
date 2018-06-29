//
//  QTPayResetPwdViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTPayResetPwdViewController.h"
#import "DFormAdd.h"
#import "QTInvestDetailViewController.h"
#import "QTSafeViewController.h"

@interface QTPayResetPwdViewController ()

@property (weak, nonatomic)  WTReTextField *tfValidCode;

@property (weak, nonatomic)  UIButton *btnSendSms;

@property (strong, nonatomic)  WTReTextField *tfPwd;

@property (strong, nonatomic)  WTReTextField *tfRePwd;

@property (strong, nonatomic)  UIButton *btnSubmit;

@end

@implementation QTPayResetPwdViewController

- (void)viewDidLoad {
    if ([GVUserDefaults  shareInstance].paypwd_status == 1) {
        self.titleView.title = @"修改支付密码";
    } else {
        self.titleView.title = @"设置支付密码";
    }

    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"payPwdView"];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"payPwdView"];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)navigationShouldPopOnBackButton {
    if (self.isToHome) {
        [self toHome];
        return NO;
    }
    
    if (self.isToInvestDetail) {
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QTInvestDetailViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return NO;

            }
        }
        [self toAccount];
        return NO;
    }
    
    if (self.isToAccount) {
        [self toAccount];
        return NO;
    }
    
    if (self.isToSafeCenter) {
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[QTSafeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return NO;
            }
        }
        [self toAccount];
        return NO;
    }
    return YES;
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfValidCode = [grid addRowCodeText:^(id value) {
            [self clickSendMsg:value];
        }];
    [grid addView:grid margin:UIEdgeInsetsZero];
    [grid addLineForHeight:20];

    self.tfPwd = [grid addRowInput:@"新密码" placeholder:@"6-24位字符，区分大小写"];
    self.tfRePwd = [grid addRowInput:@"确认密码" placeholder:@"6-24位字符，区分大小写"];

    [grid addLineForHeight:20];
    self.btnSubmit = [grid addRowButtonTitle:@"提交" click:^(id value) {
            [self clickSubmit];
        }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];

    [self.btnSendSms click:^(id value) {
        [self.view endEditing:YES];
        self.btnSendSms.enabled = NO;

        [self commonJsonSendMsg];
    }];
}

- (void)initData {
    [self.tfValidCode setValidationCode];
    self.tfValidCode.group = 0;

    [self.tfPwd setPwd];
    self.tfPwd.group = 0;
    self.tfPwd.errorTip = @"支付密码应为6-24位字符";
    self.tfPwd.nilTip = @"请输入支付密码";

    [self.tfRePwd setPwd];
    self.tfRePwd.group = 0;
    self.tfRePwd.errorTip = @"确认支付密码应为6-24位字符";
    self.tfRePwd.nilTip = @"请输入确认支付密码";
}

#pragma  mark - event

- (void)clickSendMsg:(id)value {
    self.btnSendSms = value;
    [self.view endEditing:YES];
    self.btnSendSms.enabled = NO;

    [self commonJsonSendMsg];
}

- (void)clickSubmit {
    [self.view endEditing:YES];

    if (![self.view validation:0]) {
        self.btnSendSms.enabled = YES;
        return;
    }

    NSString    *pwd = [self.tfPwd.text stringValue];
    NSString    *repwd = [self.tfRePwd.text stringValue];

    if (![pwd isEqualToString:repwd]) {
        [self showToast:@"两次密码输入不一致"];
        return;
    }

    [self commonJson];
}

#pragma  mark - json
- (void)commonJsonSendMsg {
    // 发送验证码
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"phone"] = [GVUserDefaults  shareInstance].phone;
    dic[@"sms_type"] = @"forget_paypassword";
    dic[@"trackid"] = TRACKID;

    [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:MSGTIP];
    }];
}

- (void)commonJson {
    // 修改密码
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"valicode"] = self.tfValidCode.text;
    dic[@"password"] = [self.tfPwd.text enValue];
    dic[@"repassword"] = [self.tfRePwd.text enValue];

    [service post:@"user_uppaypwd" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        NSString *tip=@"";
        if ([GVUserDefaults  shareInstance].paypwd_status == 1) {
            tip = @"修改成功";
        } else {
            [MobClick event:@"payPwdBt"];
            tip = @"设置成功";
        }
        [GVUserDefaults  shareInstance].paypwd_status = 1;
        [self showToast:tip done:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)jsonFailure:(NSDictionary *)dic {
    [super jsonFailure:dic];
    self.btnSendSms.enabled = YES;
}

@end
