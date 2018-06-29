//
//  QTAdressView.m
//  qtyd
//
//  Created by stephendsw on 16/3/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTAdressView.h"

@interface QTAdressView ()
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbName;

@property (weak, nonatomic) IBOutlet UILabel        *lbTip;
@property (weak, nonatomic) IBOutlet UIImageView    *imgArrows;

@end

@implementation QTAdressView
{
    NSString *addressStr;
}

- (void)bind:(NSDictionary *)value {
    if (![value isKindOfClass:[NSDictionary class]]) {
        self.lbName.text = @"您暂无收货地址哟";
        self.lbTip.hidden = NO;
    } else {
        self.lbTip.hidden = YES;

        NSString    *name = value.str(@"user_name");
        NSString    *phone = value.str(@"user_mobile");

        NSString *address;

        if (!value.str(@"area_name")) {
            address = [value.str(@"user_address") stringByReplacingOccurrencesOfString:@"_" withString:@""];
        } else {
            address = [value.str(@"area_name") stringByReplacingOccurrencesOfString:@"_" withString:@""].add(value.str(@"user_address"));
        }

        addressStr = address;

        NSString *str ;

        if (address.length > 0) {
            str = [NSString stringWithFormat:@"收货人:%@       %@ \n收货地址:%@", name, phone, address];
        } else {
            str = [NSString stringWithFormat:@"收货人:%@       %@ ", name, phone];
        }

        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:str];

        self.lbName.attributedText = attstr;
    }
}

- (NSString *)address {
    return addressStr;
}

- (void)setType:(AddressType)type {
    if (type == AddressTypeMall) {
        self.imgArrows.hidden = NO;
    } else if (type == AddressTypeOrder) {
        self.imgArrows.hidden = YES;
    }
}

@end
