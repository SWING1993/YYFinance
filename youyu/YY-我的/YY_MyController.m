//
//  YY_MyController.m
//  hsd
//
//  Created by bfd on 2017/11/16.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_MyController.h"
#import "GJCommonButton.h"
#import "QTBankViewController.h"
#import "HSDSafeViewController.h"
#import "QTInvestRecordViewController.h"
#import "HRSetUpViewController.h"

@interface YY_MyController ()
@property (nonatomic,strong) UIView *naviBar;
@property (strong, nonatomic) IBOutlet UIControl *headView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *imView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
//总资产label
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
//累计收益label
@property (weak, nonatomic) IBOutlet UILabel *earnMoneyLabel;
//可用余额label
@property (weak, nonatomic) IBOutlet UILabel *availabelMoneyLabel;

@property (strong,nonatomic) UIView *btnView;
//累计收益
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
//可用余额
@property (weak, nonatomic) IBOutlet UIButton *availabelBtn;
//总资产
@property (weak, nonatomic) IBOutlet UIButton *totalMoneyBtn;
@end

@implementation YY_MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否需要手势密码
    self.isLockPage = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"accountView"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 未登录
    if (![GVUserDefaults  shareInstance].isLogin) {
        DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"提示" message:@"请您先登录再操作"];
        [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {
            [self toHome];
        }];
        [alert addActionWithTitle:@"登录" handler:^(CKAlertAction *action) {
            [self toLogin];
        }];
        [alert show];
    } else{
        [self commonJson];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [MobClick endLogPageView:@"accountView"];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    [self clearUp];
    // 用户名
    self.nickLabel.text = [GVUserDefaults shareInstance].nick_name;
    self.headImage.layer.cornerRadius = 12.5;
    self.headImage.layer.masksToBounds = YES;
    // 头像
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[GVUserDefaults  shareInstance].app_litpic] placeholderImage:[UIImage imageNamed:@"我的-头像"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRightItem" object:nil];
    UIBarButtonItem *accountItem = [[UIBarButtonItem alloc]initWithCustomView:self.headView];
    self.navigationItem.leftBarButtonItem = accountItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIImageMake(@"set") style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    self.navigationItem.rightBarButtonItem.tintColor = kColorWhite;
}
- (void)setAction {
    HRSetUpViewController *controller = [HRSetUpViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initUI {
    [self initScrollView];
    self.topView.frame = CGRectMake(0, 0, APP_WIDTH, 220);
    [self.scrollview addSubview:self.topView];
    
    self.btnView = [UIView new];
    self.btnView.backgroundColor = [UIColor whiteColor];
    CGFloat height = 330;
    if (IPHONE6PLUS || IPHONE6) {
        height = 360;
    }
    self.btnView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame) + 10, APP_WIDTH, height);
    [self setBtnView];
    [self.scrollview addSubview:self.btnView];
    [self.scrollview autoContentSize];
    
    //控件风格调整
    self.imView.backgroundColor = [Theme mainOrangeColor];
    
    [self.topView bringSubviewToFront:self.totalMoneyBtn];
    
    WEAKSELF;
    //事件响应
    [self.headView click:^(id value) {
        NSLog(@"头像");
        [weakSelf toAccountHome];
    }];
    
    ///TODO:以下三处暂时跳转同一页面，，，
    [self.totalMoneyBtn click:^(id value) {
        NSLog(@"总资产");
        [self toFund];
    }];
    
    [self.allBtn click:^(id value) {
        NSLog(@"累计收益");
        [self toFund];
    }];
    
    [self.availabelBtn click:^(id value) {
        NSLog(@"可用余额");
        [self toFund];
    }];
}


- (void)setBtnView {
    
    CGFloat left = 30;
    CGFloat top = 25;
    CGFloat btnWH = 60;
    if (IPHONE6PLUS || IPHONE6) {
        btnWH = 70;
    }
   
    CGFloat btnPadding = (APP_WIDTH - btnWH * 3 - left * 2) / 2;
    CGFloat btnCount = 9;
    NSArray *titles = @[@"我要充值",@"我要提现",@"投资记录",@"收支明细",@"回款记录",@"银行卡",@"优惠券",@"平台简介",@"安全保障"];
    
    for (NSInteger i = 0; i < btnCount; i++) {
        GJCommonButton *btn = [[GJCommonButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        btn.scale = 0.6;
        btn.imageScale = 0.99;
        btn.imageLeftRightEdageHeight = 14;
        btn.imageEdageHeight = 3;
        btn.frame = CGRectMake(left + (i % 3) * (btnWH + btnPadding), top + (i / 3) * top + (i / 3) *(btnWH + top), btnWH, btnWH+5);
        [self.btnView addSubview:btn];
    }
}

- (void)btnTap:(GJCommonButton *)btn {
    NSLog(@"btn tag is %zd",btn.tag);
    switch (btn.tag) {
        case 100:{//我要充值
            if ([GVUserDefaults shareInstance].real_status!=1) {
                
                [self toBindCard];
            } else {
                [self toPay];
            }
        }
            break;
        case 101:{//我要提现
            if ([GVUserDefaults shareInstance].real_status!=1) {
                [self toBindCard];
            }else{
                [self toWithdrew];
            }
        }
            break;
        case 102:{//投资记录
            [self toInvestRecord];
//            [self performSelector:NSSelectorFromString(@"toInvestRecord")];
        }
            break;
        case 103:{//收支明细
            [self toDetail];
        }
            break;
        case 104:{//回款记录
            QTInvestRecordViewController *controller = [QTInvestRecordViewController controllerFromXib];
            controller.segment = 2;
            controller.titleName = @"已回款";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 105:{//银行卡
            if ([GVUserDefaults shareInstance].real_status!=1) {
                
                [self toBindCard];
            } else {
                QTBankViewController *vc = [QTBankViewController controllerFromXib];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        case 106:{//优惠券
            [self toUserReward];
        }
            break;
        case 107:{//平台简介
            HSDSafeViewController *vc = [HSDSafeViewController controllerFromXib];
            vc.state = 0;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 108:{//平台简介
            HSDSafeViewController *vc = [HSDSafeViewController controllerFromXib];
            vc.state = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//数据获取
- (void)commonJson {
    [service post:@"account_home" data:nil complete:^(NSDictionary *value) {
        
        //可用余额
        self.availabelMoneyLabel.text = [value.str(@"sinapay_info.available_money")   moneyFormatShow];
        
        // 累计收益
        self.earnMoneyLabel.text = [[NSString stringWithFormat:@"%f", value.d(@"interest_info.interest_invested") + value.d(@"interest_info.interest_waiting")] moneyFormatShow];
        
        // 账户总额
        self.totalMoneyLabel.text = [value[@"account_info"][@"account_total"] moneyFormatShow];
        
        [super commonJson];
        
        [self hideHUD];
    }];
}

//清空数据展示
- (void)clearUp {
    //金额数字设为0.00
    self.availabelMoneyLabel.text = @"0.00";
    self.earnMoneyLabel.text = @"0.00";
    self.totalMoneyLabel.text = @"0.00";
    //昵称
    self.nickLabel.text = @"";
    //头像
    self.headImage.image = [UIImage imageNamed:@"我的-头像"];
}

#pragma mark - QMUINavigationControllerDelegate
- (nullable UIColor *)titleViewTintColor {
    return kColorWhite;
}

- (nullable UIColor *)navigationBarTintColor {
    return kColorWhite;
}

- (UIImage *)navigationBarBackgroundImage {
    return [UIImage qmui_imageWithColor:Theme.mainOrangeColor];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
