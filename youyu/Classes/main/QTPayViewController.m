//
//  QTPayViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTPayViewController.h"
#import "QTBankViewController.h"
#import "BankModel.h"
#import "QTInvestViewController.h"
#import "QTWebViewController.h"
#import "QTBaseViewController+BankDetail.h"
#import "BankDeailView.h"
#import "QTAddBankCardViewController.h"
#import "TimeCodeButton.h"

#import "DFormAdd.h"
#import "MXMarqueeView.h"
#import "HRBindBankViewController.h"
#import "HRAddBankViewController.h"

#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>

@interface QTPayViewController ()<BankDelegate, UIAlertViewDelegate>
{
    UILabel *lbtip1;
    UILabel *lbtip2;

    NSString *card_no;

    BOOL hasCard;
    
    NSString *bankCardNO;
}

@property (nonatomic, strong)  BankDeailView *viewBankDetail;

@property (strong, nonatomic)  WTReTextField *tfMoney;

@property (strong, nonatomic)  UIButton *btnSumbit;

@end

@implementation QTPayViewController
{
    BOOL        isValidte;
    DStackView  *stack;

    UIView *tipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"充值";
    self.navigationItem.rightBarButtonItem = nil;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstGetData) name:NOTICEBANK object:nil];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    [self initData];
    [MobClick beginLogPageView:@"payView"];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"payView"];
}

- (void)initUI {
    [self initScrollView];

    self.viewBankDetail = [BankDeailView viewNib];

    stack = [[DStackView  alloc]initWidth:APP_WIDTH];
    tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 20)];
    tipView.backgroundColor = Theme.backgroundColor;
    [stack addView:tipView];

    [stack addView:self.viewBankDetail];

    [self.viewBankDetail click:^(id value) {
        [self selectBankClick];
    }];
    lbtip1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 60)];
    lbtip1.text = @"";
    lbtip1.backgroundColor = Theme.backgroundColor;
    [QTTheme lbStyle1:lbtip1];
    [stack addView:lbtip1 margin:UIEdgeInsetsMake(5, 16, 5, 16)];

    //

    DGridView *moneyGrid = [[DGridView alloc]initWidth:stack.width];
    [moneyGrid setColumn:16 height:44];
    moneyGrid.backgroundColor = [UIColor whiteColor];
    self.tfMoney = [moneyGrid addRowInput:@"金 额" placeholder:@"输入充值金额 > 0" tagText:@"元"];

    [stack addView:moneyGrid];

    //

    [QTTheme tbStyle1:self.tfMoney];

    //
    lbtip2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 30)];
    lbtip2.text = @"";
    lbtip2.backgroundColor = Theme.backgroundColor;

    [QTTheme lbStyle1:lbtip2];
    [stack addView:lbtip2 margin:UIEdgeInsetsMake(5, 16, 5, 16)];

    WEAKSELF;
    self.btnSumbit = [stack addRowButtonTitle:@"充值" click:^(id value) {
            [weakSelf sendClick];
        }];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.isLockPage = YES;
    self.tfMoney.group = 0;
    [self.tfMoney setMoney];

    [self firstGetData];
}

#pragma  mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self toRecord];
        } else {
            [self toInvest];
        }
    } else {
        if (buttonIndex == 1) {
            [self.view endEditing:YES];
            [self commonJson];
        }
    }
}

#pragma  mark - bank
- (void)bankSelect:(NSDictionary *)bankinfo {
    [self.viewBankDetail bind:bankinfo];

    [self getDetail:bankinfo.dic(@"bank_detail")];
    card_no = bankinfo.str(@"card_id");
}

- (void)getDetail:(NSDictionary *)value {
    lbtip1.text = [NSString stringWithFormat:@"首次绑卡限额: %@ 元\n单笔限额: %@ 元\n每日限额: %@ 元", [value.str(@"first_pay") moneyFormatShow], [value.str(@"each_pay") moneyFormatShow], [value.str(@"daily_pay") moneyFormatShow]];

    // 维护中
    UIView *view = [self getNoticeView:value state:QTbankStateQuick_pay];

    if (view) {
        [tipView addSubview:view];

        self.viewBankDetail.isUpdate = YES;

        self.tfMoney.enabled = NO;

        [self.btnSumbit setTitle:@"升级中" forState:UIControlStateDisabled];
    } else {
        [self.btnSumbit setTitle:@"充值" forState:UIControlStateNormal];

        self.tfMoney.enabled = YES;

        [tipView clearSubviews];
    }
}

#pragma  mark - event

- (void)sendClick {
    if (!self.viewBankDetail.isSelected) {
        [self showToast:@"请选择银行卡"];
        return;
    }

    if ([self.tfMoney.text floatValue] <= 0) {
        [self showToast:@"请输入金额"];
        return;
    }

    if (![self.view validation:0]) {
        return;
    }

    [self.view endEditing:YES];
    [self commonJson];
}

