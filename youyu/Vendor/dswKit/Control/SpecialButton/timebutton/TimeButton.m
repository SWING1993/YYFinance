//
//  TimeButton.m
//  qtyd
//
//  Created by stephendsw on 15/9/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "TimeButton.h"

@implementation TimeButton

- (void)startSecond:(NSInteger)second {
    [time invalidate];
    time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];

    _second = second;
    [time fire];
}

- (void)time {
    if (_second == 0) {
        if (self.datasource) {
            [time invalidate];

            NSString *titile = [self.datasource timeButtonStoppingTitle:self];
            [self setTitle:titile forState:UIControlStateNormal];

            return;
        }
    } else {
        if (self.datasource) {
            NSString *titile = [self.datasource timeButtonRunningTitle:self second:_second];
            [self setTitle:titile forState:UIControlStateNormal];
        }
    }

    _second--;
}

@end
