//
//  QTallMoneyCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTallMoneyCell.h"
#import "NSString+model.h"

@interface QTallMoneyCell ()



@end

@implementation QTallMoneyCell


-(void)bind:(NSDictionary *)obj
{
    NSString * name=obj.str(@"name");
    NSString * money=obj.str(@"money");
    if ([name containsString:@"冻结金额"] || [name containsString:@"可用余额"]) {
        self.lbtext.textColor = [UIColor colorHex:@"999999"];
        self.lbMoney.textColor = [UIColor colorHex:@"999999"];
    }
    
    self.lbtext.text = name;
    self.lbMoney.text = [money moneyFormatShow];
}



@end
