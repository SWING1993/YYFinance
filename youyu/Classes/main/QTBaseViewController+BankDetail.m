//
//  QTBaseViewController+BankDetail.m
//  qtyd
//
//  Created by stephendsw on 15/8/18.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController+BankDetail.h"
#import "BankDeailView.h"
#import "BankModel.h"
#import "GVUserDefaults.h"
@implementation QTBaseViewController (BankDetail)

- (UIView *)getNoticeView:(NSDictionary *)value state:(QTbankState)state; {
    NSString *text = [BankModel getTipForCode:value state:state];

    if (text) {
        MXMarqueeView *marqueeView = [[MXMarqueeView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 20)];

        [QTTheme marqueeViewYellow:marqueeView];

        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];

        NSRange rang1 = [text rangeOfString:value.str(@"update_start_time")];

        [attStr addAttribute:NSForegroundColorAttributeName value:Theme.redColor range:rang1];

        NSRange rang2 = [text rangeOfString:value.str(@"update_end_time")];

        [attStr addAttribute:NSForegroundColorAttributeName value:Theme.redColor range:rang2];

        marqueeView.text = attStr;

        [marqueeView startAnimation];

        return marqueeView;
    } else {
        return nil;
    }
}

@end
