//
//  QTOrderCell.m
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTOrderCell.h"

@interface QTOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbID;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel    *lbStatue;

@property (weak, nonatomic) IBOutlet UILabel    *lbNum;
@property (weak, nonatomic) IBOutlet UILabel    *lbSum;
@property (weak, nonatomic) IBOutlet UIButton   *btn;

@end

@implementation QTOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.borderColor = [Theme backgroundColor].CGColor;
    self.image.layer.borderWidth = 1;

    self.lbStatue.layer.borderWidth = 1;
    self.lbStatue.layer.borderColor = [Theme darkOrangeColor].CGColor;
    self.lbStatue.textColor = [Theme darkOrangeColor];
    self.lbStatue.layer.cornerRadius = 5;

    [QTTheme btnRedStyle:self.btn];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    self.lbID.text = [NSString stringWithFormat:@"订单编号: %@", obj.str(@"order_no")];

    self.lbTitle.text = obj.str(@"goods_name");

    self.lbPoint.text = [NSString stringWithFormat:@"%@ 积分/件", obj.str(@"point")];

    self.lbNum.text = [NSString stringWithFormat:@"x%@", obj.str(@"unit")];

    NSString *sumPoint = @(obj.i(@"point") * obj.i(@"unit")).stringValue;

    NSMutableAttributedString *sumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"合计 %@ 积分", sumPoint]];

    [sumStr setColor:[Theme darkOrangeColor] string:sumPoint];

    self.lbSum.attributedText = sumStr;

    NSInteger statue = obj.i(@"status");

    if (statue == 0) {
        self.lbStatue.text = @"待发货";

        [self.btn setTitle:@"" forState:UIControlStateNormal];
        self.btn.hidden = YES;
    } else if (statue == 1) {
        self.lbStatue.text = @"待收货";
        [self.btn setTitle:@"确认收货" forState:UIControlStateNormal];

        [self.btn click:^(id value) {
            self.block(1);
        }];

        self.btn.hidden = NO;
    } else if (statue == 2) {
        self.lbStatue.text = @"待评价";
        [self.btn setTitle:@"评价" forState:UIControlStateNormal];

        [self.btn click:^(id value) {
            self.block(2);
        }];

        self.btn.hidden = NO;
    } else if (statue == 3) {
        self.lbStatue.text = @"已评价";
        self.btn.hidden = YES;
    }

    [self.image setImageWithURLString:obj.str(@"img_url_full") placeholderImageString:IMAGE_DEFAULT];
}

@end
