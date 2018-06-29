//
//  NSDateFormatter+quick.m
//  qtyd
//
//  Created by stephendsw on 2016/11/1.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "NSDateFormatter+quick.h"

@implementation NSDateFormatter (quick)

+ (instancetype)sharedInstance {
    static NSDateFormatter  *sharedInstance = nil;
    static dispatch_once_t  predicate;

    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
