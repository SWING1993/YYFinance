//
//  QTInvestGetViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/31.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestGetViewController.h"

#import "QTPayViewController.h"
#import "UIViewController+page.h"
#import "DFormAdd.h"
#import "QTSelectCouponViewController.h"
#import "QTWebViewController.h"
#import "HRYHTWebViewController.h"
//#import "YHTTokenManager.h"
//#import "YHTContractContentViewController.h"

@interface QTInvestGetViewController ()<QTSelectCouponDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbtbCanMoney;

@property (strong, nonatomic) IBOutlet UILabel *lbyuer;

@property (strong, nonatomic)  WTReTextField *tfMoney;

@property (strong, nonatomic)  WTReTextField *selCoupon;

@property (strong, nonatomic)  WTReTextField *selQuan;

@property (strong, nonatomic) IBOutlet UILabel *lbAllMoney;

@property (strong, nonatomic) UIButton *btnSubmit;

@property (weak, nonatomic)  WTReTextField *tfPwd;

@property (nonatomic, strong)NSNumber *contractID;

@end

@implementation QTInvestGetViewController
{
    NSArray *couponArray;

    NSArray *quanArray;

    NSDictionary *selectCoupon;

    NSDictionary *selectQuan;

    float use_money;
    NSString *tender_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    [grid setColumn:16 height:44];
    grid.backgroundColor = Theme.backgroundColor;

    [grid addView:self.lbtbCanMoney margin:UIEdgeInsetsMake(8, 0, 8, 0)];

    [grid addView:self.lbyuer RowClickButtonTitle:@"去充值" click:^(id value) {
        [self toPay];
    }];
    
    self.tfMoney = [grid addRowInput:@"投资金额" placeholder:@"请输入金额" tagText:@"元" doneBlock:^(id value) {
        [self autoWrite];
    }];
    
    // 加息 红包

    self.selCoupon = [grid addRowSelectText:@"红包" placeholder:@"请选择红包" done:^{
            if (self.tfMoney.text.length == 0) {
                [self showToast:@"请输入金额"];
            } else {
                
                if ([self.selQuan.text isEqualToString:@""]) {
                    QTSelectCouponViewController *controller = [QTSelectCouponViewController controllerFromXib];
                    controller.money = self.tfMoney.text;
                    controller.delegate = self;
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    dic[@"coupon_list"] = couponArray;
                    controller.value = dic;
                    [self.navigationController pushViewController:controller animated:YES];

                }else{
                
                    self.selCoupon.enabled = NO;
                    [self showToast:@"红包和年化券不可同时使用" duration:2];
                }
            }
        }];

    // 加息

    self.selQuan = [grid addRowSelectText:@"年化券" placeholder:@"请选择年化券" done:^{
            if (self.tfMoney.text.length == 0) {
                [self showToast:@"请输入金额"];
            } else {
                
                if ([self.selCoupon.text isEqualToString:@""]) {
                    QTSelectCouponViewController *controller = [QTSelectCouponViewController controllerFromXib];
                    controller.money = self.tfMoney.text;
                    controller.delegate = self;
                    controller.cellH = 70;
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    dic[@"coupon_list"] = quanArray;
                    controller.value = dic;
                    [self.navigationController pushViewController:controller animated:YES];

                }else{
                
                    self.selQuan.enabled = NO;
                    [self showToast:@"红包和年化券不可同时使用" duration:2];
                }
            }
        }];

    self.tfPwd = [grid addRowInput:@"支付密码" placeholder:@"请输入密码"];

    [grid addView:self.lbAllMoney margin:UIEdgeInsetsMake(8, 0, 0, 0)];

    __weak typeof(self) weakSelf = self;

    self.btnSubmit = [grid addRowButtonTitle:@"投资" click:^(id value) {
            [weakSelf submitClick];
        }];

    [self addBottomView:self.btnSubmit padding:UIEdgeInsetsMake(0, 16, 5, 16)];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.lbtbCanMoney.text = @[@"项目可投金额: ", [self.borrowInfro.str(@"invest_balance") moneyFormatShow], @"元"].joinedString;
    [QTTheme lbStyleMoney:self.lbtbCanMoney];

    self.tfMoney.delegate = self;

    [self.tfMoney setPositiveInteger:0];
    self.tfMoney.group = 0;
    [self getTotalMoney];

    [self.tfPwd setPwd];
    self.tfPwd.group = 0;
    self.tfPwd.errorTip = @"支付密码应为6-24位字符";
    self.tfPwd.nilTip = @"请输入支付密码";

    [self bindKeyPath:@"text" object:self.selCoupon block:^(id newobj) {
        [self getTotalMoney];
    }];

    [self.tfMoney editChange:^(id value) {
        [self getTotalMoney];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self showHUD];
    [self commonJsonGet];
}

#pragma mark - select
- (void)didselectCoupon:(NSDictionary *)obj {
    
    if ([obj containsKey:@"reward_info"]) {
        if (obj) {
            self.selCoupon.text = [NSString stringWithFormat:@"%@元红包", obj.str(@"reward_info.money")];
        } else {
            self.selCoupon.text = @"";
        }
        
        selectCoupon = obj;
        [self getTotalMoney];
    } else if ([obj containsKey:@"user_coupon_info"]){
        if (obj) {
            self.selQuan.text = [NSString stringWithFormat:@"%@ %%有效期至:(%@)", [obj.str(@"user_coupon_info.coupon") moneyFormatShow], [obj.str(@"user_coupon_info.timeout") dateValue]];
        } else {
            self.selCoupon.text = @"";
        }
        
        selectQuan = obj;
        [self getTotalMoney];
    }else{
        selectCoupon = obj;
        selectQuan = obj;
        self.selCoupon.text = @"";
        self.selQuan.text = @"";
    }
}

#pragma  mark - text

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self getTotalMoney];
}

