//
//  CGRect+other.h
//  test
//
//  Created by stephendsw on 15/9/11.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  添加边距
 *
 */
CGRect CGRectEdgeInsets(CGRect rect, UIEdgeInsets edge);

/**
 *  添加 newRect 到oldRect 底部
 *
 */
CGRect CGRectOffsetBottom(CGRect oldRect, CGRect newRect);

/**
 *  添加 newRect 到oldRect 右边
 *
 */
CGRect CGRectOffsetRight(CGRect oldRect, CGRect newRect);
