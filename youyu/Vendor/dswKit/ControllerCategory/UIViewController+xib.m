//
//  UIViewController+qiuck.m
//  test
//
//  Created by stephen on 15/3/5.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "UIViewController+xib.h"
#import "NSString+quick.h"
#import "UIViewExt.h"

@implementation UIViewController (xib)

+ (instancetype)controllerFromXib {
    NSString    *name = NSStringFromClass([self class]);
    NSString    *nameiPhone = [NSString stringWithFormat:@"%@~iphone", name];

    NSString    *path = [[NSBundle mainBundle] pathForResource:name ofType:@"nib"];
    NSString    *pathiPhone = [[NSBundle mainBundle] pathForResource:nameiPhone ofType:@"nib"];

    NSFileManager *fileManger = [NSFileManager defaultManager];

    if ([fileManger fileExistsAtPath:path] || [fileManger fileExistsAtPath:pathiPhone]) {
        return [[self alloc]initWithNibName:NSStringFromClass([self class]) bundle:nil];
    } else {
        return [[self alloc]init];
    }
}

+ (instancetype)storyboard:(NSString *)name viewid:(NSString *)key {
    UIStoryboard *stroryboard = [UIStoryboard storyboardWithName:name bundle:nil];

    return [stroryboard instantiateViewControllerWithIdentifier:key];
}

@end
