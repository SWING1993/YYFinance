//
//  HRRegisterViewController.m
//  hr
//
//  Created by 慧融 on 19/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRBindBankViewController.h"
#import "HRSetPayPwdViewController.h"
#import "NSString+IDCardFormat.h"
#import "DAlertViewController+attributeString.h"
#import "QTSelectProvinceViewController.h"
#import "QTPayResetPwdViewController.h"

@interface HRBindBankViewController ()<UITextFieldDelegate, SelectProvinceDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *tintLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) WTReTextField *tfName;
@property (strong, nonatomic) WTReTextField *tfIDCard;
@property (strong, nonatomic) WTReTextField *tfBankCard;

//@property (strong, nonatomic) WTReTextField *btnProvice;
//@property (strong, nonatomic) WTReTextField *btnCity;
//@property (strong, nonatomic) WTReTextField *btnArea;
//@property (strong, nonatomic) WTReTextField *tfBranch;

@property (strong, nonatomic) IBOutlet UIButton *rightBt;

@end

@implementation HRBindBankViewController{
    
    UILabel *IdCardlabel;
    UILabel *nameTipLabel;
    
    //    NSString    *selectCityid;
    //    NSString    *selectProviceid;
    //    NSString    *selectAreaid;
    //
    //    NSString    *provice;
    //    NSString    *city;
    //    NSString    *area;
}

//- (void)selectedProvice:(NSDictionary *)value {
//    provice = value[@"area_full_name"];
//    selectProviceid = value[@"area_full_id"];
////    self.btnProvice.text = provice;
//    provice = !IPHONE5 ? [NSString stringWithFormat:@"    %@",provice] : provice;
//    self.btnProvice.attributedText = [self strWithSelectedStr:provice title:@"省份"];
//    provice = value[@"area_full_name"];
//}
//
//- (void)selectedCity:(NSDictionary *)value {
//    city = value[@"area_name"];
//    selectCityid = value[@"area_id"];
////    self.btnCity.text = city;
//    city = !IPHONE5 ? [NSString stringWithFormat:@"    %@",city] : city;
//    self.btnCity.attributedText = [self strWithSelectedStr:city title:@"城市"];
//    city = value[@"area_name"];
//}
//
//-(void)selectedArea:(NSDictionary *)value
//{
//    area = value[@"area_name"];
//    selectAreaid = value[@"area_id"];
////    self.btnArea.text = area;
//    area = !IPHONE5 ? [NSString stringWithFormat:@"    %@",area] : area;
//    self.btnArea.attributedText = [self strWithSelectedStr:area title:@"地区"];
//    area = value[@"area_name"];
//}

//处理选择的省市区数据
//- (NSMutableAttributedString *)strWithSelectedStr:(NSString *)selectedStr title:(NSString *)title {
//    NSString *whiteSpace = @"             ";//13
//    NSString *str1 = [NSString stringWithFormat:@"%@%@%@",title,whiteSpace,selectedStr];
//    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc]initWithString:str1];//13个空格
//    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
//    [attributedStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(15, selectedStr.length)];
//    [attributedStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,2)];//[UIFont systemFontOfSize:14]
//    [attributedStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(15,selectedStr.length)];
//    return attributedStr1;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"实名绑卡";
    self.navigationItem.rightBarButtonItem = nil;
    //    UIBarButtonItem *itemBt= [[UIBarButtonItem alloc]initWithCustomView:self.rightBt];
    //    self.navigationItem.rightBarButtonItem = itemBt;
    //    WEAKSELF;
    //    [self.rightBt addTapGesture:^{
    //
    //         DAlertViewController *alertVC = [DAlertViewController alertControllerWithTitle:@"提示" message:@"未完善资料无法进行投资是否继续认证"];
    //
    //        [alertVC addActionWithTitle:@"暂不认证" handler:^(CKAlertAction *action) {
    //            [ weakSelf toHome];
    //        }];
    //
    //        [alertVC addActionWithTitle:@"继续认证" handler:^(CKAlertAction *action) {
    //            [alertVC removeFromParentViewController];
    //        }];
    //
    //        [alertVC show];
    //        [alertVC setButtonTitleColor];
    //
    //    }];
    self.tfIDCard.delegate = self;
    self.tfName.delegate = self;
    [self.tfIDCard addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    IdCardlabel = [UILabel labelContentPreView:self.tfIDCard];
    //    nameTipLabel = [UILabel labelTipInfo:self.tfName content:@"监管部门规定，金融投资需提供实名信息以确保投资安全"];
    //    [self.scrollview addSubview:nameTipLabel ];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)navigationShouldPopOnBackButton {
    //    if (self.isGoBack) {
    //        return YES;
    //    } else {
    ////        [self toAccount];
    //        [self toHome];
    //        return NO;
    //    }
    if ([self.from isEqualToString:@"注册成功"]) {
        [self toHome];
        return NO;
    }
    
    
    return YES;
}

