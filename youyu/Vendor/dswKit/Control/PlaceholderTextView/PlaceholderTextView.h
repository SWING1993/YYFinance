//
//  PlaceholderTextView.h
//  wyh
//
//  Created by Lee on 16/1/5.
//  Copyright © 2016年 HW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, copy) IBInspectable NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSInteger limitNum;

- (void)textChanged:(NSNotification *)notification;

@end
