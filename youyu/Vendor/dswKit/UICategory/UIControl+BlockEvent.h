//
//  UIControl+BlockEvent.h
//  test
//
//  Created by stephen on 15/3/5.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ eventBlock)(id value);

@interface UIControl (BlockEvent)

- (void)click:(eventBlock)block;

- (void)valueChange:(eventBlock)block;

-(void)editChange:(eventBlock)block;

-(void)clickOn:(eventBlock)onblock off:(eventBlock)offblock;


@end
