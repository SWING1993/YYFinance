//
//  UIScrollView+quick.m
//  BCDD
//
//  Created by stephen on 15/4/9.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "UIScrollView+contentSize.h"
#import "UIViewExt.h"

@implementation UIScrollView (contentSize)

- (void)autoContentSize {
    CGFloat maxy = 0;

    for (UIView *item in self.subviews) {
        if ([item isKindOfClass:[UIImageView class]]) {
            continue;
        }

        if (item.height + item.top > maxy) {
            maxy = item.height + item.top;
        }
    }

   
    self.contentSize = CGSizeMake(0, maxy );

}

@end
