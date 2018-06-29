//
//  DGridView+Add.h
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "DGridView.h"
#import "WTReTextField.h"
#import "UISelect.h"

@interface DGridView (Add)

#pragma mark - 输入
//添加 文本-输入框 by GJ(实名绑卡用)
- (WTReTextField *)gj_addRowInput:(NSString *)title placeholder:(NSString *)str;

// 添加  文本-输入框
- (WTReTextField *)addRowInput:(NSString *)title placeholder:(NSString *)str;

// 添加  长文本-输入框
- (WTReTextField *)addRowLongInput:(NSString *)title placeholder:(NSString *)str;

// 添加  文本-输入框-文本
- (WTReTextField *)addRowInput:(NSString *)title placeholder:(NSString *)str tagText:(NSString *)tag;
// 添加  文本-输入框-按钮-文本
- (WTReTextField *)addRowInput:(NSString *)title placeholder:(NSString *)str tagText:(NSString *)tag doneBlock:(void(^)(id value))block;

// 添加  输入框
- (WTReTextField *)addRowInputWithplaceholder:(NSString *)str;

/**
 *   添加  输入框-圆框
 *
 */
- (WTReTextField *)addRowInputWithplaceholderRoundRect:(NSString *)str;

// 添加  输入框 - 下拉
- (WTReTextField *)addRowInputWithplaceholder:(NSString *)str Arrow:(NSString *)image block:(void (^)(id value))block;

#pragma mark - 文本

/**
 *   添加  文本-文本
 *
 */
- (UILabel *)addRowLabel:(NSString *)title text:(NSString *)str;

/**
 *   添加  文本
 *
 */
- (UILabel *)addRowLabel:(NSString *)title;

#pragma mark - 点击

/**
 *   添加  文本-点击跳转（提示文字）
 *
 */
- (WTReTextField *)addRowSelectText:(NSString *)title placeholder:(NSString *)str done:(void (^)())block;

/**
 *  添加  文本-点击跳转（提示箭头）
 *
 */
- (void)addRowSelectArrow:(NSString *)title done:(void (^)())block;

/**
 *  添加  文本-按钮
 *
 */
- (UIButton *)addRowClickButtonTitle:(NSString *)str click:(void (^)(id value))block;

- (UIButton*)addView:(UIView*)view RowClickButtonTitle:(NSString*)str click:(void(^)(id value))block;

#pragma mark - 选择

/**
 *  添加  文本-下拉框 textfiled
 */
- (WTReTextField *)addRowDropText:(NSString *)title placeholder:(NSString *)str;

/**
 *  添加  文本-下拉框 uiselect
 */
- (UISelect *)addRowDropSelect:(NSString *)title placeholder:(NSString *)str;

#pragma mark - 其他

/**
 *   添加  文本-验证码
 *
 */
- (WTReTextField *)addRowCodeText:(void (^)(id value))block;

/**
 *   添加 验证码
 *
 */
- (WTReTextField *)addRowCodeTextNoTitle:(void (^)(id value))block;

/**
 *  添加  文本-Swicth
 *
 */
- (UISwitch *)addRowSwitch:(NSString *)title;

@end
