//
//  UINavigationController+quick.h
//  Car_ZJ
//
//  Created by stephen on 15/3/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (quick)

/**
 *  获取viewControllers中当前控制器的前一个控制器
 *
 *  @return
 */
- (id)getPreviousController;

@end
