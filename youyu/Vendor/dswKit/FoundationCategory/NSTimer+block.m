//
//  NSTimer+block.m
//  qtyd
//
//  Created by stephendsw on 2017/3/15.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "NSTimer+block.h"
#import <objc/runtime.h>

@implementation NSTimer (block)

- (NSInteger)executeCount {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setExecuteCount:(NSInteger)setExecuteCount {
    objc_setAssociatedObject(self, @selector(executeCount), @(setExecuteCount), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (instancetype)timerScheduled:(NSInteger)time done:(timeBlock)block {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:YES];

    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    return timer;
}

+ (void)jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if ([inTimer userInfo]) {
        timeBlock block = [inTimer userInfo];
        block(inTimer);
    }
}

+ (instancetype)timerExecuteCountPerSecond:(NSInteger)offstime done:(offTimeBlock)block;
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(executeoffTimeBlock:) userInfo:block repeats:YES];

    timer.executeCount = offstime;

    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    return timer;
}

+ (void)executeoffTimeBlock:(NSTimer *)inTimer;
{
    if ([inTimer userInfo]) {
        if (inTimer.executeCount < 0) {
            inTimer.executeCount = 0;
        }

        offTimeBlock block = [inTimer userInfo];
        block(inTimer.executeCount);

        inTimer.executeCount--;

        if (inTimer.executeCount < 0) {
            [inTimer invalidate];
        }
    }
}

@end
