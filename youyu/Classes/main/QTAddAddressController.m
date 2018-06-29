//
//  QTAddAddressController.m
//  qtyd
//
//  Created by yl on 15/10/9.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTAddAddressController.h"
#import "WTReTextField+Add.h"
#import "QTSelectProvinceViewController.h"
#import "DFormAdd.h"
#import "QTAddressController.h"

@interface QTAddAddressController ()<SelectProvinceDelegate>

/**
 *  收货人姓名
 */
@property (strong, nonatomic)   WTReTextField *tfContactName;

/**
 *  收货人手机
 */
@property (strong, nonatomic)   WTReTextField *tfContactPhone;

/**
 *  省份
 */
@property (strong, nonatomic)   WTReTextField *selProvince;

/**
 *  城市
 */
@property (strong, nonatomic)   WTReTextField *selCity;

/**
 *  区域
 */
@property (strong, nonatomic)  WTReTextField *selZone;

/**
 *  收货人地址
 */
@property (strong, nonatomic)   WTReTextField *tfAddress;

/**
 *  是否默认
 */
@property (strong, nonatomic) UISwitch *switchDefault;

@end

@implementation QTAddAddressController
{
    NSString    *province;
    NSInteger   provinceId;
    NSString    *city;
    NSInteger   cityId;
    NSString    *zone;
    NSInteger   zoneId;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.param != nil) {
        if ([self.param.str(@"id") intValue] > 0) {
            self.titleView.title = @"修改收货地址";
        } else {
            self.titleView.title = @"新增收货地址";
        }
    } else {
        self.titleView.title = @"新增收货地址";
    }

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.tfContactName = [grid addRowInput:@"收件人" placeholder:@"请输入收件人姓名"];
    self.tfContactPhone = [grid addRowInput:@"手机号" placeholder:@"输入真实手机号"];

    self.selProvince = [grid addRowSelectText:@"所在省份" placeholder:@"请选择所在省份" done:^() {
            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.delegate = self;
            controller.type = SelectProvice;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.selCity = [grid addRowSelectText:@"所在城市" placeholder:@"请选择所在城市" done:^() {
            if (provinceId == 0) {
                [self showToast:@"请选择所在省份" duration:1];
                return;
            }

            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.delegate = self;
            controller.type = SelectCity;
            controller.ProviceName = province;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.selZone = [grid addRowSelectText:@"所在县区" placeholder:@"请选择所在县区" done:^() {
            if (cityId == 0) {
                [self showToast:@"请选择所在城市" duration:1];
                return;
            }

            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.delegate = self;
            controller.type = SelectArea;
            controller.ProviceName = province;
            controller.CityName = city;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.tfAddress = [grid addRowInput:@"详细地址" placeholder:@"请输入详细地址"];

    UILabel *lb = [[UILabel alloc]init];
    lb.textColor = Theme.darkGrayColor;
    lb.font = [UIFont systemFontOfSize:14];
    [lb setText:@"设置默认地址"];
    [grid addView:lb crossColumn:12];

    self.switchDefault = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [self.switchDefault addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];

    [grid addView:self.switchDefault crossColumn:4 margin:UIEdgeInsetsMake(6.5, (grid.width - 32) / 16 * 4 - 51, 6.5, 0)];// 屏幕宽度-左右间距各16，分16份，占用4份，减去控件宽度51

    [grid addLineForHeight:20];

    // 提交按钮
    [grid addRowButtonTitle:@"提交" click:^(id value) {
        [self onSubmit];
    }];
    [grid addLineForHeight:10];
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.tfContactPhone setPhone];
    self.tfContactPhone.group = 0;

    if (self.param != nil) {
        [self.tfContactPhone setText:self.param.str(@"user_mobile")];
        [self.tfContactName setText:self.param.str(@"user_name")];
        [self.tfAddress setText:self.param.str(@"user_address")];

        NSString    *areaName = self.param.str(@"area_name");
        NSArray     *arr = [areaName componentsSeparatedByString:@"_"];

        if (arr.count == 3) {
            province = self.selProvince.text = arr[0];
            city = self.selCity.text = arr[1];
            zone = self.selZone.text = arr[2];
        } else if (arr.count == 2) {
            province = self.selProvince.text = arr[0];
            city = self.selCity.text = arr[1];
        } else {
            province = city = zone = @"";
        }

        if ([self.param.str(@"address_default") isEqualToString:@"1"]) {
            self.switchDefault.on = YES;
        }

        NSString *areaId = self.param.str(@"area_id");
        arr = [areaId componentsSeparatedByString:@"_"];

        if (arr.count == 3) {
            provinceId = [arr[0] integerValue];
            cityId = [arr[1] integerValue];
            zoneId = [arr[2] integerValue];
        } else if (arr.count == 2) {
            provinceId = [arr[0] integerValue];
            cityId = [arr[1] integerValue];
        } else {
            provinceId = cityId = zoneId = 0;
        }
    } else {
        self.switchDefault.on = YES;
    }
}

- (void)switchChange {}

- (UIViewController *)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    UIViewController *poppedController = [self.navigationController popViewControllerAnimated:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];

    return poppedController;
}

#pragma mark select area
- (void)selectedProvice:(NSDictionary *)value {
    province = value.str(@"area_name");
    provinceId = [value.str(@"area_id") integerValue];
    self.selProvince.text = province;
    self.selCity.text = self.selZone.text = city = zone = @"";
    cityId = zoneId = 0;
}

- (void)selectedCity:(NSDictionary *)value {
    city = value.str(@"area_name");
    cityId = [value.str(@"area_id") integerValue];
    self.selCity.text = city;
    self.selZone.text = @"";
    zoneId = 0;
    zone = @"";
}

- (void)selectedArea:(NSDictionary *)value {
    zone = value.str(@"area_name");
    zoneId = [value.str(@"area_id") integerValue];
    self.selZone.text = zone;
}

#pragma mark event
- (void)onSubmit {
    if ([self.tfContactName.text stringValue].length == 0) {
        [self showToast:@"请输入收件人姓名"];
        return;
    }

    NSData *data = [[self.tfContactName.text stringValue] dataUsingEncoding:NSUTF8StringEncoding];

    if (data.length > 24) {
        [self showToast:@"收件人姓名最多24个字符(8个汉字)" duration:3];
        return;
    }

    if (![self.tfContactPhone validation:0]) {
        return;
    }

    if (provinceId == 0) {
        [self showToast:@"请选择所在省份"];
        return;
    }

    if (cityId == 0) {
        [self showToast:@"请选择所在城市"];
        return;
    }
    
    if (zoneId ==0 ) {
        [self showToast:@"请选择所在县区"];
        return;
    }
    
    if ([self.tfAddress.text stringValue].length == 0) {
        [self showToast:@"请输入收件人详细地址"];
        return;
    }

    data = [[self.tfAddress.text stringValue] dataUsingEncoding:NSUTF8StringEncoding];

    if (data.length > 150) {
        [self showToast:@"详细地址最多150个字符(50个汉字)" duration:3];
        return;
    }

    [self.view endEditing:YES];
    [self commonJson];
}

#pragma mark json
- (void)commonJson {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    dic[@"address_default"] = self.switchDefault.on ? @"1" : @"0";

    if (zoneId == 0) {
        dic[@"area_id"] = [NSString stringWithFormat:@"%ld_%ld", (long)provinceId, (long)
                           cityId];
    } else {
        dic[@"area_id"] = [NSString stringWithFormat:@"%ld_%ld_%ld", (long)provinceId, (long)cityId, (long)zoneId];
    }

    dic[@"user_address"] = self.tfAddress.text;
    dic[@"user_mobile"] = self.tfContactPhone.text;
    dic[@"user_name"] = self.tfContactName.text;

    if (self.param == nil) { // 新增地址
        [self showHUD:@"提交中..."];
        [service post:@"user_addressadd" data:dic complete:^(NSDictionary *value) {
            [self hideHUD];
            [self showToast:@"保存成功" done:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    } else {
        [self showHUD:@"更新中..."];
        dic[@"address_id"] = self.param.str(@"id");
        [service post:@"user_addressupdate" data:dic complete:^(NSDictionary *value) {
            [self hideHUD];

            [self showToast:@"更新完成" done:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    }
}

@end
