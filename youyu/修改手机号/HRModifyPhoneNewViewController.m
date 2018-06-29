//
//  HRModifyPhoneNewViewController.m
//  hr
//
//  Created by 慧融 on 29/08/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRModifyPhoneNewViewController.h"

@interface HRModifyPhoneNewViewController ()
@property (weak, nonatomic)  WTReTextField *tfPhone;

@property (weak, nonatomic)  WTReTextField *tfCode;

@property (weak, nonatomic)  UIButton *btnCode;



@end

@implementation HRModifyPhoneNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"验证新手机号";
    self.navigationItem.rightBarButtonItem = nil;
    
    // Do any additional setup after loading the view.
}

- (void)initUI{
    
    [self initScrollView];
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    
    self.tfPhone = [grid addRowInput:@"新手机号" placeholder:@"请输入新手机号"];
    self.tfCode = [grid addRowCodeText:^(id value) {
        [self clickSendMsg:value];
    }];
    
    [grid addLineForHeight:20];
    [grid addRowButtonTitle:@"提交" click:^(id value) {
        [self clickSubmit];
    }];
    
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData{
    
    [self.tfPhone setPhone];
    self.tfPhone.group = 0;
    
    
    [self.tfCode setValidationCode];
    self.tfCode.group = 1;
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
    
    if (![self.view validation:1]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"phone"] = self.tfPhone.text;
    param[@"valicode"] = self.tfCode.text;
    param [@"type"] = @"1";
    
    
    [self commonJson:param];
}

- (void)commonJson:(NSMutableDictionary *)dic {

    
    [self showHUD:@"正在验证..."];
    [service post:@"user_modifyMoblie" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:@"修改成功" done:^{
            [self loginToAccount];
        }];
    }];
}

- (void)commonJsonSendMsg:(NSString *)phone {
    // 发送验证码
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"type"] = @"1";
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
