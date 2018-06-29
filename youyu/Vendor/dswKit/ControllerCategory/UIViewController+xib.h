//
//  UIViewController+xib.h
//  test
//
//  Created by stephen on 15/3/5.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ firstLuanchBlock)();

@interface UIViewController (xib)

+ (instancetype)controllerFromXib;

+ (instancetype)storyboard:(NSString *)name viewid:(NSString *)key;

@end
