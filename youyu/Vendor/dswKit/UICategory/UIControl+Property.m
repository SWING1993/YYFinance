//
//  UIControl+Property.m
//  qtyd
//
//  Created by stephendsw on 16/1/26.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "UIControl+Property.h"
#import <objc/runtime.h>
#import "NSObject+quick.h"
#import "UIColor+hexColor.h"

#define GRAY_COLOR [UIColor colorHex:@"#F0F0F0"]

@implementation UIControl (Property)

- (BOOL)showBackgroundColorHighlighted {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).intValue;
}

- (void)setShowBackgroundColorHighlighted:(BOOL)showBackgroundColorHighlighted {
    objc_setAssociatedObject(self, @selector(showBackgroundColorHighlighted), @(showBackgroundColorHighlighted), OBJC_ASSOCIATION_COPY_NONATOMIC);

    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchCancel];
}

- (void)willTouch
{}

- (void)didTouch
{}

- (void)touchDown:(id)sender {
    [self willTouch];

    UIColor *bc = [self.backgroundColor colorWithAlphaComponent:0.9];

    if ([self.backgroundColor isEqual:[UIColor whiteColor]]) {
        bc = GRAY_COLOR;
    }

    self.backgroundColor = bc;
}

- (void)touchUp:(id)sender {
    UIColor *bc = [self.backgroundColor colorWithAlphaComponent:1];

    if ([self.backgroundColor isEqual:GRAY_COLOR]) {
        bc = [UIColor whiteColor];
    }

    self.backgroundColor = bc;

    [self didTouch];
}

@end
