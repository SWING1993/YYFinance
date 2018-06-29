//
//  WLTimeButton.h
//  Car_ZJ
//
//  Created by stephen on 15/4/22.
//  Copyright (c) 2015年 网兰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  倒计时按钮
 */
@interface TimeCodeButton : UIButton

@property (nonatomic, assign) IBInspectable NSInteger countTime;

/**
 *  是否可用
 */
@property (nonatomic, assign) BOOL disabled;

@end
