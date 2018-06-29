//
//  QTSinaWithdrewViewController.m
//  qtyd
//
//  Created by stephendsw on 16/8/4.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSinaWithdrewViewController.h"
#import "QTWebViewController.h"

#import "QTBankViewController.h"
#import "BankModel.h"
#import "NSDate+RMCalendarLogic.h"
#import "BankDeailView.h"
#import "QTBaseViewController+BankDetail.h"
#import "HRAddBankViewController.h"

@interface QTSinaWithdrewViewController ()<BankDelegate>
{
    UILabel *lbtip1;
    UILabel *lbtip2;

    // 用户可提现余额
    NSString *available_money;

    DGridView *grid;
}

@property (nonatomic, strong)  BankDeailView *viewBankDetail;

@property (strong, nonatomic)  WTReTextField *tfMoney;

@property (strong, nonatomic)  WTReTextField *tfPwd;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (strong, nonatomic) UIButton *btnSubmit;

@end

@implementation QTSinaWithdrewViewController
{
    BOOL hasCard;

    NSString    *card_no;
    UIView      *tipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"提现";
    self.navigationItem.rightBarButtonItem = nil;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstGetData) name:NOTICEBANK object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"withdrewView"];
    NSDate *now = [NSDate systemDate];

    NSInteger hh = now.components.hour;

    if (hh >= 15) {
        now = [now dayInTheFollowingDay:2];
    } else {
        now = [now dayInTheFollowingDay:1];
    }

//    self.lbTime.text = @[now.shortTimeString, @" 24点前"].joinedString;
    
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"withdrewView"];
}

- (BOOL)navigationShouldPopOnBackButton {
    self.tfMoney.text = @"";
    return YES;
}

- (void)initUI {
    [self initScrollView];
    self.view.backgroundColor = [UIColor redColor];

    self.viewBankDetail = [BankDeailView viewNib];

    grid = [[DGridView alloc]initWidth:APP_WIDTH];
    
    UIImageView *bankImageView = [[UIImageView alloc]initWidth:APP_WIDTH Height:APP_WIDTH*281/620];
    bankImageView.image = [UIImage imageNamed:@"mall_default"];
    [grid addRowView:bankImageView setOffset:0];
    NSDictionary *recashDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"hr_activity"];
//    NSLog(@"recashDict---%@",recashDict);
    QTWebViewController *RecastWebView = [QTWebViewController controllerFromXib];
    if (!recashDict) {
        bankImageView.image = [UIImage imageNamed:@"withdraw_invite"];;
        [bankImageView addTapGesture:^{
            
        RecastWebView.isNeedLogin = YES;
        RecastWebView.url = WEB_URL(@"/user_center/invite");
        [self.navigationController pushViewController:RecastWebView animated:YES];
        }];

    }else{
    
        [bankImageView setImageWithURLString:recashDict.str(@"url")];
        [bankImageView addTapGesture:^{
            
            RecastWebView.url = recashDict.str(@"href");
            RecastWebView.isNeedLogin = YES;
            [self.navigationController pushViewController:RecastWebView animated:YES];
        }];

    }
    
    [grid setColumn:16 height:44];

    [grid addRowView:self.viewBankDetail setOffset:0];
    
    
    [self.viewBankDetail click:^(id value) {
        [self selectBankClick];
    }];

    //
    self.tfMoney = [grid addRowInput:@"提现金额" placeholder:@"提现金额不能小于50" tagText:@"元"];
    [QTTheme tbStyle1:self.tfMoney];
    //
    lbtip2 = [UILabel new];
    lbtip2.backgroundColor = Theme.backgroundColor;
    lbtip2.text = @"";
    [QTTheme lbStyle1:lbtip2];
    lbtip2.font = [UIFont systemFontOfSize:11];
    [QTTheme lbStyleMoney:lbtip2];
    [grid addView:lbtip2 margin:UIEdgeInsetsMake(5, 0, 0, 0)];
    [grid addLineForHeight:5];

    self.tfPwd = [grid addRowInput:@"支付密码" placeholder:@"输入支付密码" tagText:@""];

    [grid addLineForHeight:15];
    WEAKSELF;
    self.btnSubmit = [grid addRowButtonTitle:@"提现" click:^(id value) {
            [weakSelf.tfMoney resignFirstResponder];
            [weakSelf sendClick];
        }];
    [grid addLineForHeight:15];
    lbtip1 = [UILabel new];
    lbtip1.backgroundColor = Theme.backgroundColor;
    [QTTheme lbStyle1:lbtip1];
    lbtip1.font = [UIFont systemFontOfSize:11];
    NSString *tip = @"温馨提示:\n1、身份认证、提现银行卡均设置成功后，才能进行提现操作；\n2、工作日的提现申请，当日审核，到账时间为T+1个工作日。\n3、周末不处理提现，顺延至下一个工作日处理，法定节假日提现另行通知；";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tip];
    [str setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
            Paragraph.lineSpacing = 5;
    }];
    [str setColor:Theme.redColor string:@"温馨提示:"];
    [str setFont:[UIFont systemFontOfSize:14] string:@"温馨提示:"];
    lbtip1.attributedText = str;
    [grid addView:lbtip1 margin:UIEdgeInsetsMake(3, 0, 0, 0)];
    
    
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.isLockPage = YES;
    [self.tfMoney setMoney];
    self.tfMoney.group = 0;

    [self.tfPwd setPwd];
    self.tfPwd.group = 0;

    [self.tfMoney editChange:^(id value) {
        if (self.tfMoney.text.length == 0) {
            [QTTheme btnWhiteStyle:self.btnSubmit];
        } else {
            [QTTheme btnRedStyle:self.btnSubmit];
        }
    }];
    [self firstGetData];
}

