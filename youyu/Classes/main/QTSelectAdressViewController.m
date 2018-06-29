//
//  QTSelectAdressViewController.m
//  qtyd
//
//  Created by stephendsw on 16/1/29.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSelectAdressViewController.h"
#import "QTSelectProvinceViewController.h"

@interface QTSelectAdressViewController ()<SelectProvinceDelegate>

@property (strong, nonatomic)   WTReTextField *selProvince;

@property (strong, nonatomic)   WTReTextField *selCity;

@property (strong, nonatomic)  WTReTextField *selZone;

@property (strong, nonatomic)   WTReTextField *tfAddress;

@end

@implementation QTSelectAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(click)];
    self.navigationItem.rightBarButtonItem = itembar;

    self.titleView.title = @"设置地址";
}

- (void)click {
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", self.selProvince.text, self.selCity.text, self.selZone.text, self.tfAddress.text];

    if (self.selProvince.text.length == 0) {
        [self showToast:@"请选择省份"];
        return;
    } else if (self.selCity.text.length == 0) {
        [self showToast:@"请选择城市"];
        return;
    } else if (self.selZone.text.length == 0) {
        [self showToast:@"请选择县区"];
        return;
    } else if (self.tfAddress.text.length == 0) {
        [self showToast:@"请输入详细地址"];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedAddress:tag:)]) {
        [self.delegate selectedAddress:address tag:self.tag];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    self.selProvince = [grid addRowSelectText:@"所在省份" placeholder:@"请选择所在省份" done:^() {
            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.delegate = self;
            controller.type = SelectProvice;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.selCity = [grid addRowSelectText:@"所在城市" placeholder:@"请选择所在城市" done:^() {
            if (self.selProvince.text.length == 0) {
                [self showToast:@"请选择所在省份" duration:1];
                return;
            }

            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.delegate = self;
            controller.type = SelectCity;
            controller.ProviceName = self.selProvince.text;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.selZone = [grid addRowSelectText:@"所在县区" placeholder:@"请选择所在县区" done:^() {
            if (self.selCity.text.length == 0) {
                [self showToast:@"请选择所在城市" duration:1];
                return;
            }

            QTSelectProvinceViewController *controller = [QTSelectProvinceViewController controllerFromXib];
            controller.delegate = self;
            controller.type = SelectArea;
            controller.ProviceName = self.selProvince.text;
            controller.CityName = self.selCity.text;
            [self.navigationController pushViewController:controller animated:YES];
        }];

    self.tfAddress = [grid addRowInput:@"详细地址" placeholder:@"请输入收件人详细地址"];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

#pragma mark select area
- (void)selectedProvice:(NSDictionary *)value {
    self.selProvince.text = value.str(@"area_name");
    self.selCity.text = self.selZone.text = @"";
}

- (void)selectedCity:(NSDictionary *)value {
    self.selCity.text = value.str(@"area_name");
    self.selZone.text = @"";
}

- (void)selectedArea:(NSDictionary *)value {
    self.selZone.text = value.str(@"area_name");
}

@end
