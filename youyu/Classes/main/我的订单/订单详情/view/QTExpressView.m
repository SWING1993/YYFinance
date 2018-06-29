//
//  QTExpressView.m
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTExpressView.h"
#import "QTExpressModel.h"

@interface QTExpressView ()
@property (weak, nonatomic) IBOutlet UILabel        *lbTip;
@property (weak, nonatomic) IBOutlet UIImageView    *image;

@end

@implementation QTExpressView

- (void)bind:(NSDictionary *)value {
    NSInteger s = value.i(@"status");

    NSString *status;

    self.image.hidden = YES;

    NSString *tip = @"";

    if (s == 0) {
        status = @"待发货";
        tip = @"\n(兑换后15个工作日内发货,请耐心等待!)";
    }

    if (s == 1) {
        status = @"待收货";
    }

    if (s == 2) {
        status = @"待评价";
    }

    if (s == 3) {
        status = @"已评价";
    }

    self.status = status;

    
    if ([value.str(@"status") isEqualToString:@"1"]) {
        NSInteger  type =value .i(@"express_company_type");
        
        NSString *company =[QTExpressModel getName:  type ];
      
        
        NSString *content = [NSString stringWithFormat:@"订单状态:%@\n承运公司:%@\n物流单号:%@", status,company, value.str(@"express_no")];

        self.lbTip.text = content;
        self.image.hidden = NO;
    } else {
        NSString *content = [NSString stringWithFormat:@"订单状态:%@", status];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:content.add(tip)];
        [str setColor:[UIColor darkGrayColor] string:tip];

        self.lbTip.attributedText = str;
    }
}

@end
