//
//  QTWithdrewViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTWithdrewViewController.h"
#import "QTBankViewController.h"
#import "BankModel.h"
#import "NSDate+RMCalendarLogic.h"
#import "QTRecordViewController.h"
#import "BankDeailView.h"
#import "QTBaseViewController+BankDetail.h"
#import "QTAddBankCardViewController.h"
#import "QTPasswordView.h"
#import "DFormAdd.h"
#import "SinaView.h"

@interface QTWithdrewViewController ()<BankDelegate, UIAlertViewDelegate>
{
    UILabel *lbtip1;
    UILabel *lbtip2;
    UILabel *lbtip3;

    DStackView *stack;

    /**
     *  用户可提现余额
     */
    float available_money;

    UIView *tipView;
}

@property (strong, nonatomic)  BankDeailView *viewBankDetail;

@property (strong, nonatomic) IBOutlet UIView   *secondView;
@property (strong, nonatomic)  WTReTextField    *tfMoney;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (strong, nonatomic) UIButton *btnSubmit;

@end

@implementation QTWithdrewViewController
{
    QTPasswordView *passwordview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.navigationItem.rightBarButtonItem = nil;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstGetData) name:NOTICEBANK object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSDate *now = [NSDate systemDate];

    NSInteger hh = now.components.hour;

    if (hh >= 15) {
        now = [now dayInTheFollowingDay:2];
    } else {
        now = [now dayInTheFollowingDay:1];
    }

    self.lbTime.text = [NSString stringFromDate:now Format:@"yyyy-MM-dd"].add(@" 24点前");
}

- (BOOL)navigationShouldPopOnBackButton {
    self.tfMoney.text = @"";
    return YES;
}

- (void)initUI {
    [self initScrollView];
    self.viewBankDetail = [BankDeailView viewNib];

    stack = [[DStackView  alloc]initWidth:APP_WIDTH];

    //
    tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 20)];
    tipView.backgroundColor = Theme.backgroundColor;
    [stack addView:tipView];
    [stack addView:self.viewBankDetail];

    [self.viewBankDetail click:^(id value) {
        [self selectBankClick];
    }];

    [stack addLineForHeight:20];

    //
    DGridView *timeGrid = [[DGridView alloc]initWidth:stack.width];
    [timeGrid setColumn:16 height:44];
    timeGrid.backgroundColor = [UIColor whiteColor];
    self.lbTime = [timeGrid addRowText:@"预计到账时间" text:@""];
    [stack addView:timeGrid];

    //
    lbtip1 = [UILabel new];
    NSString *tip = @"15:00之前的提现,到账时间为T+1日\n15:00之后的提现,到账时间为T+2日";
    [QTTheme lbStyle1:lbtip1];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tip];
    [str setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 3;
    }];
    lbtip1.attributedText = str;
    [stack addView:lbtip1 margin:UIEdgeInsetsMake(5, 16, 8, 16)];

    //

    DGridView *moneyGrid = [[DGridView alloc]initWidth:stack.width];
    [moneyGrid setColumn:16 height:44];
    moneyGrid.backgroundColor = [UIColor whiteColor];
    self.tfMoney = [moneyGrid addRowText:@"提现金额" placeholder:@"输入提现金额" tagText:@"元"];
    [stack addView:moneyGrid];

    [QTTheme tbStyle1:self.tfMoney];
    //
    lbtip2 = [UILabel new];
    lbtip2.backgroundColor = Theme.backgroundColor;
    lbtip2.text = @"";
    [QTTheme lbStyle1:lbtip2];

    // lbtip2.text = @"存钱罐可用余额: 0.00 元\n单笔限额: 5万元\n每日限提: 10次";
    [QTTheme lbStyleMoney:lbtip2];
    //
    [stack addView:lbtip2 margin:UIEdgeInsetsMake(5, 16, 0, 16)];

    lbtip3 = [[UILabel alloc]init];
    lbtip3.text = @"提现手续费:￥2.00(由平台代付)";

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:lbtip3.text];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7, 4)];
    lbtip3.attributedText = attributedString;

    lbtip3.backgroundColor = Theme.backgroundColor;
    [QTTheme lbStyle1:lbtip3];
    [stack addView:lbtip3 margin:UIEdgeInsetsMake(3, 16, 0, 16)];

    [stack addLineForHeight:20];

    WEAKSELF;
    self.btnSubmit = [stack addRowButtonTitle:@"提现" click:^(id value) {
            [weakSelf.tfMoney resignFirstResponder];
            [weakSelf sendClick];
        }];

    [QTTheme btnRedStyle:self.btnSubmit];

    [stack addView:[SinaView viewNib]];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.isLockPage = YES;
    [self.tfMoney setMoney];
    self.tfMoney.group = 0;

    [self firstGetData];
}

- (void)showPwd {
    passwordview = [QTPasswordView viewNib];
    [passwordview initMoney:[self.tfMoney.text moneyFormatData] cancel:^(id sender) {
        [self hideCustomHUB];
    } ok:^(id sender) {
        [self submitClick];
    }];

    [self showCustomHUD:passwordview];
}

#pragma  mark - bank
- (void)bankSelect:(NSDictionary *)bankinfo {
    [self.viewBankDetail bind:bankinfo];
    [self getDetail:bankinfo.dic(@"bank_detail")];
}

