//
//  NSObject+KVO.m
//  qtyd
//
//  Created by stephendsw on 2017/3/15.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "NSObject+KVO.h"

@implementation NSObject (KVO)

- (void)bindKeyPath:(NSString *)keyPath object:(id)obj block:(bindingBlock)block {
    NSDictionary *dic = @{@"keypath":keyPath, @"block":block};

    [obj addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:(__bridge_retained void *)(dic)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSDictionary *dic = (__bridge NSDictionary *)(context);

    id newobj = change[@"new"];

    ((bindingBlock)dic[@"block"])(newobj);
}

@end
