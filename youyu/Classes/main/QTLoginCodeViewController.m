//
//  QTLoginCodeViewController.m
//  qtyd
//
//  Created by stephendsw on 2016/11/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTLoginCodeViewController.h"

@interface QTLoginCodeViewController ()

@property (weak, nonatomic)  WTReTextField *tfcode;

@end

@implementation QTLoginCodeViewController
{}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"短信验证";
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfcode = [grid addRowCodeText:^(id value) {
            [self commonJson];
        }];

    [grid addLineForHeight:20];

    [grid addRowButtonTitle:@"提交" click:^(id value) {
        if (self.tfcode.text.length == 0) {
            [self showToast:@"请输入验证码"];
        } else {
            [self.delegate loinWithCode:self.tfcode.text];
        }
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.tfcode setValidationCode];
}

- (void)commonJson {
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = self.phone;
    dic[@"sms_type"] = @"device";
    dic[@"trackid"] = TRACKID;

    [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:MSGTIP];
    }];
}

@end
