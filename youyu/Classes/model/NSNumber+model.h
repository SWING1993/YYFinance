//
//  NSNumber+model.h
//  qtyd
//
//  Created by stephendsw on 2016/12/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (model)

#pragma mark - 金额

/**
 *  格式化金额(xxx,xxx,xx),用于显示数据
 */
- (NSString *)moneyFormatShow;

/**
 *  格式化金额，保留2位小数，用于计算数据
 */
- (NSString *)moneyFormatData;

/**
 * 格式化金额(xxx,xxx,xx),用于显示数据 小数点后字体小
 *
 */
- (NSAttributedString *)moneyFormatZeroShow;

@end
