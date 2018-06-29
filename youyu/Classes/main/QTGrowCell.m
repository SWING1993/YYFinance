//
//  QTGrowCell.m
//  qtyd
//
//  Created by stephendsw on 16/3/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTGrowCell.h"

@interface QTGrowCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *Image;
@property (weak, nonatomic) IBOutlet UILabel        *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel    *lbTip;

@end

@implementation QTGrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSString *)source_type:(NSString *)str {
    if ([str isEqualToString:@"1"]) {
        return @"成功投资";
    }

    if ([str isEqualToString:@"2"]) {
        return @"成功注册";
    }

    if ([str isEqualToString:@"3"]) {
        return @"实名认证";
    }

    if ([str isEqualToString:@"4"]) {
        return @"绑定邮箱";
    }

    if ([str isEqualToString:@"4"]) {
        return @"绑定邮箱";
    }

    if ([str isEqualToString:@"5"]) {
        return @"完善信息";
    }

    if ([str isEqualToString:@"6"]) {
        return @"绑定银行卡";
    }

    if ([str isEqualToString:@"7"]) {
        return @"注册当天投资";
    }

    if ([str isEqualToString:@"8"]) {
        return @"还款当天投资";
    }

    if ([str isEqualToString:@"9"]) {
        return @"投资总额满1万";
    }

    if ([str isEqualToString:@"10"]) {
        return @"投资总额满3万";
    }

    if ([str isEqualToString:@"11"]) {
        return @"投资总额满10万";
    }

    if ([str isEqualToString:@"12"]) {
        return @"投资总额满50万";
    }

    if ([str isEqualToString:@"13"]) {
        return @"体验APP";
    }

    if ([str isEqualToString:@"14"]) {
        return @"邀请好友注册并实名认证成功";
    }

    if ([str isEqualToString:@"15"]) {
        return @"好友首次投资";
    }

    if ([str isEqualToString:@"16"]) {
        return @"签到";
    }

    if ([str isEqualToString:@"17"]) {
        return @"评论";
    }

    if ([str isEqualToString:@"18"]) {
        return @"";
    }

    if ([str isEqualToString:@"19"]) {
        return @"";
    }

    if ([str isEqualToString:@"20"]) {
        return @"赠送";
    }

    if ([str isEqualToString:@"21"]) {
        return @"补偿";
    }

    if ([str isEqualToString:@"22"]) {
        return @"抽奖";
    }

    if ([str isEqualToString:@"30"]) {
        return @"积分过期";
    }

    if ([str isEqualToString:@"31"]) {
        return @"商品兑换";
    }

    if ([str isEqualToString:@"32"]) {
        return @"商品拍卖";
    }

    return @"";
}

- (void)bind:(NSDictionary *)obj {
    // [self.Image setImageWithURL:[NSURL URLWithString:obj.str(@"")]];
    self.lbName.text = obj.str(@"source");
    self.lbTime.text = [obj.str(@"add_time") timeValue];
    self.lbPoint.text = @"+".add(obj.str(@"growth_value"));
    self.lbTip.text = [self source_type:obj.str(@"source_type")];
}

@end
