//
//  QTRewardView.m
//  qtyd
//
//  Created by stephendsw on 16/8/3.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRewardView.h"
#import "QTTheme.h"

@interface QTRewardView ()

@end

@implementation QTRewardView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self bindKeyPath:@"text" object:self.lbContent block:^(id newobj){
        [QTTheme lbStyleMoney:self.lbContent];
    }];
}

@end
