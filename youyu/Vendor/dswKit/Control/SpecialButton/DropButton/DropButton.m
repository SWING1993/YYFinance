//
//  DropButton.m
//  qtyd
//
//  Created by stephendsw on 15/8/7.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "DropButton.h"

@interface DropButton ()

@end

@implementation DropButton {
    BOOL isDrop;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self hide];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    isDrop = YES;
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(1, -1);
    }];
    isDrop = NO;
}

- (void)clickDown:(eventBlock)done {
    [self click:^(id value) {
        if (isDrop) {
            [self hide];
        } else {
            [self show];
        }

        done(self);
    }];
}

@end