- (void)getDetail:(NSDictionary *)value {
    NSString *available_moneyStr = [[@(available_money)stringValue] moneyFormatData];

    NSString *text = [NSString stringWithFormat:@"存钱罐可用余额: %@ 元\n单笔限额: 5万元\n每日限提: 10次", available_moneyStr];

    NSString *now = [[SystemConfigDefaults  new].server_time dateValue];

    if ([now compareExpression:@" self >= '2016-02-05' && self <= '2016-02-13'"]) {
        text = [NSString stringWithFormat:@"存钱罐可用余额: %@ 元\n2月5日-2月13日限额: 单笔5W,单日10W", available_moneyStr];
    }

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str setColor:Theme.redColor string:available_moneyStr];
    [str setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 3;
    }];

    lbtip2.attributedText = str;

    // 维护中
    UIView *view = [self getNoticeView:value state:QTbankStateCash_apply];

    if (view) {
        [tipView addSubview:view];

        self.viewBankDetail.isUpdate = YES;

        [QTTheme btnGrayStyle:self.btnSubmit];

        [self.btnSubmit setTitle:@"升级中" forState:UIControlStateDisabled];

        self.tfMoney.enabled = NO;
    } else {
        [self.btnSubmit setTitle:@"提现" forState:UIControlStateNormal];
        [QTTheme btnRedStyle:self.btnSubmit];

        self.tfMoney.enabled = YES;
        [tipView clearSubviews];
    }
}

#pragma  mark - event
- (void)sendClick {
    if (!self.viewBankDetail.isSelected) {
        [self showToast:@"请选择提现银行卡"];
        return;
    }

    if (![self.view validation:0]) {
        return;
    }

    if ([self.tfMoney.text floatValue] > available_money) {
        [self showToast:@"提现金额不能大于可用金额"];
        return;
    }

    if ([self.tfMoney.text floatValue] <= 0) {
        [self showToast:@"提现金额不能为0"];
        return;
    }

    [self showPwd];
}

- (void)selectBankClick {
    [self showHUD];
    [service post:@"bank_list" data:nil complete:^(id value) {
        NSArray *bank_list = value[@"bank_list"];

        if (bank_list.count == 0) {
            QTAddBankCardViewController *controller = [QTAddBankCardViewController controllerFromXib];
            controller.controller = self;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            QTBankViewController *controller = [QTBankViewController controllerFromXib];
            controller.isSelect = YES;
            controller.bankDelegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }

        [self hideHUD];
    }];
}

- (void)submitClick {
    NSString *payPwd = passwordview.password;

    if (payPwd.length == 0) {
        [self showToast:@"请输入支付密码"];
        return;
    }

    if ((payPwd.length < 6) || (payPwd.length > 24)) {
        [self showToast:@"支付密码应为6-24位字符"];
        return;
    }

    [self commonJson];
}

- (void)getTip {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"申请提现成功，等待银行处理" delegate:self cancelButtonTitle:@"查看提现记录" otherButtonTitles:nil];

    [alert clickedIndex:^(NSInteger index) {
        [self.view endEditing:YES];
        QTRecordViewController *controller = [QTRecordViewController controllerFromXib];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [alert show];

    [self hideHUD];
}

#pragma  mark - json

- (void)commonJson {
    [self.view endEditing:YES];
    [self showHUD:@"正在提现..."];
    // 提现
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"amount"] = [self.tfMoney.text moneyFormatData];
    dic[@"bank_id"] = self.viewBankDetail.bankid;
    dic[@"pay_pwd"] = [passwordview.password enValue];
    dic[@"notify_url"] = CASH_NOTICE_RUL;
    [service post:@"account_cashapply" data:dic complete:^(id value) {
        [self hideCustomHUB];

        [self performSelector:@selector(getTip) withObject:nil afterDelay:0.7];
    }];
}

- (void)firstGetData {
    [self showHUD];
    // 获取银行卡信息
    [service post:@"bank_withdraw" data:nil complete:^(NSDictionary *value) {
        [self hideHUD];
        available_money = value.fl(@"available_money");

        if (value[@"bank_list"]) { // 无安全卡
            if (((NSArray *)value[@"bank_list"]).count == 0) {
                [self.viewBankDetail reset];

                NSString *text = [NSString stringWithFormat:@"存钱罐可用余额: %@ 元\n", [[@(available_money)stringValue] moneyFormatData]];
                // 颜色
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
                [text matchFirst:kRegNumber done:^(NSRange range) {
                    [str addAttribute:NSForegroundColorAttributeName value:Theme.redColor range:range];
                }];
                lbtip2.attributedText = str;

                [self hideHUD];
                return;
            } else {
                NSDictionary *bank_info = (value.arr(@"bank_list").firstObject)[@"bank_info"];
                [self bankSelect:bank_info];
            }
        } else {   //有安全卡
            NSDictionary *bank_info = value[@"bank_info"];

            if (!bank_info) {
                [self.viewBankDetail reset];
            } else {
                [self.viewBankDetail safeBind:bank_info];
                [self getDetail:bank_info.dic(@"bank_detail")];
            }
        }
    }];
}

@end
