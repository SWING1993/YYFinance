//
//  QTBandEmailViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBandEmailViewController.h"
#import "DFormAdd.h"

@interface QTBandEmailViewController ()

@property (strong, nonatomic)  WTReTextField *tfEmail;

@end

@implementation QTBandEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![GVUserDefaults  shareInstance].email_status) {
        self.titleView.title = @"绑定邮箱";
    } else if ([GVUserDefaults  shareInstance].email_status) {
        self.titleView.title = @"修改邮箱";
    }

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfEmail = [grid addRowInput:@"邮箱" placeholder:@"请输入邮箱"];

    [grid addLineForHeight:20];

    [grid addRowButtonTitle:@"提交" click:^(id value) {
        [self clickSumbit];
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.tfEmail.text = [GVUserDefaults  shareInstance].email;

    [self.tfEmail setEmail];
    self.tfEmail.group = 0;
}

#pragma  mark - event
- (void)clickSumbit {
    [self.view endEditing:YES];
    
    if (![self.view validation:0]) {
        return;
    }

    [self commonJson];
}

#pragma  mark - json
- (void)commonJson {
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"email"] = self.tfEmail.text;

    [service post:@"email_binding" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [GVUserDefaults  shareInstance].email_status = @"0";
        [GVUserDefaults  shareInstance].email = dic[@"email"];
        [self showToast:@"绑定邮箱成功，请去邮箱激活" done:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
