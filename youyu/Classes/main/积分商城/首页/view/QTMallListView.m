//
//  QTMallListView.m
//  qtyd
//
//  Created by stephendsw on 16/3/16.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMallListView.h"

@interface QTMallListView ()

@property (weak, nonatomic) IBOutlet UILabel        *lbHas;
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel        *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel        *lbBuyNum;

@end

@implementation QTMallListView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [Theme backgroundColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)bind:(NSDictionary *)obj {
    self.lbHas.text = [NSString stringWithFormat:@"剩%@件", obj.str(@"inventory")];

    [self.image setImageWithURLString:obj.str(@"img_url_full") placeholderImageString:@"mall_default"];

    self.lbTitle.text = obj.str(@"short_title");

    if (obj.str(@"short_title").length == 0) {
        self.lbTitle.text = obj.str(@"title");
    }

    self.lbPoint.text = obj.str(@"need_point");
    self.lbBuyNum.text = [NSString stringWithFormat:@"已兑%@件", obj.str(@"exchange_count")];
}

@end
