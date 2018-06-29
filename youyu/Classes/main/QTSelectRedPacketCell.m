//
//  QTSelectRedPacketCell.m
//  qtyd
//
//  Created by stephendsw on 16/4/5.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSelectRedPacketCell.h"

@interface QTSelectRedPacketCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel    *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbTip;
@property (weak, nonatomic) IBOutlet UILabel    *lbTime;

@end

@implementation QTSelectRedPacketCell

- (void)bind:(NSDictionary *)obj {
    self.lbTitle.text = [NSString stringWithFormat:@"%@元红包", obj.str(@"money")];
    self.lbTime.text = [NSString stringWithFormat:@"有效期至 %@", [obj.str(@"timeout") dateValue]];

    NSInteger money = obj.i(@"tender_money");

    float allMoney = self.money.floatValue + obj.fl(@"money");

    if (allMoney > 0) {
        self.lbTip.text = [NSString stringWithFormat:@"投资≥%@元", @(money)];
    } else {
        self.lbTip.text = @"全网通用(除新手标外)";
    }

    if (allMoney >= money) {
        // 可用
        self.image.image = [[UIImage imageNamed:@"icon_g_hongbao_touzi"] imageWithColor:[Theme redColor]];
    } else {
        //不可用
        self.image.image = [[UIImage imageNamed:@"icon_g_hongbao_touzi"] imageWithColor:[Theme grayColor]];
    }
}

@end
