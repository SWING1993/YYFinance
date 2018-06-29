//
//  UISelect.h
//  qtyd
//
//  Created by stephendsw on 15/7/31.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UISelect;

@protocol UISelectDelegate<NSObject>

- (NSString *)rowValue:(id)value uiselect:(UISelect *)select;

- (void)selectValue:(id)value uiselect:(UISelect *)select;

@end

@interface UISelect : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<UISelectDelegate> selectDelegate;

/**
 *  选中的值
 */
@property (nonatomic, strong) NSDictionary *value;

/**
 *  选择输入
 *
 *  @param data 数据源
 */
- (void)setInputDropList:(NSArray *)data;

- (void)setRightImage:(NSString *)imageName;

- (void)setLeftImage:(NSString *)imageName;

@end
