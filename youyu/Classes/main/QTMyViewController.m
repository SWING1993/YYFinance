//
//  QTMyViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTMyViewController.h"
#import "MyListView.h"
#import "MJExtension.h"
#import "NSString+model.h"
#import "QTallMoneyViewController.h"
#import "UIViewController+page.h"
#import "AppDelegate.h"
#import "QTOpenSinaViewController.h"
#import "QTSetMsgViewController.h"
#import "QTVipView.h"
#import "DGridView.h"
#import "AppUtil.h"
#import "HRBindBankViewController.h"

#import "UIViewController+page.h"

@interface QTMyViewController ()

@property (strong, nonatomic) IBOutlet UIControl *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UIControl *secondView;
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel    *lbyuerMoney;
@property (weak, nonatomic) IBOutlet UILabel    *lbAllMoney;
@property (weak, nonatomic) IBOutlet UILabel    *lbEarnMoney;
@property (weak, nonatomic) IBOutlet UIButton   *btnWithdraw;
@property (weak, nonatomic) IBOutlet UIButton   *btnRecharge;
@property (weak, nonatomic) IBOutlet UIButton   *btnDetail;
@property (weak, nonatomic) IBOutlet UIView     *viewBack;
@property (strong, nonatomic) IBOutlet UIView   *fourthView;
@property (strong, nonatomic) IBOutlet UIView   *fifthView;

//投资记录
@property (weak, nonatomic) IBOutlet UIButton *investRecordBtn;
//资金记录
@property (weak, nonatomic) IBOutlet UIButton *capitalRecordBtn;
//帮助中心
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
//回款日历
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;

@end

@implementation QTMyViewController
{
    NSDictionary    *dicAccount_home;
    MyListView      *tempList;
    UILabel *bottomLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUI {
    [self initScrollView];
    [self setRefreshScrollView];

    self.scrollview.backgroundColor = [UIColor colorHex:@"f0f0f0"];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    WEAKSELF;
    [self.headView addTapGesture:^{
        [weakSelf toAccountHome];
    }];
    self.secondView.width = APP_WIDTH;
    self.secondView.backgroundColor = [Theme mainOrangeColor];

    [stack addView:self.secondView];
    [self.secondView addTapGesture:^{
        [weakSelf toFund];
    }];

    [stack addView:self.thirdView];
    [stack addLineForHeight:10 color:[UIColor colorHex:@"f0f0f0"]];
    
    self.fourthView.width = APP_WIDTH;
    [stack addView:self.fourthView];
    
    //点击事件
//
//    @"toDetail",
//    @"toInvestRecord",  // 投资记录
//    @"toFriendPage",    // 邀请有礼
//    @"toVipHome"        // vip
    @weakify(self)
    [self.investRecordBtn click:^(id value) {
        @strongify(self)
        [self toInvestRecord];
    }];
    
    [self.capitalRecordBtn click:^(id value) {
        @strongify(self)
        [self toDetail];
    }];
    
    [self.helpBtn click:^(id value) {
        @strongify(self)
        [AppUtil dial:@"400-888-1673"];
        self.helpBtn.enabled = NO;
        [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
    }];
    
    [self.calendarBtn click:^(id value) {
        @strongify(self)
        [self toSignIn];
    }];
    
    [stack addLineForHeight:10 color:[UIColor colorHex:@"f0f0f0"]];
    NSArray *iconText = @[@"投资红包", @"加息券", @"现金奖励"];
    NSArray *iconImg = @[@"investReward_icon", @"annualCoupon_icon", @"cashReward_icon", ];
    DWrapView *wrap = [[DWrapView alloc]initWidth:APP_WIDTH columns:3];
    wrap.backgroundColor = [Theme backgroundColor];
    wrap.subHeight = APP_WIDTH / 4.5f;
    
    for (int i = 0; i < iconText.count; i++) {
        QTVipView *item = [QTVipView viewNib];
        item.lbName.textColor = [UIColor colorHex:@"666666"];
        item.lbName.font = [UIFont systemFontOfSize:12];
        item.lbName.text = iconText[i];
        item.lbImage.image = [UIImage imageNamed:iconImg[i]];
        
        [item addTapGesture:^(id value) {

            switch (i) {
                case 0:{ //红包
                    [weakSelf toMyTicket:1];
                    break;
                }
                case 1:{ //年化
                    [weakSelf toMyTicket:2];
                    break;
                }
                case 2:{ //现金
                    [weakSelf toMyTicket:0];
                    break;
                }
            }
        }];
        [wrap addView:item margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [stack addView:wrap margin:UIEdgeInsetsZero];
    self.fifthView.width = APP_WIDTH;
    self.fifthView.backgroundColor = [UIColor colorHex:@"f0f0f0"];
    [stack addView:self.fifthView];
    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
    [self.scrollview scrollsToTop];
    
    ///TODO:fifthView上label点击处理----临时处理！！！
    UILabel *phoneLabel = [self.fifthView viewWithTag:571];
    __weak typeof(phoneLabel) weakLabel = phoneLabel;
    [phoneLabel addTapGesture:^{
        weakLabel.userInteractionEnabled = NO;
        [AppUtil dial:@"400-888-1673"];
        __strong typeof(phoneLabel) strongLabel = weakLabel;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            strongLabel.userInteractionEnabled = YES;
        });
    }];
}

- (void)initData {
    self.isLockPage = YES;
    [self.btnWithdraw click:^(id value) {
        if ([GVUserDefaults shareInstance].real_status!=1) {
            [self toBindCard];
        }else{
            [self toWithdrew];
        }
    }];

    [self.btnRecharge click:^(id value) {
        if ([GVUserDefaults shareInstance].real_status!=1) {
           
            [self toBindCard];
            
        }else{
            
            [self toPay];
        }
    }];

    [self.btnDetail click:^(id value) {
        [self toDetail];
    }];

    [self showHUD];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"accountView"];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.headView];
    self.tabBarController.navigationItem.leftBarButtonItem = barItem;
    [self clearUp];
 
    // 用户名
    self.lbName.text = [GVUserDefaults shareInstance].nick_name;
    self.headImage.layer.cornerRadius = 10;
    self.headImage.layer.masksToBounds = YES;
    // 头像
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[GVUserDefaults  shareInstance].app_litpic] placeholderImage:[UIImage imageNamed:@"iconfont_morentouxiang"]];
  
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

