//
//  DStackView+Add.h
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "DStackView.h"

@interface DStackView (Add)

- (UIButton *)addRowButtonTitle:(NSString *)str click:(void (^)(id value))block;
- (UILabel *)addTelephoneButtonTitle:(NSString *)str click:(void (^)(id value))block;
/**
 *   添加  提交按钮 圆框  颜色渐变
 *
 */
- (UIButton *)addSubmitButtonTitle:(NSString *)str click:(void (^)(id value))block;

- (UIButton *)gj_addSubmitButtonTitle:(NSString *)str click:(void (^)(id))block;
@end
