//
//  QTGoodView.m
//  qtyd
//
//  Created by stephendsw on 16/3/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTGoodView.h"

@interface QTGoodView ()
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel        *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel        *lbNum;
@property (weak, nonatomic) IBOutlet UIImageView    *lineImage;

@end

@implementation QTGoodView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.borderColor = [Theme backgroundColor].CGColor;
    self.image.layer.borderWidth = 1;

    UIImage *image = [UIImage imageNamed:@"icon_adress_line_shouhuodizhi"];

    self.lineImage.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)bind:(NSDictionary *)value {
    NSString *url;

    if (value.arr(@"img_list").count>0) {
        url = [value.arr(@"img_list") getArrayForKey:@"img_info.img_url_full"].lastObject;
    } else {
        url = value.str(@"good_info.img_url_full");
    }

    [self.image setImageWithURLString:url placeholderImageString:@"mall_default"];

    self.lbTitle.text = value.str(@"good_info.title");

    NSString                    *point = value.str(@"good_info.need_point");
    NSMutableAttributedString   *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"兑换价:%@ 积分/个", point]];
    self.lbPoint.attributedText = attstr;

    self.lbNum.text = @"x".add(@(self.num));
}

@end