- (void)selectBankClick {
    if (!hasCard) {
        HRAddBankViewController *controller = [HRAddBankViewController controllerFromXib];
//        QTAddBankCardViewController *controller = [QTAddBankCardViewController controllerFromXib];
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

#pragma  mark - json
- (void)firstGetData {
    [self showHUD];

    // 获取银行卡列表
    [service post:@"bank_list" data:nil complete:^(NSDictionary *value) {
//        NSLog(@"充值-------%@" ,value);
        if (!value) {
            return ;
        }
        if (((NSArray *)value[@"bank_list"]).count == 0) {
            hasCard = NO;
            // 无卡
            [self.viewBankDetail reset];
            [self hideHUD];
            return;
        } else {
            hasCard = YES;
            NSDictionary *item = value.arr(@"bank_list").firstObject;
            // 无安全卡
            [self.viewBankDetail bind:item.dic(@"bank_info")];
            [self getDetail:item.dic(@"bank_info.bank_detail")];

            card_no = item.str(@"bank_info.card_id");
            bankCardNO = item[@"bank_info"][@"account"];

            // 安全卡
            for (NSDictionary *item in value.arr(@"bank_list")) {
                if (![item.str(@"bank_info.safe_card") isEqualToString:@"N"] ) {
                    [self.viewBankDetail safeBind:item.dic(@"bank_info")];
                    [self getDetail:item.dic(@"bank_info.bank_detail")];
                    card_no = item.str(@"bank_info.card_id");
                    bankCardNO = item[@"bank_info"][@"account"];
                }
            }
        }

        [self hideHUD];
    }];
}

//支付
- (void)commonJson {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"amount"] = self.tfMoney.text;
    dic[@"bank_id"] = card_no;
    [service post:@"account_fuiourechargeapply" data:dic complete:^(NSMutableDictionary *value) {
        [self hideHUD];

        [value removeObjectForKey:@"version"];
        for (NSString *key in value.allKeys) {
            if ([value[key] isKindOfClass:[NSNull class]]) {
                value[key]=@"";
            }
        }
//        [self initOrder:value];
        [self pay:value];
    }];
}

- (void)initOrder:(NSDictionary *)obj {
    [LLPaySdk sharedSdk].sdkDelegate = self;

    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
    withPayType     :LLPayTypeVerify
    andTraderInfo   :obj];
}

#pragma - mark 支付结果 LLPaySdkDelegate
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"";
    
//    NSLog(@"%@",dic);
    
    [self showToast:dic[@"ret_msg"] duration:2];
    switch (resultCode) {
        case kLLPayResultSuccess:
            {
                msg = @"成功";

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"充值申请提交成功" delegate:self cancelButtonTitle:@"查看记录" otherButtonTitles:@"投资", nil];
                [alert clickedIndex:^(NSInteger index) {
                    if (index == 0) {
                        [self toRecord];
                    } else {
                        [self toInvest];
                    }
                }];

                [alert show];
            } break;

        case kLLPayResultFail:
            {
                msg = @"失败";
            } break;

        case kLLPayResultCancel:
            {
                msg = @"取消";
            } break;

        case kLLPayResultInitError:
            {
                msg = @"sdk初始化异常";
            } break;

        case kLLPayResultInitParamError:
            {
                msg = dic[@"ret_msg"];
            } break;

        default:
            break;
    }
}

#pragma mark -富友相关

/*
 * 富友支付
 */

- (void) pay:(NSDictionary *) valueDic {
    
    GVUserDefaults *user = [GVUserDefaults shareInstance];
    NSString * mchntCd = valueDic[@"mchnt_cd"];
    NSString * bankCard = bankCardNO;
    NSString * userId = user.user_id;
    int amoutn = [valueDic[@"money"] floatValue] * 100;
    NSString * amt =  [NSString stringWithFormat:@"%d",amoutn];
    NSString * mchntOrdId = valueDic[@"oredernumber"];
    NSString * idNo = user.card_id;
    NSString * name = user.realname;

    
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"];
    NSString * myMCHNTCD = mchntCd;
    NSString * myMCHNTORDERID = mchntOrdId;
    NSString * myUSERID = userId;
    NSString * myAMT = amt;
    NSString * myBANKCARD = bankCard;
    NSString * myBACKURL = valueDic[@"back_url"];
    NSString * myNAME = name;
    NSString * myIDNO = idNo;
    NSString * myIDTYPE = @"0";
    NSString * myTYPE = [NSString stringWithFormat:@"02"];
    NSString * mySIGNTP = [NSString stringWithFormat:@"MD5"];
    NSString * myMCHNTCDKEY = valueDic[@"mchnt_key"];
    
    NSString * mySIGN = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@", myTYPE,myVERSION,myMCHNTCD,myMCHNTORDERID,myUSERID,myAMT,myBANKCARD,myBACKURL,myNAME,myIDNO,myIDTYPE,myMCHNTCDKEY];
//    NSLog(@"sign = %@",mySIGN);
    mySIGN = [mySIGN MD5String];
    
    //添加环境参数  BOOL 变量 @"TEST"   YES 是测试  NO 是生产
    BOOL test = NO ;
#ifdef DEBUG
    test = YES;
#endif
    NSNumber * testNumber = [NSNumber numberWithBool:test];
    
    NSDictionary * dicD = @{@"TYPE":myTYPE,@"VERSION":myVERSION,@"MCHNTCD":myMCHNTCD,@"MCHNTORDERID":myMCHNTORDERID,@"USERID":myUSERID,@"AMT":myAMT,@"BANKCARD":myBANKCARD,@"BACKURL":myBACKURL,@"NAME":myNAME,@"IDNO":myIDNO,@"IDTYPE":myIDTYPE,@"SIGNTP":mySIGNTP,@"SIGN":mySIGN , @"TEST" : testNumber} ;
//    NSLog(@"😄dicD =%@ " , dicD);
    
    if (!TARGET_IPHONE_SIMULATOR) {
        FUMobilePay * pay = [FUMobilePay shareInstance];
        if([pay respondsToSelector:@selector(mobilePay:delegate:)])
            [pay performSelector:@selector(mobilePay:delegate:) withObject:dicD withObject:self];
    }
}

-(void) payCallBack:(BOOL) success responseParams:(NSDictionary*) responseParams{
//    NSLog(@"fuiouPay");

//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseParams[@"RESPONSEMSG"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    if ([responseParams[@"RESPONSECODE"] isEqualToString:@"0000"]) {
        [self showToast:@"充值成功" duration:3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }else{
        [self showToast:responseParams[@"RESPONSEMSG"] duration:3];
    }
}

@end
