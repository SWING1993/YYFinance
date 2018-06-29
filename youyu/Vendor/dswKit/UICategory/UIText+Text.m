//
//  UILabel+Text.m
//  qtyd
//
//  Created by stephendsw on 16/4/26.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "UIText+Text.h"
#import <objc/runtime.h>

@implementation UILabel (Text)

@dynamic isTextEmpty;

- (BOOL)isTextEmpty {
    return [NSString isEmpty:self.text];
}

@end

@implementation UITextField (Text)

@dynamic isTextEmpty;

- (BOOL)isTextEmpty {
    return [NSString isEmpty:self.text];
}

- (NSInteger)textLimit {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).integerValue;
}

- (void)setTextLimit:(NSInteger)textLimit {
    objc_setAssociatedObject(self, @selector(textLimit), @(textLimit), OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (textLimit > 0) {
        [self addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)changed:(id)sender {
    if (self.text.length > self.textLimit) {
        self.text = [self.text substringToIndex:135];
    }
}

@end

@implementation UITextView (Text)

@dynamic isTextEmpty;

- (BOOL)isTextEmpty {
    return [NSString isEmpty:self.text];
}

@end
