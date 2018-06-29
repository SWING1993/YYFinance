//
//  RecordModel.m
//  qtyd
//
//  Created by stephendsw on 15/7/29.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel
{
    NSArray *menuData;
    NSArray *menuTypeKey;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        menuData = @[@"全部", @"提现", @"还款", @"充值"];//@"投资"
        menuTypeKey = @[@"", @"cash", @"repayment_receive", @"recharge"];//, @"tender"

        self.list = menuData;
        self.listkey = menuTypeKey;
    }

    return self;
}

- (NSString *)getName:(NSString *)ID {
    for (int i = 0; i < menuTypeKey.count; i++) {
        if ([ID isEqualToString:menuTypeKey[i]]) {
            return menuData[i];
        }
    }

    return @"";
}

@end
