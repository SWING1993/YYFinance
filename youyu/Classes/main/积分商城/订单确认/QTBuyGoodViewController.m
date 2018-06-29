//
//  QTBuyGoodViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBuyGoodViewController.h"
#import "QTAddressController.h"
#import "QTGoodView.h"
#import "QTAdressView.h"
#import "QTBuyNumView.h"

@interface QTBuyGoodViewController ()<QTAddressDelagate>

/**
 *  是否实物
 */
@property (nonatomic, readonly) BOOL isGoods;

@end

@implementation QTBuyGoodViewController
{
    QTAdressView    *addressView;
    QTGoodView      *goodView;
    QTBuyNumView    *buyView;

    DBinding *bind;
}

- (BOOL)isGoods {
    if ([self.goodInfo.str(@"good_info.source") isEqualToString:@"1"]) {
        return YES;
    }

    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单确认";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    addressView = [QTAdressView viewNib];

    if (self.isGoods) {
        [stack addView:addressView];
    } else {
        [stack addLineForHeight:20];
    }

    WEAKSELF;
    [addressView addTapGesture:^{
        QTAddressController *controller = [QTAddressController controllerFromXib];
        controller.isSelected = YES;
        controller.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    goodView = [QTGoodView viewNib];
    [stack addView:goodView];

    buyView = [QTBuyNumView viewNib];
    [stack addView:buyView];

    [stack addRowButtonTitle:@"立即兑换" click:^(id value) {
        if (!self.isGoods) {
            [self commonJson];
        } else if (self.isGoods && (self.address_id.length > 0)) {
            [self commonJson];
        } else {
            [self showToast:@"请添加收货地址"];
        }
    }];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [addressView bind:self.goodInfo.dic(@"user_address")];
    self.address_id = self.goodInfo.str(@"user_address.id");

    buyView.num = self.quantity;
    bind = [DBinding new];
    [bind bindKeyPath:@"value" object:buyView.stepper block:^{
        self.quantity = buyView.stepper.value;
        goodView.num = self.quantity;
        [goodView bind:self.goodInfo];
    }];

    [buyView bind:self.goodInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark select
- (void)AddressController:(QTAddressController *)controller didSelectAreaId:(NSDictionary *)addressInfo {
    self.address_id = addressInfo.str(@"id");
    [addressView bind:addressInfo];
}

#pragma  mark json
- (void)commonJson {
    [self showHUD];

    NSMutableDictionary *dic = [NSMutableDictionary new];

    if ([self.address_id stringByReplacingOccurrencesOfString:@"_" withString:@""].length > 0) {
        dic[@"address_id"] = [self.address_id stringByReplacingOccurrencesOfString:@"_" withString:@""];
    } else {
        dic[@"address_id"] = @"1";
    }

    dic[@"goods_id"] = self.goodInfo.str(@"good_info.id");
    dic[@"quantity"] = @(self.quantity);
    dic[@"source"] = self.goodInfo.str(@"good_info.source");

    [service post:@"pgoods_exchange" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        NSString *msg = [NSString stringWithFormat:@"收货地址:%@", addressView.address];

        if (!self.isGoods) {
            msg = @"";
        }

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"兑换成功" message:msg delegate:self cancelButtonTitle:@"查看订单" otherButtonTitles:@"继续兑换", nil];

        [alert clickedIndex:^(NSInteger index) {
            if (index == 0) {
                [self toOrderListWithBackBefore:NO];
            } else if (index == 1) {
                [self toMallHome];
            }
        }];

        [alert show];
    }];
}

@end
