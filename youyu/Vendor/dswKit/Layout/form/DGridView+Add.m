//
//  DGridView+Add.m
//  qtyd
//
//  Created by stephendsw on 15/9/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "DGridView+Add.h"
#import "UITextField+input.h"
#import "TimeCodeButton.h"
#import "PlaceholderTextView.h"
#import "UISelect.h"

@implementation DGridView (Add)

#pragma  mark - 元素
//添加 文本-输入框 by GJ(实名绑卡用)
- (WTReTextField *)gj_addRowInput:(NSString *)title placeholder:(NSString *)str {
    UILabel *label = [[UILabel alloc]init];
    
    label.text = title;
    [self setLabelStyle:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [self addView:label crossColumn:column / 16 * 4];
    
    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    tfview.textColor = [UIColor lightGrayColor];
    tfview.font = [UIFont systemFontOfSize:12];;
    [self addView:tfview crossColumn:column / 16 * 12];
    
    return tfview;
}

/**
 *  添加  文本-按钮
 *
 */
- (UIButton *)addRowClickButtonTitle:(NSString *)str click:(void (^)(id value))block {
    UILabel *label = [[UILabel alloc]init];

    label.text = str;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4 * 3];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:str forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 0, 44);
    [self setRightButtonStyle:button];

    [button click:^(id value) {
        block(value);
    }];
    [self addView:button crossColumn:column / 4  margin:UIEdgeInsetsMake(10, 0, 10, 0)];
    return button;
}
//添加文本，按钮
// [grid addView:self.lbyuer margin:UIEdgeInsetsMake(8, 0, 8, 0)];
- (UIButton*)addView:(UIView*)view RowClickButtonTitle:(NSString*)str click:(void(^)(id value))block{
    [self addView:view crossColumn:column/4*3];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:str forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 0, 44);
    [self setSubmitButtonStyle:button];
    [button click:^(id value) {
        block(value);
    }];
    [self addView:button crossColumn:column/4 margin:UIEdgeInsetsMake(10, 0, 10, 0)];
    return button;

}

// 添加  长文本-输入框
- (WTReTextField *)addRowLongInput:(NSString *)title placeholder:(NSString *)str {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 16 * 6];

    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.textAlignment = NSTextAlignmentRight;
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 16 * 10];

    return tfview;
}

// 添加  文本-输入框
- (WTReTextField *)addRowInput:(NSString *)title placeholder:(NSString *)str {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 16 * 4];

    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 16 * 12];

    return tfview;
}

/**
 *   添加  输入框
 *
 */
- (WTReTextField *)addRowInputWithplaceholder:(NSString *)str {
    WTReTextField *tfview = [[WTReTextField alloc]init];

    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column];

    return tfview;
}

/**
 *   添加  输入框-圆框
 *
 */
- (WTReTextField *)addRowInputWithplaceholderRoundRect:(NSString *)str {
    WTReTextField *tfview = [[WTReTextField alloc]init];
    
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
   
    tfview.borderStyle = UITextBorderStyleRoundedRect;
    [self addView:tfview crossColumn:column];
    self.lineColor = Theme.backgroundColor;
    tfview.superview.backgroundColor = Theme.backgroundColor;
    
    return tfview;
}

/**
 *   添加  输入框 - 下拉
 *
 */
- (WTReTextField *)addRowInputWithplaceholder:(NSString *)str Arrow:(NSString *)image block:(void (^)(id value))block {
    WTReTextField *tfview = [[WTReTextField alloc]init];

    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 16 * 15];

    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imageview.contentMode = UIViewContentModeScaleAspectFit;

    [self addView:imageview crossColumn:column / 16 * 1];

    [imageview addTapGesture:^{
        block(imageview);
    }];

    return tfview;
}

/**
 *   添加  文本-文本
 *
 */
- (UILabel *)addRowLabel:(NSString *)title text:(NSString *)str {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 16 * 5];

    UILabel *label2 = [[UILabel alloc]init];
    label2.text = str;
    label2.numberOfLines = 0;
    label2.textAlignment = NSTextAlignmentRight;
    [self setLabelStyle:label2];
    label2.textColor = [UIColor colorHex:@"666666"];
    [self addView:label2 crossColumn:column / 16 * 11];
    return label2;
}

/**
 *   添加  文本
 *
 */
- (UILabel *)addRowLabel:(NSString *)title  {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column];

    return label;
}

//  添加  文本-下啦
- (WTReTextField *)addRowDropText:(NSString *)title placeholder:(NSString *)str  {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4];

    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = str;
    tfview.enabled = NO;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 4 * 3];

    return tfview;
}

/**
 *  添加  文本-下拉框 uiselect
 */
- (UISelect *)addRowDropSelect:(NSString *)title placeholder:(NSString *)str {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4];

    UISelect *tfview = [[UISelect alloc]init];
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 4 * 3];

    return tfview;
}