- (void)selectBankClick {
    if (!hasCard) {
         HRAddBankViewController *controller = [HRAddBankViewController controllerFromXib];
//        controller.controller = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        QTBankViewController *controller = [QTBankViewController controllerFromXib];
        controller.isSelect = YES;
        controller.bankDelegate = self;
        controller.need_verified = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma  mark - bank
- (void)bankSelect:(NSDictionary *)bankinfo {
    [self.viewBankDetail bind:bankinfo];

    [self getDetail:bankinfo.dic(@"bank_detail")];
    card_no = bankinfo.str(@"card_id");
}

- (void)getDetail:(NSDictionary *)value {

    // 维护中
    UIView *view = [self getNoticeView:value state:QTbankStateQuick_pay];

    if (view) {
        [tipView addSubview:view];

        self.viewBankDetail.isUpdate = YES;

        self.tfMoney.enabled = NO;

        [self.btnSubmit setTitle:@"升级中" forState:UIControlStateDisabled];
    } else {
        [self.btnSubmit setTitle:@"提现" forState:UIControlStateNormal];

        self.tfMoney.enabled = YES;

        [tipView clearSubviews];
    }
}

#pragma  mark - event
- (void)sendClick {
    if (!hasCard) {
        [self showToast:@"请先绑定银行卡"];
        return;
    }
    
    if (![self.view validation:0]) {
        return;
    }

    if ([self.tfMoney.text  doubleValue]<50) {
        [self showToast:@"提现金额不能小于50元"];
        return;
    }

    if ([self.tfMoney.text  doubleValue]> [available_money doubleValue]) {
        [self showToast:@"提现金额不能大于可用金额"];
        return;
    }

    if ([self.tfMoney.text doubleValue] <= 0) {
        [self showToast:@"提现金额不能为0"];
        return;
    }
    
    [self commonJson];
    
}

#pragma  mark - json

- (void)firstGetData {
    [self showHUD];

    // 获取银行卡信息
    [service post:@"bank_withdraw" data:nil complete:^(NSDictionary *value) {
        [self hideHUD];
        
        if (!value) {
            return ;
        }
        
        available_money = value.str(@"available_money");
        NSString *available_moneyStr = [available_money moneyFormatData];
        
        NSString *text = [NSString stringWithFormat:@"账户可用余额: %@ 元", available_moneyStr];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str setColor:Theme.redColor string:available_moneyStr];
        lbtip2.attributedText = str;
        
        // 安全卡
        if (value.dic(@"bank_info")) {
            [self.viewBankDetail safeBind:value.dic(@"bank_info")];
            [self getDetail:value.dic(@"bank_info.bank_detail")];
            card_no = value.str(@"bank_info.card_id");
        } else if (value.arr(@"bank_list").count == 0) {
            hasCard = NO;
            // 无卡
            [self.viewBankDetail reset];
            [self hideHUD];
            return;
        } else {
            hasCard = YES;
            NSDictionary *item = value.arr(@"bank_list").firstObject;
            // 快捷卡
            [self.viewBankDetail bind:item];
            [self getDetail:item.dic(@"bank_detail")];
            card_no = item.str(@"card_id");
            // 安全卡
            for (NSDictionary *item in value.arr(@"bank_list")) {
                if ([item.str(@"safe_card") isEqualToString:@"Y"] ) {
                    [self.viewBankDetail safeBind:item];
                    [self getDetail:item.dic(@"bank_detail")];
                    card_no = item.str(@"card_id");
                }
            }
        }


        [self.btnSubmit setTitle:@"提现" forState:UIControlStateNormal];
        [QTTheme btnWhiteStyle:self.btnSubmit];
        [grid updateView];

        self.tfMoney.enabled = YES;
    }];
}

- (void)commonJson {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"amount"] = [self.tfMoney.text moneyFormatData];
    dic[@"pay_pwd"] = [self.tfPwd.text enValue];
    dic[@"bank_id"] = card_no;

    [service post:@"account_cashapply" data:dic complete:^(NSString *value) {
        [self hideHUD];

        [self showToast:@"操作成功" done:^{
            [self toRecord];
        }];
    }];
}

@end
