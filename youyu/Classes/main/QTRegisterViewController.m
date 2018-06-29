//
//  QTRegisterViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/29.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import "QTRegisterViewController.h"
#import "TimeCodeButton.h"
#import "QTOpenSinaViewController.h"
#import "QTWebViewController.h"

@interface QTRegisterViewController ()

@property (strong, nonatomic)  WTReTextField *tfPhone;

@property (strong, nonatomic)  WTReTextField *tfPwd;

@property (weak, nonatomic)  WTReTextField  *tfValidCode;
@property (weak, nonatomic)  TimeCodeButton *btnCode;

@property (weak, nonatomic)  WTReTextField *tfInviteUser;
@property (strong, nonatomic) UIButton *selectedBt;

@property (strong, nonatomic) IBOutlet UIImageView *headimage;

@end

@implementation QTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"注册";
    //    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"registerView"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"registerView"];

}

- (void)initUI {
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    self.headimage.height = APP_WIDTH / 320 * 80;
    [grid addView:self.headimage margin:UIEdgeInsetsMake(20, 0, 10, 0)];

    [grid addLineForHeight:20];

    self.tfPhone = [grid addRowInput:@"手机号" placeholder:@"请输入手机号"];

    self.tfValidCode = [grid addRowCodeText:^(id value) {
            [self clickSendMsg:value];
        }];
    self.tfPwd = [grid addRowInput:@"密码" placeholder:@"6-24位字符，区分大小写"];

    [grid addLineForHeight:20];

    self.tfInviteUser = [grid addRowInput:@"邀请人" placeholder:@"手机号码(选填)"];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"同意《有余金服服务协议》 "];
    [str addAttribute:NSForegroundColorAttributeName value:Theme.darkBlueColor range:NSMakeRange(2, 10)];
    [str addAttribute:NSForegroundColorAttributeName value:Theme.darkGrayColor range:NSMakeRange(0, 2)];
    
    _selectedBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, APP_WIDTH-40, 40)];
    _selectedBt.titleLabel.font = [UIFont systemFontOfSize:12];
    _selectedBt.titleLabel.backgroundColor = Theme.backgroundColor;
    _selectedBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _selectedBt.selected = YES;
    [self.selectedBt click:^(id value) {
        if (self.selectedBt.selected) {
            self.selectedBt.selected = NO;
        } else {
            self.selectedBt.selected = YES;
        }
    }];
    __weak QTRegisterViewController *weakSelf=self;
    [self.selectedBt.titleLabel addTapGesture:^{
        __strong QTRegisterViewController *strongSelf =weakSelf;
        QTWebViewController *controller = [[QTWebViewController alloc]init];
        controller.url = URL_REG_PROTOCOL;
        controller.titleView.title = @"有余金服服务协议";
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.selectedBt setImage:[UIImage imageNamed:@"icon_login_select"] forState:UIControlStateSelected];
    [self.selectedBt setImage:[UIImage imageNamed:@"icon_login_unselect"] forState:UIControlStateNormal];
    [self.selectedBt setAttributedTitle:str forState:UIControlStateNormal];
    
    [grid addView:_selectedBt margin:UIEdgeInsetsMake(10, 0, 10, 0)];

    [grid addRowButtonTitle:@"立即领取888元红包" click:^(id value) {
        [self clickSubmit];
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.tfPhone setPhone];
    self.tfPhone.group = 0;

    [self.tfPwd setPwd];
    self.tfPwd.group = 1;

    [self.tfValidCode setValidationCode];
    self.tfValidCode.group = 1;

    [self.tfInviteUser setPhone];
    self.tfInviteUser.isNeed = NO;
    self.tfValidCode.group = 1;
    self.tfValidCode.errorTip = @"邀请人手机格式错误";
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

    [self commonJsonSendMsg:self.tfPhone.text];
}

// 注册
- (void)clickSubmit {
    if (![self.view validation:0]) {
        return;
    }

    if (![self.view validation:1]) {
        return;
    }
    
    if (!self.selectedBt.selected) {
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
    dic[@"username"] = [self.tfPhone.text stringValue];
    [service post:@"syscfg_oMyGreen" data:dic complete:^(id value) {
    }];
}

- (void)commonJson {
    [self showHUD:@"正在注册..."];

    NSString            *phone = [self.tfPhone.text stringValue];
    NSString            *password = [self.tfPwd.text stringValue];
    NSString            *validCode = [self.tfValidCode.text stringValue];
    NSString            *inviteUser = [self.tfInviteUser.text stringValue];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"invite_user"] = inviteUser;
    dic[@"phone"] = phone;
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
        dic[@"user_name"] = self.tfPhone.text;
        dic[@"password"] = self.tfPwd.text;
        dic[@"login_type"] = @"1";

        [service loginPara:dic done:^(NSDictionary *value) {
            [MobClick event:@"registerBt"];
            [self hideHUD];

            // 跳转到实名认证

            [self showToast:@"注册成功" done:^{
            [self toInvest];
//                QTOpenSinaViewController *controller = [QTOpenSinaViewController controllerFromXib];
//                [self.navigationController pushViewController:controller animated:YES];
            }];
        }];
    }];
}

@end