- (void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"accountView"];
}
- (void)addBottomTelephoneView{

    UILabel *label = [UILabel new];
    NSString *str = @"客服电话: 400-888-1673";
    NSMutableAttributedString *AttributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, str.length-4)];
    label.attributedText = AttributeStr;
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(0, 0, 0, 32);
    label.textAlignment = NSTextAlignmentCenter;
    label.borderWidth = 1;
    label.cornerRadius = 16;
    bottomLabel = label;
}
- (void)leftMsg {
    [self  toSignIn];
}
#pragma  mark - json

- (void)commonJson {
    [service post:@"account_home" data:nil complete:^(NSDictionary *value) {
        dicAccount_home = value;

        self.lbAllMoney.text = [value.str(@"sinapay_info.available_money")   moneyFormatShow];

        
        self.lbEarnMoney.text = [[NSString stringWithFormat:@"%f", value.d(@"interest_info.interest_invested") + value.d(@"interest_info.interest_waiting")] moneyFormatShow];  // 累计收益
        self.lbyuerMoney.text = [value[@"account_info"][@"account_total"] moneyFormatShow];                                                                                      // 账户总额
        [super commonJson];

        [self hideHUD];
    }];

    [service post:@"webMessage_amountOfWithoutRead" data:nil complete:^(NSDictionary *value) {
        if (value.i(@"amount") > 0) {
            tempList.showTip = YES;
        } else {
            tempList.showTip = NO;
        }
    }];
}

- (void)clearUp{
    self.lbAllMoney.text = @"0.00";
    self.lbEarnMoney.text = @"0.00";
    self.lbName.text = @"";
    self.lbyuerMoney.text = @"0.00";
    self.headImage.image = [UIImage imageNamed:@""];

    
}

- (void) changeButtonStatus {
    self.helpBtn.enabled = YES;
}

@end
