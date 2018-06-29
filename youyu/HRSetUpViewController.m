//
//  HRSetUpViewController.m
//  hr
//
//  Created by 赵 on 02/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRSetUpViewController.h"
#import "QTBaseViewController+Table.h"
//
#import "QTBandEmailViewController.h"
#import "QTResetPwdViewController.h"
#import "QTChangePwdViewController.h"
#import "QTAddressController.h"
//
#import "NSString+model.h"

#import "QTSafeCell.h"
#import "DGridView.h"
#import "CLLockVC.h"
#import "CoreArchive.h"
#import "CoreLockConst.h"

@interface HRSetUpViewController ()
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) DGridView *bottomView;
@property (strong, nonatomic) UISwitch *GeustureSwitch;
@property (assign ,nonatomic,getter=isOpen) BOOL isButtonOn;


@end

@implementation HRSetUpViewController{

    NSMutableArray<NSDictionary*> *dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"设置";
    
    TABLEReg(QTSafeCell, @"QTSafeCell");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    [self commonJson];
}

- (void)setDataUI {
    

    // email
    NSNumber *email_status;
    
    if (![GVUserDefaults  shareInstance].email_status) {
        email_status = @(0);
    } else if ([[GVUserDefaults  shareInstance].email_status isEqualToString:@"0"]) {
        email_status = @(2);    // 邮箱未激活
    } else if ([[GVUserDefaults  shareInstance].email_status isEqualToString:@"1"]) {
        email_status = @(1);    // 邮箱已绑定
    } else {
        email_status = @(0);
    }
    
    NSString *GesturePwd= [CoreArchive strForKey:CoreLockPWDKey];
    NSNumber *gesture_exists;
    if (GesturePwd.length!=0) {
        gesture_exists = @(1);
    } else {
        gesture_exists = @(0);
    }
    
    // 地址管理
    NSNumber *address_exists;
    
    if ([[GVUserDefaults  shareInstance].address_exists isEqualToString:@"1"]) {
        address_exists = @(1);
    } else {
        address_exists = @(0);
    }
    
    //实名认证
    NSNumber *real_status;
    if ([GVUserDefaults shareInstance].real_status==1) {
        real_status=@(1);
    } else {
        real_status=@(0);
    }
    
    NSArray *listArr = @[
                         @{@"name":@"实名认证",
                           @"image": @"icon_safety_wallet_gray_small",
                           @"controller": @"toBindCard",
                           @"state": real_status},
                         @{@"name":@"绑定邮箱",
                           @"image": @"icon_safety_message_gray_small",
                           @"controller": @"toBandEmail",
                           @"state": email_status},
                         @{@"name":@"设置支付密码",
                           @"image": @"icon_safety_pay_password_gray_small",
                           @"controller": @"toPayPwd",
                           @"state": @([[GVUserDefaults shareInstance] isSetPayPassword])},
                         @{@"name":@"设置收货地址",
                           @"image": @"icon_safety_address_gray_small",
                           @"controller": @"toReceivingAddress",
                           @"state": address_exists},
                         @{@"name":@"修改登录密码",
                           @"image": @"icon_safety_log_password_gray_small",
                           @"controller": @"toSetLoginPwd",
                           @"state": @(1)},
                         @{@"name":@"设置手势密码",
                           @"image": @"icon_safety_log_password_gray_small",
                           @"controller": @"toGestureVC",
                           @"state": gesture_exists}
                         ];

    
    dataList = [[NSMutableArray alloc]initWithArray:listArr];
    
    if ([GVUserDefaults shareInstance].real_status!=1) {
        [dataList replaceObjectAtIndex:0 withObject: @{@"name":@"实名认证",
                                                       @"image": @"icon_safety_wallet_gray_small",
                                                       @"controller": @"toOpenSina",
                                                       @"state": real_status}
         ];
    }

    [self.tableView reloadData];
    
    
    NSArray<NSNumber *> *imageListNum = @[@(0), @(1), @(2), @(4)];
    
    for (int i = 0; i < imageListNum.count; i++) {
        NSString        *imageName;
        NSDictionary    *dic = dataList[[imageListNum[i] intValue]];
        
        UIImageView *item = [UIImageView new];
        item.width = 40;
        item.height = 40;
        imageName = dic.str(@"image");
        
        if ([dic.num(@"state") intValue] == 1) {
            item.image = [[UIImage imageNamed:imageName] imageWithColor:[Theme darkOrangeColor]];
            item.layer.borderColor = [Theme darkOrangeColor].CGColor;
        } else {
            item.image = [[UIImage imageNamed:imageName] imageWithColor:[Theme grayColor]];
            item.layer.borderColor = [Theme grayColor].CGColor;
        }
        
        item.contentMode = UIViewContentModeCenter;
        
        item.layer.masksToBounds = 5;
        item.layer.cornerRadius = 20;
        item.layer.borderWidth = 1;
        
    }
}

