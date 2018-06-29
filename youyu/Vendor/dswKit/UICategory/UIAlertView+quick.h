//
//  UIAlertView+quick.h
//  test
//
//  Created by stephen on 15/3/19.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ alertBlock) (NSInteger index);

@interface UIAlertView (quick)<UIAlertViewDelegate>

- (void)clickedIndex:(alertBlock)block;

@end

@interface UIActionSheet (quick)<UIActionSheetDelegate>

- (void)clickedIndex:(alertBlock)block;

@end
