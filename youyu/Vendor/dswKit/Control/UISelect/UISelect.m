//
//  UISelect.m
//  qtyd
//
//  Created by stephendsw on 15/7/31.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UISelect.h"
#import <objc/runtime.h>
#import "UIViewExt.h"
#import "UIControl+BlockEvent.h"

@implementation UISelect
{
    NSArray *datas;
}

- (void)btnPicker1 {
    if (self.text.length == 0) {
        self.text = [self.selectDelegate rowValue:datas[0] uiselect:self];
    }

    [self resignFirstResponder];
}

//
#pragma mark - 选择框
static char *dropKey;

- (void)setInputDropList:(NSArray *)data {
    datas = data;
    objc_setAssociatedObject(self, &dropKey, data, OBJC_ASSOCIATION_COPY_NONATOMIC);

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    //    指定Delegate
    pickerView.delegate = self;
    //    显示选中框
    pickerView.showsSelectionIndicator = YES;

    self.inputView = pickerView;

    //
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(keyboardWillShown:)
    name    :UIKeyboardWillShowNotification
    object  :nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(keyboardWillHide:)
    name    :UIKeyboardWillHideNotification
    object  :nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *data = objc_getAssociatedObject(self, &dropKey);

    return data.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [UILabel new];

    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    NSArray *data = objc_getAssociatedObject(self, &dropKey);
    label.text = [self.selectDelegate rowValue:data[row] uiselect:self];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *data = objc_getAssociatedObject(self, &dropKey);

    self.value = data[row];
    [self.selectDelegate selectValue:self.value uiselect:self];
}

//

#pragma  mark - anmation
- (void)keyboardWillShown:(NSNotification *)value {
    if (self.isFirstResponder) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)value {
    if (self.isFirstResponder) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.transform = CGAffineTransformMakeRotation(2 * M_PI);
        }];
    }
}

#pragma  mark - 图标
- (void)setRightImage:(NSString *)imageName {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];

    img.frame = CGRectMake(0, 0, 44, img.height);
    img.contentMode = UIViewContentModeScaleAspectFit;
    self.rightView = img;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setLeftImage:(NSString *)imageName;
{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    img.frame = CGRectMake(0, 0, 44, img.height);
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self setLeftView:img];
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