#pragma  mark - ui

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];
    self.bottomView = [[DGridView alloc]initWidth:APP_WIDTH];
    
    WEAKSELF;
    [self.bottomView addRowButtonTitle:@"退出登录" click:^(id value) {
        [weakSelf logout];
        
    }];
    [self addBottomView:self.bottomView padding:UIEdgeInsetsMake(10, 10, APP_HEIGHT-400, 10)];
}

- (void)initData {
    self.isLockPage = YES;
}

- (void)toGestureVC{

    BOOL hasPwd = [CLLockVC hasPwd];
    if(hasPwd){
        
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:0.5f];
        }];
    }else{
        
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"密码设置成功");
            [lockVC dismiss:0.5f];
        }];
    }

}

#pragma  mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTSafeCell";
    QTSafeCell      *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    NSDictionary *dic = dataList[indexPath.row];
    
    NSString    *name;
    NSString    *imageName;
    
    if ([dic.num(@"state") intValue] == 0) {
        
        name = @"未".add(dic.str(@"name"));
    } else if ([dic.num(@"state") intValue] == 1) {
        name = @"已".add(dic.str(@"name"));
        if (indexPath.row == 0) {
            cell.userInteractionEnabled = NO;
        }
        
    } else if ([dic.num(@"state") intValue] == 2) {
        name = @"邮箱未激活";
    } else {
        name = dic.str(@"name");
    }
    
    imageName = dic.str(@"image");
    
    if (indexPath.row==5) {
        _GeustureSwitch = cell.GestureSW;
        [_GeustureSwitch addTarget:self action:@selector(cliclSwitchBt:) forControlEvents:UIControlEventValueChanged];
        [self checkSwitchStatus];
    }
    
    [cell bindName:name imageName:imageName index:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = dataList[indexPath.row];
    if (indexPath.row == 0) {
        [self toBindCard];
        return;
    }
    
    if (![NSString isEmpty:dic.str(@"controller")]) {
        SuppressPerformSelectorLeakWarning(
                                           [self performSelector:NSSelectorFromString(dic.str(@"controller"))]);
    }
}

- (void)checkSwitchStatus{
    
    BOOL hasPwd = [CLLockVC hasPwd];
    if (hasPwd) {
        [_GeustureSwitch setEnabled:YES];
        [_GeustureSwitch setOn:YES animated:YES];

        
    }
    else{
        
        
        [_GeustureSwitch setOn:NO animated:YES];
        [_GeustureSwitch setEnabled:NO];

    }
}

#pragma  mark - json
- (void)commonJson {
    [self setDataUI];
}

#pragma mark Gesture
- (void)cliclSwitchBt:(UISwitch*)sender{
  
    UISwitch *switchButton = (UISwitch*)sender;
    _isButtonOn = [switchButton isOn];
    if (_isButtonOn) {
        [self showToast:@"打开手势密码"];
        
    } else {
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            [CoreArchive removeStrForKey:CoreLockPWDKey];
            [self toLogin];
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [CoreArchive removeStrForKey:CoreLockPWDKey];
            [self showToast:@"关闭手势密码"];
            [self commonJson];
            [lockVC dismiss:1.0f];

        }];
    }
    
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
    return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
    return YES;
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
