//
//  QTloginViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTloginViewController.h"
#import "QTMyViewController.h"
#import "NSString+model.h"

#import "QTRegisterViewController.h"
#import "QTResetPwdViewController.h"

#import "WTReTextField.h"
#import "DFormAdd.h"

#import "QTChangePwdViewController.h"
#import "QTUserListViewController.h"
#import "QTBaseViewController+Table.h"

#import "QTLoginCodeViewController.h"
#import "UIViewController+buttonUsed.h"
//#import "HRRegisterViewController.h"

static NSString  *loginStr = @"登录";


@interface QTloginViewController ()<QTUserListDelegate, QTLoginDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic)  WTReTextField *tfPhone;

@property (weak, nonatomic)  WTReTextField *tfPwd;

@property (strong, nonatomic) IBOutlet UIButton *btnForget;

@property (strong, nonatomic) IBOutlet UIView *viewReg;

@property (weak, nonatomic) IBOutlet UIButton   *btnReg;
@property (strong, nonatomic) IBOutlet UIButton *btnRemember;
@property (strong, nonatomic) IBOutlet UIView   *viewOther;

@end

@implementation QTloginViewController
{
    popActionBlock              block;
    QTUserListViewController    *dropController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = loginStr;
    self.tfPhone.delegate = self;
    self.tfPwd.delegate = self;

    self.navigationItem.rightBarButtonItem = nil;
    [self setButtonStatus:UIButtonUnused buttonTitle:loginStr];
   }


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setButtonStatus:UIButtonUsed buttonTitle:loginStr];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    if (![self.view validation:0]) {
        [self setButtonStatus:UIButtonUnused buttonTitle:loginStr];
    }
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

- (void)initUI {
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addView:self.image margin:UIEdgeInsetsMake(20, 0, 30, 0)];

    if (SYSTEM_CONFIG.userList.count == 0) {
        self.tfPhone = [grid addRowInputWithplaceholder:@"请输入手机号码"];
    } else {
        self.tfPhone = [grid addRowInputWithplaceholder:@"请输入手机号码" Arrow:@"icon_login_drop" block:^(UIImageView *value) {
                dropController.view.top = self.image.height + 20 + 30 + 44;

                if ([self.scrollview.subviews containsObject:dropController.view]) {
                    [UIView animateWithDuration:0.2 animations:^{
                        value.transform = CGAffineTransformMakeRotation(-2 * M_PI);
                    }];
                    [dropController.view removeFromSuperview];
                } else {
                    [UIView animateWithDuration:0.2 animations:^{
                        value.transform = CGAffineTransformMakeRotation(-M_PI);
                    }];

                    [self.scrollview addSubview:dropController.view];
                }
            }];
    }

    [self.tfPhone setLeftImage:@"icon_login_name"];

    self.tfPwd = [grid addRowInputWithplaceholder:@"6-24位字符，区分大小写"];
    self.tfPwd.leftPadding = 4;
    [self.tfPwd setLeftImage:@"icon_login_password"];

    [grid addView:self.viewOther margin:UIEdgeInsetsZero];

    [grid addRowButtonTitle:@"登录" click:^(id value) {
        [self clickSubmit];
    }];

    [grid addView:self.viewReg margin:UIEdgeInsetsMake(10, 0, 0, 0)];

    self.viewReg.backgroundColor = Theme.backgroundColor;

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.btnReg click:^(id value) {
        [self toRegister];
//        [self ToNewRegister];
    }];

    [self.btnForget click:^(id value) {
        QTResetPwdViewController *controller = [QTResetPwdViewController controllerFromXib];
        [self.navigationController pushViewController:controller animated:YES];
    }];

    if (SYSTEM_CONFIG.userList.count > 0) {
        self.tfPhone.text = SYSTEM_CONFIG.userList.firstObject[@"name"];
        self.tfPwd.text = SYSTEM_CONFIG.userList.firstObject[@"pwd"];
    }

    [self.tfPhone setPhone];
    self.tfPhone.group = 0;

    [self.tfPwd setPwd];
    self.tfPwd.group = 0;

    dropController = [QTUserListViewController controllerFromXib];
    dropController.tableDataArray = SYSTEM_CONFIG.userList;
    dropController.delegate = self;
    [self addChildViewController:dropController];

    [self.btnRemember click:^(id value) {
        if (self.btnRemember.selected) {
            self.btnRemember.selected = NO;
        } else {
            self.btnRemember.selected = YES;
        }
    }];

    [self.btnRemember setImage:[UIImage imageNamed:@"icon_login_select"] forState:UIControlStateSelected];
    [self.btnRemember setImage:[UIImage imageNamed:@"icon_login_unselect"] forState:UIControlStateNormal];
}

- (void)UserList:(QTUserListViewController *)controller didSelect:(NSDictionary *)dic {
    self.tfPhone.text = dic.str(@"name");
    self.tfPwd.text = dic.str(@"pwd");
    [dropController.view removeFromSuperview];
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
    [GVUserDefaults  shareInstance].isLogin = NO;

    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"user_name"] = self.tfPhone.text;
    dic[@"password"] = self.tfPwd.text;
    dic[@"login_type"] = @"1";

    [service loginPara:dic done:^(NSDictionary *value) {
        [self loginHandel:value];
    }];
}

- (void)loginHandel:(NSDictionary *)value {
    NSString    *username = self.tfPhone.text;
    NSString    *password = self.tfPwd.text;

    [self hideHUD];

    NSMutableArray *userList = [[NSMutableArray alloc]initWithArray:SYSTEM_CONFIG.userList];

    for (int i = 0; i < userList.count; i++) {
        NSDictionary *temp = userList[i];

        if ([temp.str(@"name") isEqualToString:username]) {
            [userList removeObject:temp];
        }
    }

    if (self.btnRemember.isSelected) {
        [userList insertObject:@{@"name":username, @"pwd":password, @"imgurl":value.str(@"app_litpic")} atIndex:0];
    } else {
        [userList insertObject:@{@"name":username, @"pwd":@"", @"imgurl":value.str(@"app_litpic")} atIndex:0];
    }

    SYSTEM_CONFIG.userList = userList;


    [[GVUserDefaults shareInstance]saveLocal];

    if (self.isLoginedToAccout) {
        self.navigationController.tabBarController.selectedIndex = MY_TAG;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (self.isBackToSecondPage){
        
        [self popToSecond];
    }
    else {
        [self pop];
    }

    if (block) {
        block();
    }
}

@end
