//
//  HRRegisterViewController.m
//  hr
//
//  Created by 慧融 on 19/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import "HRRegisterViewController.h"
#import "QTWebViewController.h"
#import "HRBindBankViewController.h"
#import "HRRegisterSuccessViewController.h"


@interface HRRegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *regView;
@property (weak, nonatomic) IBOutlet UIButton *regButton;
@property (strong, nonatomic) IBOutlet UILabel *tintLabel;
@property (strong, nonatomic) IBOutlet UIButton *protoclButton;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *registerLoginBt;
@property (weak, nonatomic)  TimeCodeButton *btnCode;

@property (strong, nonatomic) WTReTextField *tfVerifyCode;
@property (strong, nonatomic) WTReTextField *tfPwd;
@property (strong, nonatomic) WTReTextField *tfInviteUserPhone;
@property (strong, nonatomic) IBOutlet UILabel *investUserTotalLabel;


@end

@implementation HRRegisterViewController{

    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"设置密码";
    self.navigationItem.rightBarButtonItem = nil;
    self.tfInviteUserPhone.delegate = self;
    [self.tfInviteUserPhone addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    label = [UILabel labelContentPreView:self.tfInviteUserPhone];
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI{

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    [grid addView:self.headImage margin:UIEdgeInsetsMake(50, 30, 10, 30)];
    
    
//    NSInteger register_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"register_total"];
//    NSString *investTotalStr = [NSString stringWithFormat:@"现在已有%ld人与您一起放心理财",register_total];
//    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:investTotalStr];
//    for (int i = 0; i<= investTotalStr.length; i++) {
//        NSString *a = [investTotalStr substringWithRange:NSMakeRange(i, 1)];
//        if ([NSString isPureInt:a]) {
//            [strAttr setAttributes:@{NSForegroundColorAttributeName:MainColor} range:NSMakeRange(i, 1)];
//        }
//    }

//    self.investUserTotalLabel.attributedText = strAttr;
//    [grid addView:self.investUserTotalLabel margin:UIEdgeInsetsMake(0, 0, 34.5, 0)];

    [grid addLineForHeight:20];
    self.tfVerifyCode = [grid addRowCodeTextNoTitle:^(id value) {
        [self clickSendMsg:value];
    }];
    [self.tfVerifyCode setLeftImage:@"YY_codeLeft"];
    [grid addLineForHeight:10];
    self.tfPwd = [grid addRowInputWithplaceholderRoundRect:@"请确认登录密码"];
    [grid addLineForHeight:10];
    self.tfInviteUserPhone = [grid addRowInputWithplaceholderRoundRect:@"邀请人手机号码(选填)"];
    [grid addLineForHeight:52.5];
    
    self.regView.backgroundColor = Theme.backgroundColor;
    [grid addView:self.regView margin:UIEdgeInsetsZero];
    
    [self.registerLoginBt addTapGesture:^{
        [self toLogin];
    }];
    
    [grid addView:self.protoclButton margin:UIEdgeInsetsMake(11.5, 0, 19, 0)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.protoclButton.titleLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:Theme.darkBlueColor range:NSMakeRange(4, 11)];
    [str addAttribute:NSForegroundColorAttributeName value:Theme.darkGrayColor range:NSMakeRange(0, 4)];
    self.protoclButton.selected = YES;
    [self.protoclButton click:^(id value) {
        if (self.protoclButton.selected) {
            self.protoclButton.selected = NO;
        } else {
            self.protoclButton.selected = YES;
        }
    }];
    __weak HRRegisterViewController *weakSelf=self;
    [self.protoclButton.titleLabel addTapGesture:^{
        __strong HRRegisterViewController *strongSelf =weakSelf;
        QTWebViewController *controller = [[QTWebViewController alloc]init];
        controller.url = URL_REG_PROTOCOL;
        controller.titleView.title = @"有余金服服务协议";
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.protoclButton setImage:[UIImage imageNamed:@"icon_login_select"] forState:UIControlStateSelected];
    [self.protoclButton setImage:[UIImage imageNamed:@"icon_login_unselect"] forState:UIControlStateNormal];
    [self.protoclButton setAttributedTitle:str forState:UIControlStateNormal];
    
    
    [grid addSubmitButtonTitle:@"注册" click:^(id value) {
        NSLog(@"注册事件");
        [self clickSubmit];
//        HRBindBankViewController *controller = [HRBindBankViewController controllerFromXib];
//        [self.navigationController pushViewController:controller animated:YES];

    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
    
    
}

- (void)initData{

    [self.tfVerifyCode setValidationCode];
    self.tfVerifyCode.group = 1;
    
    [self.tfPwd setPwd];
    self.tfPwd.group = 1;
    
    [self.tfInviteUserPhone setPhone];
    self.tfInviteUserPhone.group = 1;
    self.tfInviteUserPhone.isNeed = NO;
    self.tfInviteUserPhone.errorTip = @"邀请人手机格式错误";
    
}


- (void)textFieldEditingChanged:(UITextField*)textField{
    label.text = [NSString phoneFormat:textField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    label.text = [NSString phoneFormat:textField.text];
    [self.scrollview addSubview:label];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [label removeFromSuperview];
}

#pragma  mark - event

// 发送验证码
- (void)clickSendMsg:(id)value {
    self.btnCode = value;
    
    if (![self.view validation:0]) {
        self.btnCode.enabled = YES;
        return;
    }
    
    [self.view endEditing:YES];
    
    self.btnCode.enabled = NO;
    
    [self commonJsonSendMsg:_phone];
}

// 注册
- (void)clickSubmit {
    if (![self.view validation:0]) {
        return;
    }
    
    if (![self.view validation:1]) {
        return;
    }
    
    if (!self.protoclButton.selected) {
        [self showToast:@"请勾选同意有余金服服务协议"];
        return;
    }
    
    [self.view endEditing:YES];
    [self commonJson];
}

#pragma  mark - json

- (void)commonJsonSendMsg:(NSString *)phone {
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"phone"] = phone;
    dic[@"sms_type"] = @"registered";
    dic[@"trackid"] = TRACKID;
    
    // 如果出现发送错误，需要禁止按钮的倒计时
    [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:MSGTIP duration:3];
    }];
}

- (void)jsonFailure:(NSDictionary *)dic {
    [super jsonFailure:dic];
    self.btnCode.enabled = YES;
}

-(void)sendIDFAToServer{
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    dic[@"idfa"] = [AppUtil getAPPIDFA];
    dic[@"type"] = @"1";
    dic[@"username"] = self.phone;
    [service post:@"syscfg_oMyGreen" data:dic complete:^(id value) {
    }];
}

- (void)commonJson {
    [self showHUD:@"正在注册..."];
    NSString            *password = [self.tfPwd.text stringValue];
    NSString            *validCode = [self.tfVerifyCode.text stringValue];
    NSString            *inviteUser = [self.tfInviteUserPhone.text stringValue];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"invite_user"] = inviteUser;
    dic[@"phone"] = _phone;
    dic[@"password"] = [password desEncryptkey:deskey];
    dic[@"repassword"] = [password desEncryptkey:deskey];
    dic[@"valicode"] = validCode;
    dic[@"trackid"] = TRACKID;
    dic[@"fromurl"] = @"";
    dic[@"reg_source"] = @"1";
    dic[@"device_id"] = [AppUtil getOpenUDID];
    dic[@"device_name"] = [AppUtil getDeviceName];
    dic[@"app_marketing"] = @"";
    dic[@"idfa"] = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] uppercaseString];
    
    [service post:@"user_reg" data:dic complete:^(NSDictionary *value1) {
        [self sendIDFAToServer];
        // =================== 登录 ===================
        
        [GVUserDefaults  shareInstance].isLogin = NO;
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"user_name"] = _phone;
        dic[@"password"] = self.tfPwd.text;
        dic[@"login_type"] = @"1";
        
        [service loginPara:dic done:^(NSDictionary *value) {
            [MobClick event:@"registerBt"];
            [self hideHUD];
            HRRegisterSuccessViewController *controller = [HRRegisterSuccessViewController controllerFromXib];
            [self.navigationController pushViewController:controller animated:YES];
            

            
//            [self showToast:@"注册成功" done:^{
//                [self toInvest];
//
//            }];
        }];
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