#pragma  mark - auto

/**
 *  自动填写
 */
- (void)autoWrite {
    // =============================金额====================================
    if (use_money >= self.borrowInfro.d(@"invest_balance")) {
        self.tfMoney.text = [self.borrowInfro.str(@"invest_balance") moneyFormatDataWithIntegerValue];
    } else {
        self.tfMoney.text = [[NSString stringFormValue:use_money] moneyFormatDataWithIntegerValue];
    }

    [self getTotalMoney];
}

/**
 *  计算投资总额
 */
- (double)getTotalMoney {
    float allMoney = 0;

    if ([selectCoupon containsKey:@"reward_info"]) {
        allMoney = [self.tfMoney.text floatValue] + selectCoupon.fl(@"reward_info.money");
    } else {
        allMoney = [self.tfMoney.text floatValue];
    }

    NSString *money = [[NSString stringWithFormat:@"%f", allMoney] moneyFormatShowWithInt];

    self.lbAllMoney.text = [NSString stringWithFormat:@"投资总额: %@元", money];
    [QTTheme lbStyleMoney:self.lbAllMoney];

    return allMoney;
}

#pragma  mark - event

- (void)submitClick {
    
    
    if (![self.view validation:0]) {
        return;
    }

    [self commonJsonSina];
}

#pragma  mark - json

- (void)commonJsonGet {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"borrow_id"] = self.borrowInfro.str(@"id");
    [service post:@"borrow_userinfo" data:dic complete:^(NSDictionary *value) {
        use_money = value.fl(@"user_account.use_money");
        self.lbyuer.text = [NSString stringWithFormat:@"可用余额: %@元", [[NSString stringFormValue:use_money] moneyFormatShow]];
        [QTTheme lbStyleMoney:self.lbyuer];

        if (self.borrowInfro.str(@"invest_user_ids").length > 0) {
            // vip 不使用红包加息券
        } else {
            // 优惠券
            couponArray = value.arr(@"user_account.reward_list");
            quanArray = value.arr(@"user_account.user_coupon_list");
            [self setTextFiledPalceholder];
        }

        [self hideHUD];
    }];
}

- (void)setTextFiledPalceholder{
    
    if (couponArray.count==0) {
        self.selCoupon.placeholder = @"无可使用红包";
    }else{
        
        self.selCoupon.placeholder = [NSString stringWithFormat:@"%ld个未使用红包",(unsigned long)couponArray.count];
    }
    if (quanArray.count==0) {
        self.selQuan.placeholder = @"无可使用年化券";
    }else{
        
        self.selQuan.placeholder = [NSString stringWithFormat:@"%ld张可使用的加息卷",(unsigned long)quanArray.count];
    }
}

- (void)commonJsonSina {
    [self.view endEditing:YES];
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"borrow_id"] = self.borrowInfro.str(@"id");
    dic[@"tender_money"] = [[NSString stringFormValue:[self getTotalMoney]] moneyFormatDataWithIntegerValue];

    if ([selectCoupon containsKey:@"reward_info"]) {
        dic[@"reward_id"] = selectCoupon.str(@"reward_info.id");
    } else {
        dic[@"reward_id"] = @"";
    }

    if ([selectQuan containsKey:@"user_coupon_info"]) {
        dic[@"coupon_id"] = selectQuan.str(@"user_coupon_info.id");
    } else {
        dic[@"coupon_id"] = @"";
    }

    dic[@"return_url"] = RETURN_URL(@"app_recordOrder");
    dic[@"paypassword"] = [self.tfPwd.text enValue];
//    [service post:@"borrow_tenderpay" data:dic complete:^(NSString *value) {
//        [self hideHUD];
//        [self showToast:@"投资成功" done:^{
//            [self toInvestRecord];
//        }];
//    }];

    [service post:@"borrow_tenderpay" data:dic complete:^(NSDictionary *value) {
        [MobClick event:@"InvestBt"];
        tender_id = value.str(@"tenderId");
        [service post:@"borrow_yunHeJudge" data:nil complete:^(NSDictionary *value) {
//            NSLog(@"yuhetong-----%@",value);
            NSString *isHasYHT = value.str(@"type");
            if ([isHasYHT isEqualToString:@"1"]) {
                [self hideHUD];
                [self showToast:@"投资成功" done:^{
                    [self toInvestRecord];
                }];
                
            }else{
                DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"提示" message:@"投资成功，查看合同"];
                
                [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    [self toInvestRecord];
                }];
                
                [alert addActionWithTitle:@"立即签署" handler:^(CKAlertAction *action) {
                   [self commonJsonYHT];
                }];
                [alert show];
               
            }
        }];
    }];
}

-(void)commonJsonYHT {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"borrow_id"] = self.borrowInfro.str(@"id");
    dict[@"tender_id"] = tender_id;
    [service post:@"borrow_yunHeTong" data:dict complete:^(NSDictionary *value) {
        if (!value) {
            return ;
        }
        NSString *message = value.str(@"messageYun");
        if ([message isEqualToString:@"成功"]) {
            QTWebViewController *webView = [QTWebViewController new];
            NSMutableString *__urlStr = [NSMutableString stringWithString:value.str(@"IOSURL")];
            [__urlStr appendFormat:@"?contractId=%@", value.str(@"contractId")];
            [__urlStr appendFormat:@"&token=%@",value[@"lastToken"]];
            [__urlStr appendFormat:@"&noticeParams=%@",tender_id];
            webView.url = __urlStr;
            webView.isScale = YES;
            [self.navigationController pushViewController:webView animated:YES];
        }else if (message ){
            [self showToast:message done:^{
                [self toInvestRecord];
            }];
        }
        [self hideHUD];
    }];
}

@end
