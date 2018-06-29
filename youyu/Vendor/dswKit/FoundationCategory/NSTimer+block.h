//
//  NSTimer+block.h
//  qtyd
//
//  Created by stephendsw on 2017/3/15.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ timeBlock)(id vlaue);

typedef void (^ offTimeBlock)(NSInteger value);

@interface NSTimer (block)

@property (nonatomic, assign) NSInteger executeCount;

+ (instancetype)timerScheduled:(NSInteger)time done:(timeBlock)block;

+ (instancetype)timerExecuteCountPerSecond:(NSInteger)num done:(offTimeBlock)block;

@end
