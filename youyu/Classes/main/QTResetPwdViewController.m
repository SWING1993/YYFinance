//
//  QTResetPwdViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTResetPwdViewController.h"
#import "DFormAdd.h"

@interface QTResetPwdViewController ()

@property (weak, nonatomic)  WTReTextField *tfPhone;

@property (weak, nonatomic)  WTReTextField *tfCode;

@property (weak, nonatomic)  UIButton *btnCode;

@property (weak, nonatomic)  WTReTextField *tfPwd;

@property (weak, nonatomic)  WTReTextField *tfRepwd;

@end

@implementation QTResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"忘记密码";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfPhone = [grid addRowInput:@"手机号" placeholder:@"请输入注册手机号"];

    self.tfCode = [grid addRowCodeText:^(id value) {
            [self clickSendMsg:value];
        }];

    self.tfPwd = [grid addRowInput:@"新密码" placeholder:@"6-24位字符，区分大小写"];

    self.tfRepwd = [grid addRowInput:@"确认密码" placeholder:@"6-24位字符，区分大小写"];

    [grid addLineForHeight:20];

    [grid addRowButtonTitle:@"提交" click:^(id value) {
        [self clickSubmit];
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.tfPhone setPhone];
    self.tfPhone.group = 0;

    [self.tfCode setValidationCode];
    self.tfCode.group = 1;

    [self.tfPwd setPwd];
    self.tfPwd.group = 1;

    [self.tfRepwd setPwd];
    self.tfRepwd.group = 1;

    self.tfRepwd.errorTip = @"确认密码应为6-24位字符";
    self.tfRepwd.nilTip = @"请输入确认密码";
}

#pragma  mark - event

- (void)clickSendMsg:(id)value {
    self.btnCode = value;
    [self.view endEditing:YES];

    if (![self.view validation:0]) {
        self.btnCode.enabled = YES;
        return;
    }

    self.btnCode.enabled = NO;
    [self commonJsonSendMsg:self.tfPhone.text];
}

- (void)clickSubmit {
    [self.view endEditing:YES];

    if (![self.view validation:0]) {
        return;
    }

    if (![self.view validation:1]) {
        return;
    }

    if (![self.tfPwd.text isEqualToString:self.tfRepwd.text]) {
        [self showToast:@"两次密码输入不一致"];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"phone"] = self.tfPhone.text;
    param[@"valicode"] = self.tfCode.text;
    param[@"password"] = [self.tfPwd.text enValue];     // 加密
    param[@"repassword"] = [self.tfRepwd.text enValue]; // 加密

    [self commonJson:param];
}

#pragma  mark - json
- (void)commonJsonSendMsg:(NSString *)phone {
    // 发送验证码
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    dic[@"sms_type"] = @"forget_password";
    dic[@"trackid"] = TRACKID;

    [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:MSGTIP];
    }];
}

- (void)commonJson:(NSMutableDictionary *)dic {
    // 找回密码
    [self showHUD:@"正在提交..."];
    [service post:@"user_fgtpwd" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:@"找回密码成功" done:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)jsonFailure:(NSDictionary *)dic {
    [super jsonFailure:dic];
    self.btnCode.enabled = YES;
}

@end
