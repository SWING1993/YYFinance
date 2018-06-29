//
//  UIView+FormValidation.m
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "UIView+FormValidation.h"
#import "UIView+layout.h"
#import "WTReTextField.h"
#import "NSString+regularExpression.h"
#import "UIViewController+toast.h"

@implementation UIView (FormValidation)

- (BOOL)validation:(NSInteger)group {
    for (UIView *item in self.allSubviews) {
        if ([item isKindOfClass:[WTReTextField class]]) {
            WTReTextField *wtf = (WTReTextField *)item;

            if (wtf.group != group) {
                continue;
            }

            if (wtf.isNeed && (wtf.text.length == 0)) {
                [self.viewController showToast:wtf.nilTip];
                return NO;
            }

            if ((wtf.pattern.length > 0) && ![wtf.text isMatch:wtf.pattern]) {
                [self.viewController showToast:wtf.errorTip];
                return NO;
            }
        }
    }

    return YES;
}

@end
