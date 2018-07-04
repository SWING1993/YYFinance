//
//  QTChangePwdViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTChangePwdViewController.h"

@interface QTChangePwdViewController ()

@property (weak, nonatomic)  WTReTextField *tfOldPwd;

@property (weak, nonatomic)  WTReTextField *tfPwd;

@property (weak, nonatomic)  WTReTextField *tfRePwd;

@end

@implementation QTChangePwdViewController

- (void)viewDidLoad {
    self.titleView.title = @"修改登录密码";

    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfOldPwd = [grid addRowInput:@"原密码" placeholder:@"请输入原密码"];

    [grid addLineForHeight:20];

    self.tfPwd = [grid addRowInput:@"新密码" placeholder:@"6-24位字符，区分大小写"];
    self.tfRePwd = [grid addRowInput:@"确认密码" placeholder:@"6-24位字符，区分大小写"];
    [grid addLineForHeight:20];

    [grid addRowButtonTitle:@"提交" click:^(id value) {
        [self clickSumbit];
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.tfOldPwd setPwd];
    self.tfOldPwd.errorTip = @"旧密码应为6-24位字符";
    self.tfOldPwd.nilTip = @"请输入旧密码";
    self.tfOldPwd.group = 0;

    [self.tfPwd setPwd];
    self.tfPwd.errorTip = @"新密码应为6-24位字符";
    self.tfPwd.nilTip = @"请输入新密码";
    self.tfPwd.group = 0;

    [self.tfRePwd setPwd];
    self.tfRePwd.errorTip = @"确认密码应为6-24位字符";
    self.tfRePwd.nilTip = @"请输入确认密码";
    self.tfRePwd.group = 0;
}

#pragma  mark - event
- (void)clickSumbit {
    [self.view endEditing:YES];

    if (![[self.tfPwd.text stringValue] isEqualToString:[self.tfRePwd.text stringValue]]) {
        [self showToast:@"两次密码输入不一致"];
        return;
    }

    if (![self.view validation:0]) {
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"old_password"] = [self.tfOldPwd.text enValue];
    param[@"password"] = [self.tfPwd.text enValue];
    param[@"repassword"] = [self.tfRePwd.text enValue];

    [self commonJson:param];
}

#pragma  mark - json
- (void)commonJson:(NSMutableDictionary *)dic {
    // 修改密码
    [self showHUD:@"正在提交..."];
    [service post:@"user_uppwd" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [GVUserDefaults  shareInstance].pswDes = [self.tfPwd.text desEncryptkey:deskey];

        [self showToast:@"修改密码成功" done:^{
            [self relogin];
        }];
    }];
}

@end
