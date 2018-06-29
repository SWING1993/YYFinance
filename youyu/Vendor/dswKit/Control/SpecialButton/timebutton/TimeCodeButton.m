//
//  WLTimeButton.m
//  Car_ZJ
//
//  Created by stephen on 15/4/22.
//  Copyright (c) 2015年 网兰. All rights reserved.
//

#import "TimeCodeButton.h"
#import "NSObject+KVO.h"
#import "NSTimer+block.h"
#import "NSString+quick.h"

@implementation TimeCodeButton
{
    NSTimer     *timer;
}

- (void)didMoveToSuperview {
    UIColor     *oldColor = self.backgroundColor;
    NSString    *oldTitle = self.titleLabel.text;
    UIColor     *oldTextColor = self.titleLabel.textColor;

    self.countTime = 30;

    [self bindKeyPath:@"enabled" object:self block:^(id newobj){
        if (timer) {
            [timer invalidate];
        }

        if (self.enabled) {
            self.backgroundColor = oldColor;
            [self setTitleColor:oldTextColor forState:UIControlStateDisabled];
        } else {
            [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

            if (!self.disabled) {
                // =========== 倒计时=====================
                __block NSInteger offtime = self.countTime;
                timer = [NSTimer timerScheduled:1 done:^(id vlaue) {
                    offtime--;

                    NSString *str = [NSString stringWithFormat:@"%ld秒后重新发送", offtime]; [self setTitle:str forState:UIControlStateDisabled];

                    if (offtime == 0) {
                        self.enabled = YES;
                        [self setTitle:oldTitle forState:UIControlStateNormal];
                        [timer invalidate];
                    }
                }];
            }
        }
    }];
}

@end