- (void) initUI{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, APP_WIDTH - 16 *2, 40)];
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"为保障资金安全，投资前须验证实名与银行卡信息，请务必填写您本人真实信息";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = RGBA(102,102,102,1);
    titleLabel.backgroundColor = [UIColor clearColor];
    //    [self.scrollview addSubview:titleLabel];
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    [grid addView:titleLabel  margin:UIEdgeInsetsMake(20, 0, 30, 0)];
    //    [grid addView:self.image margin:UIEdgeInsetsMake(0, -20, 30, -20)];
    //
    //
    //    UILabel *title = [UILabel new];
    //    title.origin =CGPointMake(20, self.image.origin.y);
    //    title.size = CGSizeMake(APP_WIDTH/2, self.image.frame.size.height);
    //    title.textColor = [UIColor whiteColor];
    //    title.backgroundColor = [UIColor clearColor];
    //    title.numberOfLines = 0;
    //    NSInteger register_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"register_total"];
    //    NSString *investTotalStr = [NSString stringWithFormat:@"在湖商贷\n%ld人\n与您一起放心理财",register_total];
    //    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:investTotalStr];
    //    for (int i = 0; i<= investTotalStr.length; i++) {
    //        NSString *a = [investTotalStr substringWithRange:NSMakeRange(i, 1)];
    //        if ([NSString isPureInt:a]) {
    //            [strAttr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorHex:@"ff5b24"],NSFontAttributeName: [UIFont systemFontOfSize:30]} range:NSMakeRange(i, 1)];
    //        }
    //    }
    //    title.attributedText = strAttr;
    //    [self.image addSubview:title];
    //
    //
    //    [grid addView:self.titleLabel margin:UIEdgeInsetsMake(0, 0, 37.5, 0)];
    
    //    self.tfName = [grid addRowInputWithplaceholderRoundRect:@"请输入真实姓名"];
    self.tfName = [grid gj_addRowInput:@"姓名" placeholder:@"请输入真实姓名"];
    [grid addLineForHeight:10];
    //    self.tfIDCard = [grid addRowInputWithplaceholderRoundRect:@"请输入身份证号码"];
    self.tfIDCard = [grid gj_addRowInput:@"身份证" placeholder:@"请输入身份证号码"];
    [grid addLineForHeight:10];
    
    //    self.btnProvice = [grid gj_addRowSelectTextWithPlaceholder:!IPHONE5 ? @"    请选择省份" : @"请选择省份" title:@"省份" done:^{
    //        [self.view endEditing:YES];
    //        QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
    //            controller.type = SelectProvice;
    //            controller.delegate = self;
    //            [self.navigationController pushViewController:controller animated:YES];
    //    }];
    //    [grid addLineForHeight:10];
    //
    //    self.btnCity = [grid gj_addRowSelectTextWithPlaceholder:!IPHONE5 ? @"    请选择城市" : @"请选择城市" title:@"城市" done:^{
    //        if (!provice) {
    //            [self showToast:@"请选择开户行省份"];
    //            return;
    //        }
    //
    //        QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
    //        controller.type = SelectCity;
    //        controller.ProviceName = provice;
    //        controller.delegate = self;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    }];
    //    [grid addLineForHeight:10];
    //
    //    self.btnArea = [grid gj_addRowSelectTextWithPlaceholder:!IPHONE5 ? @"    请选择地区" : @"请选择地区" title:@"地区" done:^{
    //        if (!provice) {
    //            [self showToast:@"请选择开户行省份"];
    //            return;
    //        }
    //        if (!city) {
    //            [self showToast:@"请选择开户行城市"];
    //            return;
    //        }
    //
    //        QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
    //        controller.type = SelectArea;
    //        controller.ProviceName = provice;
    //        controller.CityName =city;
    //        controller.delegate = self;
    //        [self.navigationController pushViewController:controller animated:YES];
    //
    //    }];
    //    [grid addLineForHeight:10];
    //
    ////    self.tfBranch = [grid addRowInputWithplaceholderRoundRect:@"请输入分行"];
    //    self.tfBranch = [grid gj_addRowInput:@"分行" placeholder:@"请输入分行"];
    //    [grid addLineForHeight:10];
    
    //    self.tfBankCard = [grid addRowInputWithplaceholderRoundRect:@"请输入银行卡号"];
    self.tfBankCard = [grid gj_addRowInput:@"银行卡" placeholder:@"请输入银行卡号"];
    [grid addLineForHeight:50];
    [grid gj_addSubmitButtonTitle:@"保存" click:^(id value) {
        NSLog(@"认证---");
        [self nextClick];
        //        HRSetPayPwdViewController *controller = [HRSetPayPwdViewController controllerFromXib];
        //        [self.navigationController pushViewController:controller animated:YES];
    }];
    [grid addView:self.tintLabel margin:UIEdgeInsetsMake(4.5, 0, 15, 0)];
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
    
}


