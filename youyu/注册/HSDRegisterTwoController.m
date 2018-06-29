//
//  HSDRegisterTwoController.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//
#import <AdSupport/AdSupport.h>
#import "HSDRegisterTwoController.h"
#import "HSDRegisterSuccessController.h"
#import "YYTimer.h"
#import "QTWebViewController.h"

@interface HSDRegisterTwoController ()
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswdField;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswdField;
@property (weak, nonatomic) IBOutlet UITextField *recommendField;
//@property (weak, nonatomic) IBOutlet UIImageView *firstEyeView;
@property (weak, nonatomic) IBOutlet UIImageView *secondEyeView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *isAgreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

@property (strong, nonatomic) YYTimer *timer;

@property (assign, nonatomic) NSInteger timeCount;

@end

@implementation HSDRegisterTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleView.title = @"注册";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"registerView"];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"registerView"];
    
}

//处理验证码计时器
- (void)handleTimer {
    self.timeCount = self.timeCount - 1;
    if (self.timeCount > 0) {
        self.getCodeBtn.enabled = NO;
        self.getCodeBtn.userInteractionEnabled = NO;
        self.getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%zds后重新发送",self.timeCount];
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%zds后重新发送",self.timeCount] forState:UIControlStateNormal];
        self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self.timer invalidate];
        self.getCodeBtn.enabled = YES;
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.getCodeBtn setTitleColor:[Theme mainOrangeColor] forState:UIControlStateNormal];
    }
}

- (void)initUI {
    [self initScrollView];
    self.headView.frame =  CGRectMake(0, 40, APP_WIDTH, 100);
    self.inputView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame) + 50, APP_WIDTH, 180);
    self.registerView.frame = CGRectMake(0, CGRectGetMaxY(self.inputView.frame) + 50, APP_WIDTH, 44);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.registerView.frame) + 50, APP_WIDTH, 30);
    [self.scrollview addSubview:self.headView];
    [self.scrollview addSubview:self.inputView];
    [self.scrollview addSubview:self.registerView];
    [self.scrollview addSubview:self.bottomView];
    [self.scrollview autoContentSize];
    self.firstPasswdField.secureTextEntry =  NO;
    self.secondPasswdField.secureTextEntry = YES;
    
    //控件样式设置
    self.registerBtn.backgroundColor = [Theme mainOrangeColor];
    self.getCodeBtn.layer.borderColor = [Theme mainOrangeColor].CGColor;
    [self.getCodeBtn setTitleColor:[Theme mainOrangeColor] forState:UIControlStateNormal];
    self.isAgreeBtn.selected = YES;
    [self.isAgreeBtn setImage:[UIImage imageNamed:@"icon_login_unselect"] forState:UIControlStateNormal];
    [self.isAgreeBtn setImage:[UIImage imageNamed:@"icon_login_select"] forState:UIControlStateSelected];
    
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc]initWithString:@"我同意并接受《用户服务协议》"];
    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:[Theme mainOrangeColor] range:NSMakeRange(6, 8)];
    //    self.protocolBtn.titleLabel.attributedText = attributedStr1;
    [self.protocolBtn setAttributedTitle:attributedStr1 forState:UIControlStateNormal];
    [self.protocolBtn setAttributedTitle:attributedStr1 forState:UIControlStateHighlighted];
    
    //响应事件处理
    WEAKSELF;
