//
//  UITextField+input.h
//  Car_ZJ
//
//  Created by stephen on 15/4/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextField (input)<UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  输入时间
 */
- (void)setInputTime;

/**
 *  选择输入
 *
 *  @param data 数据源
 */
- (void)setInputDropList:(NSArray *)data;

- (void)setRightImage:(NSString *)imageName;

- (void)setLeftImage:(NSString *)imageName;

- (void)setRightImageAction:(BOOL)eyeOpen;

@end
