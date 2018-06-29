//
//  NSObject+KVO.h
//  qtyd
//
//  Created by stephendsw on 2017/3/15.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ bindingBlock)(id newObj);

@interface NSObject (KVO)

/**
 *  属性变化绑定
 *
 *  @param keyPath 对象的属性
 *  @param obj     要被观察的对象
 *  @param block   block
 */
- (void)bindKeyPath:(NSString *)keyPath object:(id)obj block:(bindingBlock)block;

@end
