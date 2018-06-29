//
//  QTBuyNumView.m
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBuyNumView.h"
#import "QTTheme.h"
#import "NSDictionary+Order.h"

@interface QTBuyNumView ()

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end

@implementation QTBuyNumView

- (void)bind:(NSDictionary *)value {
    [QTTheme stepperStyle:self.stepper];

    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];

        self.lbTip.text = [NSString stringWithFormat:@"合计: %@ 积分", @(value.i(@"good_info.need_point") * count)];
    };

    self.stepper.maximum = [value getCanBuyNum];

    self.stepper.minimum = 1;

    self.stepper.value = self.num;

    self.lbTip.text = [NSString stringWithFormat:@"合计: %@ 积分", @(value.i(@"good_info.need_point") * self.num)];
}

@end
