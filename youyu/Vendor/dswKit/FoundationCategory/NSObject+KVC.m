//
//  NSObject+KVC.m
//  qtyd
//
//  Created by stephendsw on 16/4/26.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "NSObject+KVC.h"

@implementation NSObject (KVC)

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
