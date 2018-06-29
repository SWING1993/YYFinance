//
//  HRModifyPhoneOldViewController.m
//  hr
//
//  Created by 慧融 on 29/08/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRModifyPhoneOldViewController.h"
#import "HRModifyPhoneNewViewController.h"
#import "DFormAdd.h"

@interface HRModifyPhoneOldViewController ()
@property (weak, nonatomic)  WTReTextField *tfPhone;

@property (weak, nonatomic)  WTReTextField *tfCode;

@property (weak, nonatomic)  UIButton *btnCode;

@end


@implementation HRModifyPhoneOldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"验证原手机号";
    self.navigationItem.rightBarButtonItem = nil;
    
    // Do any additional setup after loading the view.
}

- (void)initUI{

    [self initScrollView];
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    
    self.tfPhone = [grid addRowInput:@"原手机号" placeholder:@"请输入注册手机号"];
    self.tfCode = [grid addRowCodeText:^(id value) {
        [self clickSendMsg:value];
    }];
    
    [grid addLineForHeight:20];
    [grid addRowButtonTitle:@"下一步" click:^(id value) {
        [self clickSubmit];
    }];
    
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData{

    self.tfPhone.text = [GVUserDefaults shareInstance].phone;
    self.tfPhone.enabled = NO;
    
    [self.tfCode setValidationCode];
    self.tfCode.group = 0;
}

#pragma  mark - event

- (void)clickSendMsg:(id)value {
    self.btnCode = value;
    [self.view endEditing:YES];
    self.btnCode.enabled = NO;
    [self commonJsonSendMsg:self.tfPhone.text];
}

- (void)clickSubmit {
    [self.view endEditing:YES];
    
    if (![self.view validation:0]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"phone"] = self.tfPhone.text;
    param[@"valicode"] = self.tfCode.text;
    param[@"type"] = @"0";
    
    
    [self commonJson:param];
}

- (void)commonJson:(NSMutableDictionary *)dic {
    // 验证老手机号
    [self showHUD:@"正在验证..."];
    [service post:@"user_modifyMoblie" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        HRModifyPhoneNewViewController *newVC = [HRModifyPhoneNewViewController new];
        [self.navigationController pushViewController:newVC animated:YES];
    }];
}



- (void)commonJsonSendMsg:(NSString *)phone {
    // 发送验证码
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    dic[@"sms_type"] = @"user_phone";
    dic[@"trackid"] = TRACKID;
    
    [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:MSGTIP];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
