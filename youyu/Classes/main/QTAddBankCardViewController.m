//
//  QTAddBankCardViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/23.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTAddBankCardViewController.h"
#import "QTSelectBankViewController.h"
#import "QTSelectProvinceViewController.h"
#import "NSString+Encry.h"
#import "DFormAdd.h"

@interface QTAddBankCardViewController ()<SelectBankDelegate, SelectProvinceDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbtip;

@property (strong, nonatomic)  WTReTextField *tbPerson;

@property (strong, nonatomic)  WTReTextField *tbBranch;

@property (strong, nonatomic)  WTReTextField *tbIDCard;

@property (strong, nonatomic)  WTReTextField *btnBankName;

@property (strong, nonatomic)  WTReTextField *btnProvice;

@property (strong, nonatomic)  WTReTextField *btnCity;

@property (strong, nonatomic)  WTReTextField *btnArea;

@property (strong, nonatomic)  WTReTextField *tfBankAccount;

@property (weak, nonatomic)  WTReTextField *tfValidCode;

@property (strong, nonatomic)  UIButton *btnNext;

@end

@implementation QTAddBankCardViewController
{
    NSString    *selectCityid;
    NSString    *selectProviceid;
    NSString   * selectAreaid;

    NSString    *bankCode;
    NSString    *provice;
    NSString    *city;
    NSString    *area;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"添加银行卡";

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BindBankCardView"];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"BindBankCardView"];
}

#pragma  mark - ui
- (void)initUI {
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addView:self.lbtip margin:UIEdgeInsetsMake(20, 10, 10, 10)];

    self.tbPerson = [grid addRowInput:@"持卡人" placeholder:@""];
    self.tbPerson.enabled = YES;

    self.tbIDCard = [grid addRowInput:@"身份证" placeholder:@""];
    self.tbIDCard.enabled = YES;

    self.btnBankName = [grid addRowSelectText:@"银行" placeholder:@"请选择开户银行" done:^{
            QTSelectBankViewController *controller = [QTSelectBankViewController controllerFromXib];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.btnProvice = [grid addRowSelectText:@"开户省份" placeholder:@"请选择省份" done:^{
            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.type = SelectProvice;
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.btnCity = [grid addRowSelectText:@"开户城市" placeholder:@"请选择城市" done:^{
            if (!provice) {
                [self showToast:@"请选择开户行省份"];
                return;
            }

            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.type = SelectCity;
            controller.ProviceName = provice;
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }];
    
    self.btnArea = [grid addRowSelectText:@"开户地区" placeholder:@"请选择地区" done:^{
        if (!provice) {
            [self showToast:@"请选择开户行城市"];
            return;
        }
        
        QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
        controller.type = SelectArea;
        controller.ProviceName = provice;
        controller.CityName =city;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }];

    
    

    self.tbBranch =[grid addRowInput:@"分行" placeholder:@"请输入分行"];
    
    self.tfBankAccount = [grid addRowInput:@"银行卡" placeholder:@"请输入卡号"];
    
    
    
    self.tfValidCode = [grid addRowCodeText:^(id value) {
        [self clickSendMsg:value];
    }];

    [grid addLineForHeight:20];
    //下一步
    self.btnNext = [grid addRowButtonTitle:@"提交" click:^(id value) {
            [self nextClick];
        }];
    [QTTheme btnRedStyle:self.btnNext];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];

#ifdef  DEBUG
        self.tfBankAccount.text = @"6225160200130761";
#endif
}

- (void)initData {
    self.tbPerson.text = [[GVUserDefaults  shareInstance].realname realNameFormat];
    NSString *cardid = [GVUserDefaults  shareInstance].card_id;
    self.tbIDCard.text = [cardid hideValue:7 end:7];

    [self.tfBankAccount setBankCard];
    self.tfBankAccount.group = 0;
    
    [self.tfValidCode setValidationCode];
    self.tfValidCode.group = 0;

}

#pragma  mark - select
- (void)selectBankCode:(NSString *)code name:(NSString *)name {
    bankCode = code;
    self.btnBankName.text = name;
}

- (void)selectedProvice:(NSDictionary *)value {
    provice = value[@"area_full_name"];
    selectProviceid = value[@"area_full_id"];
    self.btnProvice.text = provice;
}

- (void)selectedCity:(NSDictionary *)value {
    city = value[@"area_name"];
    selectCityid = value[@"area_id"];
    self.btnCity.text = city;
}

-(void)selectedArea:(NSDictionary *)value
{
    area = value[@"area_name"];
    selectAreaid = value[@"area_id"];
    self.btnArea.text = area;

}

#pragma  mark - event
- (void)nextClick {
    if ([bankCode stringValue].length == 0) {
        [self showToast:@"请选择开户银行"];
        return;
    }

    if (!provice) {
        [self showToast:@"请选择开户行所在省份"];
        return;
    }

    if (!city) {
        [self showToast:@"请选择开户行所在城市"];
        return;
    }
    
    if (!area) {
        [self showToast:@"请选择开户行所在地区"];
        return;
    }
    
    if (self.tfValidCode.text.length==0) {
        [self showToast:@"请输入验证码"];
        return;
    }

    if (![self.view validation:0]) {
        return;
    }

    [self commonJson];
}


#pragma  mark - event
- (void)clickSendMsg:(id)value {
    
    [self commonJsonMsg];
}


#pragma  mark - json
- (void)commonJson {
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"bank_code"] = bankCode;
    dic[@"bank_account"] = self.tfBankAccount.text;
    dic[@"province_id"] = selectProviceid;
    dic[@"city_id"] = selectCityid;
    dic[@"area_id"]=selectAreaid;
    dic[@"branch"]=self.tbBranch.text;
    dic[@"sms_code"]=self.tfValidCode.text;
    dic[@"type"] = @"1";
    [service post:@"bank_binding" data:dic complete:^(NSDictionary *value) {
        NSString *msg = value.str(@"message");
        NSString *status = value.str(@"status");
        if ([status isEqualToString:@"2"]) {
            [self hideHUD];
            [self showToast:msg duration:2];
        }else{
            [MobClick event:@"BindBankCardBt"];
            [self hideHUD];
            NOTICE_POST(NOTICEBANK);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (void)commonJsonMsg {
    [self showHUD:@"正在发送..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"phone"] = [GVUserDefaults shareInstance].phone;
    dic[@"sms_type"] = @"bank_edit";
    dic[@"trackid"] = TRACKID;
    
    // 如果出现发送错误，需要禁止按钮的倒计时
    [service post:@"sms_send" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:MSGTIP duration:3];
    }];
}

@end
