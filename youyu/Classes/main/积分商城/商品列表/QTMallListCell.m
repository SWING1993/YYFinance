//
//  QTMallListCell.m
//  qtyd
//
//  Created by stephendsw on 16/3/16.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMallListCell.h"

@interface QTMallListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel    *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbContent;

@property (weak, nonatomic) IBOutlet UILabel *lbMoney;

@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel    *lbHas;

@end

@implementation QTMallListCell

- (void)awakeFromNib {
    self.image.layer.borderColor = [Theme backgroundColor].CGColor;
    self.image.layer.borderWidth = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    [self.image setImageWithURLString:obj.str(@"img_url_full") placeholderImageString:@"mall_default"];

    self.lbTitle.text = obj.str(@"title");

    self.lbContent.text = [NSString stringWithFormat:@"已兑换: %@ 件 ", obj.str(@"exchange_count")];

    NSString                    *market_price = [NSString stringWithFormat:@"市场价:￥%@ 元", obj.str(@"market_price")];
    NSMutableAttributedString   *attr = [[NSMutableAttributedString alloc]initWithString:market_price];
    [attr setUnderlineString:obj.str(@"market_price")];
    self.lbMoney.attributedText = attr;

    if (obj.i(@"market_price") == 0) {
        self.lbMoney.text = @"";
    } else {
        self.lbMoney.attributedText = attr;
    }

    self.lbPoint.text = [NSString stringWithFormat:@"%@积分", obj.str(@"need_point")];
    self.lbHas.text = [NSString stringWithFormat:@"剩余: %@ 件", obj.str(@"inventory")];
}

@end
