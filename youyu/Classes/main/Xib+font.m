//
//  UIButton+font.m
//  qtyd
//
//  Created by stephendsw on 15/10/13.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "Xib+font.h"

@implementation UIButton (myFont)

+ (void)load {
    Method  imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method  myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder *)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.titleLabel.font.pointSize;
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

@end

@implementation UILabel (myFont)

+ (void)load {
    Method  imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method  myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder *)aDecode {
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

@end
