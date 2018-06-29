//
//  HRSetPayPwdViewController.m
//  hr
//
//  Created by 慧融 on 20/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRSetPayPwdViewController.h"
#import "DAlertViewController+attributeString.h"

@interface HRSetPayPwdViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tintLabel;

@property (weak, nonatomic)  WTReTextField *tfValidCode;

@property (weak, nonatomic)  UIButton *btnSendSms;

@property (strong ,nonatomic) WTReTextField *tfPayPwd;
@property (strong ,nonatomic) WTReTextField *tfSecondPayPwd;

@end

@implementation HRSetPayPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"完善资料";
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"暂不认证" style:UIBarButtonItemStyleDone target:self action:@selector(gotoHome)];
    self.navigationItem.rightBarButtonItem = rightBar;
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI{
    [self initScrollView];
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
//    [grid addView:self.headImage margin:UIEdgeInsetsMake(0, -20, 30, -20)];
    
    [grid addView:self.titleLabel margin:UIEdgeInsetsMake(30, 0, 30, 0)];
    self.tfValidCode = [grid addRowCodeTextNoTitle:^(id value) {
        [self clickSendMsg:value];
    }];
    [grid addLineForHeight:7.5];
    self.tfPayPwd = [grid addRowInputWithplaceholderRoundRect:@"设置支付密码"];
    [grid addLineForHeight:7.5];
    self.tfSecondPayPwd = [grid addRowInputWithplaceholderRoundRect:@"确认支付密码"];
    
    
    
    [grid addLineForHeight:145.5];
    [grid addSubmitButtonTitle:@"完善成功" click:^(id value) {
        NSLog(@"完善成功");
        [self  clickSubmit];
    }];
    

    [grid addView:self.tintLabel margin:UIEdgeInsetsZero];
    
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
    
    [self.btnSendSms click:^(id value) {
        [self.view endEditing:YES];
        self.btnSendSms.enabled = NO;
        
        [self commonJsonSendMsg];
    }];
    
}

- (void)gotoHome{
    DAlertViewController *alertVC = [DAlertViewController alertControllerWithTitle:@"提示" message:@"未完善资料无法进行投资是否继续认证"];
    
    
    [alertVC addActionWithTitle:@"暂不认证" handler:^(CKAlertAction *action) {
        [self toHome];
    }];
    
    [alertVC addActionWithTitle:@"继续认证" handler:^(CKAlertAction *action) {
        [alertVC showDisappearAnimation];
    }];
    
    [alertVC show];
    [alertVC setButtonTitleColor];
}

- (void)initData{
    
    [self.tfValidCode setValidationCode];
    self.tfValidCode.group = 0;

    [self.tfPayPwd setPwd];
    self.tfPayPwd.group = 0;
    self.tfPayPwd.errorTip = @"支付密码应为6-24位字符";
    self.tfPayPwd.nilTip = @"请输入支付密码";
    
    [self.tfSecondPayPwd setPwd];
    self.tfSecondPayPwd.group = 0;
    self.tfSecondPayPwd.errorTip = @"确认支付密码应为6-24位字符";
    self.tfSecondPayPwd.nilTip = @"请输入确认支付密码";

}

#pragma  mark - event

- (void)clickSendMsg:(id)value {
    self.btnSendSms = value;
    [self.view endEditing:YES];
    self.btnSendSms.enabled = NO;
    
    [self commonJsonSendMsg];
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

- (void)clickSubmit {
    [self.view endEditing:YES];
    
    if (![self.view validation:0]) {
        return;
    }
    
    NSString    *pwd = [self.tfPayPwd.text stringValue];
    NSString    *repwd = [self.tfSecondPayPwd.text stringValue];
    
    if (![pwd isEqualToString:repwd]) {
        [self showToast:@"两次密码输入不一致"];
        return;
    }
    
    [self commonJson];
}

#pragma  mark - json
- (void)commonJson {
    // 修改密码
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"valicode"] = self.tfValidCode.text;
    dic[@"password"] = [self.tfPayPwd.text enValue];
    dic[@"repassword"] = [self.tfSecondPayPwd.text enValue];
    
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}

- (void)jsonFailure:(NSDictionary *)dic {
    [super jsonFailure:dic];
//    self.btnSendSms.enabled = YES;
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
