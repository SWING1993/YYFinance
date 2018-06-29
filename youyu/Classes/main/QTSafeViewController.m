//
//  QTSafeViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/23.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTSafeViewController.h"
#import "QTBaseViewController+Table.h"
//
#import "QTBandEmailViewController.h"
#import "QTResetPwdViewController.h"
#import "QTChangePwdViewController.h"
#import "QTAddressController.h"
//
#import "NSString+model.h"

#import "QTSafeCell.h"

@interface QTSafeViewController ()

@property (strong, nonatomic) IBOutlet UIView       *headView;
@property (weak, nonatomic) IBOutlet DWrapView      *warp;
@property (weak, nonatomic) IBOutlet UIProgressView *process;
@property (weak, nonatomic) IBOutlet UILabel        *lbRank;

@end

@implementation QTSafeViewController
{
    NSMutableArray<NSDictionary *> *DataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"安全中心";
    self.navigationItem.rightBarButtonItem = nil;

    TABLEReg(QTSafeCell, @"QTSafeCell");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self commonJson];
}

- (void)setDataUI {
    self.tableView.tableHeaderView = self.headView;

    self.lbRank.text = [NSString safeRank];

    if ([self.lbRank.text isEqualToString:@"低"]) {
        self.process.progress = 0.3;
        [QTTheme progressStyle2:self.process];
    }

    if ([self.lbRank.text isEqualToString:@"中"]) {
        self.process.progress = 0.6;
        [QTTheme progressStyle2:self.process];
    }

    if ([self.lbRank.text isEqualToString:@"高"]) {
        self.process.progress = 1;
        [QTTheme progressStyle2:self.process];
    }
    
    //实名认证
    NSNumber *real_status;
    NSString *realVCStr;
    
    if ([GVUserDefaults shareInstance].real_status) {
        real_status = @(1);
        realVCStr = @"";
    }else{
        real_status = @(0);
        realVCStr = @"toBindCard";
    }

    // email
    NSNumber *email_status;

    if (![GVUserDefaults  shareInstance].email_status) {
        email_status = @(0);
    } else if ([[GVUserDefaults  shareInstance].email_status isEqualToString:@"0"]) {
        email_status = @(2);    // 邮箱未激活
    } else if ([[GVUserDefaults  shareInstance].email_status isEqualToString:@"1"]) {
        email_status = @(1);    // 邮箱已绑定
    }

    // 地址管理
    NSNumber *address_exists;

    if ([[GVUserDefaults  shareInstance].address_exists isEqualToString:@"1"]) {
        address_exists = @(1);
    } else {
        address_exists = @(0);
    }

    NSArray *listArr = @[
        @{@"name":@"实名认证",
          @"image": @"icon_safety_wallet_gray_small",
          @"controller": realVCStr,
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
        @{@"name":@"登录密码",
          @"image": @"icon_safety_log_password_gray_small",
          @"controller": @"toSetLoginPwd",
          @"state": @(1)}

    ];

    DataList = [[NSMutableArray alloc]initWithArray:listArr];

    [self.tableView reloadData];

    [self.warp clearSubviews];
    self.warp.subHeight = 40;

    NSArray<NSNumber *> *imageListNum = @[@(0), @(1), @(2), @(4)];

    for (int i = 0; i < imageListNum.count; i++) {
        NSString        *imageName;
        NSDictionary    *dic = DataList[[imageListNum[i] intValue]];

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

        [self.warp addView:item padding:UIEdgeInsetsMake(0, 5, 0, 5)];
    }
}

#pragma  mark - ui

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];

    self.headView.backgroundColor = Theme.backgroundColor;
    self.warp.backgroundColor = Theme.backgroundColor;
}

- (void)initData {
    self.isLockPage = YES;
}

#pragma  mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTSafeCell";
    QTSafeCell      *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = DataList[indexPath.row];

    NSString    *name;
    NSString    *imageName;

    if ([dic.num(@"state") intValue] == 0) {
        name = @"未".add(dic.str(@"name"));
    } else if ([dic.num(@"state") intValue] == 1) {
        name = @"已".add(dic.str(@"name"));
    } else if ([dic.num(@"state") intValue] == 2) {
        name = @"邮箱未激活";
    } else {
        name = dic.str(@"name");
    }

    imageName = dic.str(@"image");

    [cell bindName:name imageName:imageName index:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = DataList[indexPath.row];

    if (![NSString isEmpty:dic.str(@"controller")]) {
        SuppressPerformSelectorLeakWarning(
            [self performSelector:NSSelectorFromString(dic.str(@"controller"))]);
    }
}

#pragma  mark - json
- (void)commonJson {
    [self setDataUI];
}

@end
