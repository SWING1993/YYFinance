//
//  UIAlertView+quick.m
//  test
//
//  Created by stephen on 15/3/19.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "UIAlertView+quick.h"
#import <objc/runtime.h>

@implementation UIAlertView (quick)

static char *Key;

- (void)clickedIndex:(alertBlock)block {
    self.delegate = self;
    objc_setAssociatedObject(self, &Key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    alertBlock blockClick = objc_getAssociatedObject(self, &Key);

    blockClick(buttonIndex);
}

@end

@implementation UIActionSheet (quick)

static char *Key;

- (void)clickedIndex:(alertBlock)block {
    self.delegate = self;
    objc_setAssociatedObject(self, &Key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    alertBlock blockClick = objc_getAssociatedObject(self, &Key);

    blockClick(buttonIndex);
}

@end
