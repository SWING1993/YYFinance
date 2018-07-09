//
//  HRLoginPwdViewController.m
//  hr
//
//  Created by 慧融 on 19/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRLoginPwdViewController.h"
#import "HRBindBankViewController.h"
#import "QTloginViewController.h"
#import "HRRegisterSuccessViewController.h"

@interface HRLoginPwdViewController ()
@property (strong, nonatomic) WTReTextField *tfPwd;
@property (strong, nonatomic) IBOutlet UILabel *pwdTinLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *InvestTotalUsersLabel;
@property (strong, nonatomic) IBOutlet UIButton *forgetPwdBt;

@end

@implementation HRLoginPwdViewController {

    popActionBlock        block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"登录";
    self.navigationItem.rightBarButtonItem = nil;
    // Do any additional setup after loading the view from its nib.
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head-logo"]];
    }
    return _imageView;
}

- (void)initUI{
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    [grid addView:self.imageView margin:UIEdgeInsetsMake(50, (APP_WIDTH - 250)/2.0, 30, (APP_WIDTH - 250)/2.0)];
    
    
//    NSInteger register_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"register_total"];
//    NSString *investTotalStr = [NSString stringWithFormat:@"现在已有%ld人与您放心一起理财",register_total];
//    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:investTotalStr];
//    for (int i = 0; i<= investTotalStr.length; i++) {
//        NSString *a = [investTotalStr substringWithRange:NSMakeRange(i, 1)];
//        if ([NSString isPureInt:a]) {
//            [strAttr setAttributes:@{NSForegroundColorAttributeName:MainColor} range:NSMakeRange(i, 1)];
//        }
//    }
//    self.InvestTotalUsersLabel.attributedText = strAttr;
//    [grid addView:self.InvestTotalUsersLabel margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tfPwd = [grid addRowInputWithplaceholder:@"请输入登录密码"];
    self.tfPwd.leftPadding = 4;
    [self.tfPwd setLeftImage:@"icon_login_password"];
    [self.tfPwd setRightImage:@"YY_eyeClose"];
    [self.tfPwd setRightImageAction:NO];
    
    [grid addLineForHeight:68.5];

    self.forgetPwdBt.superview.superview.backgroundColor = Theme.backgroundColor;
    [grid addSubmitButtonTitle:@"登录" click:^(id value) {
        NSLog(@"登录按钮");
        [self clickSubmit];
    }];
    
    [grid addView:self.forgetPwdBt margin:UIEdgeInsetsMake(5, APP_WIDTH - 120, 0,0)];
    
    WEAKSELF;
    [self.forgetPwdBt addTapGesture:^{
        [weakSelf toSetLoginPwd];
    }];
    [grid addLineForHeight:9.5];
    
    
    [self.view addSubview:grid];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

- (void)pop {
    for (NSInteger i = self.navigationController.childViewControllers.count - 2; i >= 0; i--) {
        if (![self.navigationController.childViewControllers[i] isKindOfClass:[QTloginViewController class]]) {
            [self.navigationController popToViewController:self.navigationController.childViewControllers[i] animated:YES];
            break;
        }
    }
}

- (void)popToSecond{
    
    for (NSInteger i = self.navigationController.childViewControllers.count - 3; i >= 0; i--) {
        if (![self.navigationController.childViewControllers[i] isKindOfClass:[QTloginViewController class]]) {
            [self.navigationController popToViewController:self.navigationController.childViewControllers[i] animated:YES];
            break;
        }
    }
    
}

- (void)backAction:(popActionBlock)_block {
    block = _block;
}

- (BOOL)navigationShouldPopOnBackButton {
//    if (self.isBackHome) {
//        [self toHome];
//    }else {
//        [self pop];
//    }
    [self pop];
    return NO;
}


- (void)initData{

    [self.tfPwd setPwd];
    self.tfPwd.group = 0;
}

#pragma  mark - event
- (void)clickSubmit {
    [self.view endEditing:YES];
    
    if (![self.view validation:0]) {
        return;
    }
    
    [self commonJson];
}

#pragma  mark - json

- (void)commonJson {
    [self showHUD];
//    [GVUserDefaults shareInstance].isLogin = NO;
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"user_name"] = self.phone;
    dic[@"password"] = self.tfPwd.text;
    dic[@"login_type"] = @"1";
    
    [service loginPara:dic done:^(NSDictionary *value) {
        [self loginHandel:value];
    }];
}

- (void)loginHandel:(NSDictionary *)value {
    NSString    *username = self.phone;
    [self hideHUD];
    
    NSMutableArray *userList = [[NSMutableArray alloc]initWithArray:[SystemConfigDefaults sharedInstance].userList];
    
    for (int i = 0; i < userList.count; i++) {
        NSDictionary *temp = userList[i];
        
        if ([temp.str(@"name") isEqualToString:username]) {
            [userList removeObject:temp];
        }
    }

    [userList insertObject:@{@"name":username, @"pwd":@"", @"imgurl":value.str(@"app_litpic")} atIndex:0];
    
    [SystemConfigDefaults sharedInstance].userList = userList;
    
//    [[GVUserDefaults shareInstance]saveLocal];
    
    if (self.isLoginedToAccout) {
        self.navigationController.tabBarController.selectedIndex = MY_TAG;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (self.isBackToSecondPage){
        [self popToSecond];
    } else {
        [self pop];
    }
    
    if (block) {
        block();
    }
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
