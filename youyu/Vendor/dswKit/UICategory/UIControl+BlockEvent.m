//
//  UIControl+BlockEvent.m
//  test
//
//  Created by stephen on 15/3/5.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "UIControl+BlockEvent.h"
#import <objc/runtime.h>

@implementation UIControl (BlockEvent)

static char *clickEventKey;
static char *valueChangeEventKey;
static char *editChangeKey;

- (void)clickOn:(eventBlock)onblock off:(eventBlock)offblock {
    [self click:^(id value) {
        if (self.selected) {
            [self setSelected:NO];
            offblock(self);
        } else {
            [self setSelected:YES];
            onblock(self);
        }
    }];
}

- (void)click:(eventBlock)block {
    objc_setAssociatedObject(self, &clickEventKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);

    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(id)value {
    eventBlock blockClick = objc_getAssociatedObject(self, &clickEventKey);

    if (blockClick != nil) {
        blockClick(value);
    }
}

- (void)valueChange:(eventBlock)block {
    objc_setAssociatedObject(self, &valueChangeEventKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);

    [self addTarget:self action:@selector(valueChangeAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChangeAction:(id)value {
    eventBlock blockClick = objc_getAssociatedObject(self, &valueChangeEventKey);

    if (blockClick != nil) {
        blockClick(value);
    }
}

- (void)editChange:(eventBlock)block {
    objc_setAssociatedObject(self, &editChangeKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);

    [self addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
}

- (void)editChangeAction:(id)value {
    eventBlock blockClick = objc_getAssociatedObject(self, &editChangeKey);

    if (blockClick != nil) {
        blockClick(value);
    }
}

@end
