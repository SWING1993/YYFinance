//
//  UITextField+input.m
//  Car_ZJ
//
//  Created by stephen on 15/4/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UITextField+input.h"
#import <objc/runtime.h>
#import "UIViewExt.h"
#import "UIControl+BlockEvent.h"


@implementation UITextField (input)

//
#pragma mark - 选择时间
- (void)setInputTime {
    NSDateFormatter *formatter;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    UIDatePicker *picker1 = [[UIDatePicker alloc] init];
    picker1.maximumDate = [NSDate date];
    picker1.datePickerMode = UIDatePickerModeDate;
    [picker1 valueChange:^(id value) {
        self.text = [formatter stringFromDate:[picker1 date]];
    }];

    self.inputView = picker1;
}

- (void)btnPicker1 {
    [self resignFirstResponder];
}

//
#pragma mark - 选择框
static char *dropKey;

- (void)setInputDropList:(NSArray *)data {
    objc_setAssociatedObject(self, &dropKey, data, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.enabled = YES;

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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *data = objc_getAssociatedObject(self, &dropKey);

    return data[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *data = objc_getAssociatedObject(self, &dropKey);

    self.text = data[row];
}

//

#pragma  mark - anmation
- (void)keyboardWillShown:(NSNotification *)value {
    if (self.isFirstResponder) {
        [UIView animateWithDuration:1 animations:^{
            self.rightView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)value {
    if (self.isFirstResponder) {
        [UIView animateWithDuration:1 animations:^{
            self.rightView.transform = CGAffineTransformMakeRotation(2 * M_PI);
        }];
    }
}

#pragma  mark - 图标
- (void)setRightImage:(NSString *)imageName {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];

    img.frame = CGRectMake(0, 0, img.width, img.height);
    img.contentMode = UIViewContentModeCenter;
    self.rightView = img;
    self.rightViewMode = UITextFieldViewModeAlways;
    img.userInteractionEnabled = NO;
    if ([imageName isEqualToString:@"YY_eyeClose"] || [imageName isEqualToString:@"YY_eyeOpen"]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doClick)];
        [img addGestureRecognizer:tap];
    }
}

- (void)doClick{
    self.secureTextEntry = !self.secureTextEntry;
    [self setRightImageAction:!self.secureTextEntry];
}

- (void)setLeftImage:(NSString *)imageName;
{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    img.frame = CGRectMake(0, 0, img.width, img.height);
    img.contentMode = UIViewContentModeCenter;

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, img.width + 8, img.height);
    [view addSubview:img];

    [self setLeftView:view];
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setRightImageAction:(BOOL)eyeOpen{
    UIImageView *imgV = (UIImageView *)self.rightView;
    imgV.userInteractionEnabled = YES;
    if (eyeOpen == NO) {
        imgV.image = IMG(@"YY_eyeClose");
    }else{
        imgV.image = IMG(@"YY_eyeOpen");
    }
    
}

@end
