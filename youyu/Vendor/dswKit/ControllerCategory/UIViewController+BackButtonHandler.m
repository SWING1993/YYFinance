//
//  UIViewController+BackButtonHandler.m
//  qtyd
//
//  Created by stephendsw on 15/8/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UIViewController+BackButtonHandler.h"

@implementation UIViewController (BackButtonHandler)

- (BOOL)navigationShouldPopOnBackButton {
    return YES;
}

@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if ([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }

    BOOL shouldPop = YES;

    UIViewController *vc = [self topViewController];

    if ([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }

    if (shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906

        for (UIView *subview in [navigationBar subviews]) {
            if (subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }

    return NO;
}

@end