- (void)textFieldEditingChanged:(UITextField*)textField{
    if ([self.tfIDCard isFirstResponder]) {
        IdCardlabel.text = [NSString IdCardFormat:textField.text];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [nameTipLabel removeFromSuperview];
    
    if ([self.tfIDCard isFirstResponder]) {
        IdCardlabel.text = [NSString IdCardFormat:textField.text];
        [self.scrollview addSubview:IdCardlabel];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [IdCardlabel removeFromSuperview];
}


- (void)initData{
    
    [self.tfName setRealName];
    self.tfName.group = 0;
    
    [self.tfIDCard setIDCard];
    self.tfIDCard.group = 0;
    
    [self.tfBankCard setBankCard];
    self.tfBankCard.group = 0;
}

#pragma  mark - event
- (void)nextClick {
    
    //    if (!provice) {
    //        [self showToast:@"请选择开户行所在省份"];
    //        return;
    //    }
    //
    //    if (!city) {
    //        [self showToast:@"请选择开户行所在城市"];
    //        return;
    //    }
    //
    //    if (!area) {
    //        [self showToast:@"请选择开户行所在地区"];
    //        return;
    //    }
    //
    //    if (self.tfBranch.text.length == 0) {
    //        [self showToast:@"请填写开户分行"];
    //        return;
    //    }
    
    if (![self.view validation:0]) {
        return;
    }
    
    [self commonJson];
}


#pragma  mark - json
- (void)commonJson {
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"real_name"] = self.tfName.text;
    dic[@"card_id"] = [self.tfIDCard.text enValue];
    dic[@"bank_account"] = self.tfBankCard.text;
    
    //    dic[@"province_id"] = selectProviceid;
    //    dic[@"city_id"] = selectCityid;
    //    dic[@"area_id"] = selectAreaid;
    //    dic[@"branch"] = self.tfBranch.text;
    
    dic[@"type"] = @"2";
    [service post:@"bank_binding" data:dic complete:^(NSDictionary *value) {
        [GVUserDefaults  shareInstance].real_status = 1;
        [GVUserDefaults  shareInstance].realname = self.tfName.text;
        [GVUserDefaults  shareInstance].card_id = self.tfIDCard.text;
        NSString *msg = value.str(@"message");
        NSString *status = value.str(@"status");
        if ([status isEqualToString:@"2"]) {
            [self hideHUD];
            [self showToast:msg duration:2];
        }else{
            [MobClick event:@"BindBankCardBt"];
            [self hideHUD];
            NOTICE_POST(NOTICEBANK);
            //            HRSetPayPwdViewController *controller = [HRSetPayPwdViewController controllerFromXib];
            QTPayResetPwdViewController *controller = [QTPayResetPwdViewController controllerFromXib];
            if ([self.from isEqualToString:@"注册成功"]) {
                controller.isToHome = YES;
            } else if ([self.from isEqualToString:@"提现/充值"]){
                controller.isToAccount = YES;
            } else if ([self.from isEqualToString:@"安全中心"]) {
                controller.isToSafeCenter = YES;
            }
            else {//投资详情
                controller.isToInvestDetail = YES;
            }
            
            [self.navigationController pushViewController:controller animated:YES];
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