//  添加  文本-选择框
- (WTReTextField *)addRowSelectText:(NSString *)title placeholder:(NSString *)str done:(void (^)())block; {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4];

    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = str;
    tfview.enabled = NO;
    [self setTfviewStyle:tfview];
    [tfview setRightImage:@"icon-arrows-"];
    tfview.rightPadding = 5;

    UIView *temp = [[UIView alloc]init];
    [self bindKeyPath:@"frame" object:temp block:^(id newobj){
        tfview.frame = CGRectMake(0, 0, temp.width, temp.height);
    }];
    [temp addSubview:tfview];

    [temp addTapGesture:^{
        [self endEditing:YES];
        block();
    }];

    [self addView:temp crossColumn:column / 4 * 3];

    return tfview;
}

//  添加  文本-选择
- (void)addRowSelectArrow:(NSString *)title done:(void (^)())block; {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4 * 2];

    WTReTextField *tfview = [[WTReTextField alloc]init];

    tfview.enabled = NO;
    [self setTfviewStyle:tfview];
    [tfview setRightImage:@"icon-arrows-"];

    UIView *temp = [[UIView alloc]init];
    [self bindKeyPath:@"frame" object:temp block:^(id newobj){
        tfview.frame = CGRectMake(0, 0, temp.width, temp.height);
    }];
    [temp addSubview:tfview];

    [temp addTapGesture:^{
        block();
    }];

    [self addView:temp crossColumn:column / 4 * 2];
}

// 添加  文本-验证码
- (WTReTextField *)addRowCodeText:(void (^)(id value))block; {
    UILabel *label = [[UILabel alloc]init];

    label.text = @"验证码";
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 16 * 4];

    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = @"请输入验证码";
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 16 * 6];

    TimeCodeButton *button = [TimeCodeButton buttonWithType:UIButtonTypeCustom];
    [button click:^(id value) {
        UIButton *btn = value;
        btn.enabled = NO;
        block(value);
    }];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self addView:button crossColumn:column / 16 * 6 margin:UIEdgeInsetsMake(5, 0, 5, 0)];
    [self setCodeButtonStyle:button];

    return tfview;
}

// 添加  验证码
- (WTReTextField *)addRowCodeTextNoTitle:(void (^)(id value))block; {
    
    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = @"请输入验证码";
    [self setTfviewStyle:tfview];
    tfview.borderStyle = UITextBorderStyleRoundedRect;
    [self addView:tfview crossColumn:column];
    self.lineColor = Theme.backgroundColor;
    tfview.superview.backgroundColor = Theme.backgroundColor;
    
    TimeCodeButton *button = [TimeCodeButton buttonWithType:UIButtonTypeCustom];
    [button click:^(id value) {
        UIButton *btn = value;
        btn.enabled = NO;
        block(value);
    }];
    
    [button setTitle:@"获取验证码   " forState:UIControlStateNormal];
    [button sizeToFit];
    [self setCodeButtonStyle:button];
    [button setTitleColor:MainColor forState:UIControlStateNormal];
    button.layer.borderWidth = 0.0f;
    tfview.rightViewMode = UITextFieldViewModeAlways;
    tfview.rightView = button;

    return tfview;
}

/**
 *  添加  文本-输入框-文本
 *
 */
- (WTReTextField *)addRowInput:(NSString *)title placeholder:(NSString *)str tagText:(NSString *)tag {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4];

    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 16 * 11];

    UILabel *labelTag = [[UILabel alloc]init];
    labelTag.textAlignment = NSTextAlignmentRight;
    labelTag.text = tag;
    [self setLabelStyle:labelTag];
    labelTag.font = [UIFont systemFontOfSize:10];
    [self addView:labelTag crossColumn:column / 16 * 1];

    return tfview;
}

/**
 *  添加  文本-输入框-按钮-文本
 *
 */

- (WTReTextField *)addRowInput:(NSString *)title placeholder:(NSString *)str tagText:(NSString *)tag doneBlock:(void(^)(id value))block{
    UILabel *label = [[UILabel alloc]init];
    
    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4];
    
    WTReTextField *tfview = [[WTReTextField alloc]init];
    tfview.placeholder = str;
    [self setTfviewStyle:tfview];
    [self addView:tfview crossColumn:column / 16 * 7];
    
    UILabel *labelTag = [[UILabel alloc]init];
    labelTag.textAlignment = NSTextAlignmentCenter;
    labelTag.text = tag;
    [self setLabelStyle:labelTag];
    labelTag.font = [UIFont systemFontOfSize:10];
    [self addView:labelTag crossColumn:column / 16 * 1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"全部余额" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 0, 44);
    [self setRightButtonStyle:button];
    
    [button click:^(id value) {
        block(value);
    }];
    [self addView:button crossColumn:column / 4  margin:UIEdgeInsetsMake(10, 0, 10, 0)];

    
    return tfview;
}


/**
 *  添加  文本-Swicth
 *
 */
- (UISwitch *)addRowSwitch:(NSString *)title   {
    UILabel *label = [[UILabel alloc]init];

    label.text = title;
    [self setLabelStyle:label];
    [self addView:label crossColumn:column / 4 * 3];

    UISwitch *switchBtb = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];

    double left = self.width / 4 - 51;

    [self addView:switchBtb crossColumn:column / 4 margin:UIEdgeInsetsMake(7, left, 7, 0)];

    return switchBtb;
}

@end
