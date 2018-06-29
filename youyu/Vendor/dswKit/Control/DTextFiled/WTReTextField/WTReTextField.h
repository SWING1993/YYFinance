//
//  WTReTextField.h
//  WTReTextField
//
//  Created by Alex Skalozub on 5/5/13.
//  Copyright (c) 2013 Alex Skalozub.
//

// 例子
// pattern = @"^(\\d{4}(?: )){3}\\d{4}$";
// pattern = @"^[a-zA-Z ]{3,}$";
// pattern = @"^(1[0-2]|(?:0)[1-9])(?:/)\\d{2}$";
// pattern = @"^\\d{3}$";
//
// pattern = @"^(3[0-1]|[1-2][0-9]|(?:0)[1-9])(?:\\.)(1[0-2]|(?:0)[1-9])(?:\\.)[1-9][0-9]{3}$";
// pattern = @"^(2[0-3]|1[0-9]|(?:0)[0-9])(?:\\.)(\\d{0,2})$";
//

#import <UIKit/UIKit.h>

@class WTReParser;

@interface WTReTextField : UITextField
{
    NSString    *_lastAcceptedValue;
    WTReParser  *_parser;
}

#pragma  mark - 验证

/**
 *  正则表达式
 */
@property (strong, nonatomic) NSString *pattern;

/**
 *  验证的分组
 */
@property (nonatomic, assign) NSInteger group;

/**
 *  必填
 */
@property (nonatomic, assign) BOOL isNeed;

/**
 *  验证的错误提示
 */
@property (nonatomic, strong) NSString *errorTip;

/**
 *  为空的错误提示
 */
@property (nonatomic, strong) NSString *nilTip;

#pragma mark - 布局

@property (nonatomic, assign) float leftPadding;

@property (nonatomic, assign) float rightPadding;

@end
