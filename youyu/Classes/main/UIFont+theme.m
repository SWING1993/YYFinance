//
//  UIFont+theme.m
//  qtyd
//
//  Created by stephendsw on 15/10/13.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "UIFont+theme.h"
#import <objc/runtime.h>

@implementation UIFont (theme)

//+ (void)load {
//    Method  imp = class_getClassMethod([self class], @selector(systemFontOfSize:));
//    Method  myImp = class_getClassMethod([self class], @selector(qtFontOfSize:));
//
//    method_exchangeImplementations(imp, myImp);
//}

+ (UIFont *)qtFontOfSize:(CGFloat)fontSize {
    return [UIFont qtFontOfSize:[UIFont sizeQTFont:fontSize]];
}

+ (NSInteger)sizeQTFont:(NSInteger)size {
    if (IPHONE6) {
        return size + 1;
    }

    if (IPHONE6PLUS) {
        return size + 1;
    } else {
        return size;
    }
}

@end
