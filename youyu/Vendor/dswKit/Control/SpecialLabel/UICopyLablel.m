//
//  UICopyLablel.m
//  qtyd
//
//  Created by stephendsw on 15/8/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UICopyLablel.h"

@implementation UICopyLablel

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(copy:);
}

- (void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];

    pboard.string = self.text;
}

- (void)attachTapHandler {
    self.userInteractionEnabled = YES;  // 用户交互的总开关

    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    touch.numberOfTapsRequired = 1;

    [self addGestureRecognizer:touch];
}

- (void)handleTap:(UIGestureRecognizer *)recognizer {
    [self becomeFirstResponder];

    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"

        action                                              :@selector(copy:)];

    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];

    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];

    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self attachTapHandler];
}

@end