//    [self.firstEyeView addTapGesture:^{
//        weakSelf.firstPasswdField.secureTextEntry = !weakSelf.firstPasswdField.secureTextEntry ;
//        if (weakSelf.firstPasswdField.secureTextEntry == YES) {
//            weakSelf.firstEyeView.image = [UIImage imageNamed:@"隐藏密码拷贝"];
//        } else {
//            weakSelf.firstEyeView.image = [UIImage imageNamed:@"隐藏"];
//        }
//    }];
    [self.getCodeBtn click:^(id value) {
        [self showHUD:@"正在发送..."];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        dic[@"phone"] = self.phone;
        dic[@"sms_type"] = @"registered";
        dic[@"trackid"] = TRACKID;
        
        // 如果出现发送错误，需要禁止按钮的倒计时
        [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
            [self hideHUD];
            [self showToast:MSGTIP duration:3];
            
            //启动定时器
            weakSelf.timer = [YYTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(handleTimer) repeats:YES];
            weakSelf.timeCount = 30;
            weakSelf.getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%zds后重新发送",self.timeCount];
            [weakSelf.getCodeBtn setTitle:[NSString stringWithFormat:@"%zds后重新发送",weakSelf.timeCount] forState:UIControlStateNormal];
            weakSelf.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            [weakSelf.getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }];
    }];
    
    [self.secondEyeView addTapGesture:^{
         weakSelf.secondPasswdField.secureTextEntry = !weakSelf.secondPasswdField.secureTextEntry ;
        if (weakSelf.secondPasswdField.secureTextEntry == YES) {
            weakSelf.secondEyeView.image = [UIImage imageNamed:@"YY_eyeClose"];
        } else {
            weakSelf.secondEyeView.image = [UIImage imageNamed:@"YY_eyeOpen"];
        }
    }];
    
    [self.protocolBtn click:^(id value) {
        
        QTWebViewController *controller = [[QTWebViewController alloc]init];
        controller.url = URL_REG_PROTOCOL;
        controller.titleView.title = @"用户服务协议";
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.isAgreeBtn click:^(id value) {
        weakSelf.isAgreeBtn.selected = !weakSelf.isAgreeBtn.selected;
        if (!weakSelf.isAgreeBtn.selected) {
            //设置不可注册
            weakSelf.registerBtn.enabled = NO;
            weakSelf.registerBtn.backgroundColor = [UIColor lightGrayColor];
        } else {
            weakSelf.registerBtn.enabled = YES;
            weakSelf.registerBtn.backgroundColor = [Theme mainOrangeColor];
        }
    }];
    
    [self.registerBtn click:^(id value) {
        NSLog(@"go register");
        //预先验证
        if (!self.firstPasswdField.text.length) {
            [self showToast:@"验证码不能为空"];
            return;
        }
        
        if (!self.secondPasswdField.text.length) {
            [self showToast:@"登录密码不能为空"];
            return;
        }
        
        if (self.recommendField.text.length) {
            if (![self.recommendField.text hasPrefix:@"1"] || self.recommendField.text.length != 11) {
                 [self showToast:@"推荐人手机号不合法"];
                 return;
            }
        } 
        
        [self commonJson];
        
    }];
}

-(void)sendIDFAToServer{
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    dic[@"idfa"] = [AppUtil getAPPIDFA];
    dic[@"type"] = @"1";
    dic[@"username"] = [self.phone stringValue];
    [service post:@"syscfg_oMyGreen" data:dic complete:^(id value) {
    }];
}

- (void)commonJson {

    [self showHUD:@"正在注册..."];

    NSString            *phone = [self.phone stringValue];//注册手机
    NSString            *password = [self.secondPasswdField.text stringValue];//密码
    NSString            *validCode = [self.firstPasswdField.text stringValue];//验证码 //[self.code stringValue];
    NSString            *inviteUser = [self.recommendField.text stringValue];//推荐人
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
        dic[@"user_name"] = self.phone;
        dic[@"password"] = self.secondPasswdField.text;
        dic[@"login_type"] = @"1";

        [service loginPara:dic done:^(NSDictionary *value) {
            [MobClick event:@"registerBt"];
            [self hideHUD];
            
            //跳转至注册成功页面
            HSDRegisterSuccessController *resiterSuccessVC = [HSDRegisterSuccessController controllerFromXib];
            [self.navigationController pushViewController:resiterSuccessVC animated:YES];
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
