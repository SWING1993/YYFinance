//
//  UILabel+preview.h
//  hr
//
//  Created by 慧融 on 21/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (preview)

@property (nonatomic, copy) NSString *fillColorStr;

/**
 *  label内容预览
 */
+ (UILabel*)labelContentPreView:(UITextField*)textField;

/**
 *  label内容提示
 */

+ (UILabel*)labelTipInfo:(UITextField*)textField content:(NSString*)str;

@end
