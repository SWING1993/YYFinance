//
//  BankDeailView.h
//  qtyd
//
//  Created by stephendsw on 15/8/18.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankDeailView : UIControl

@property (nonatomic, assign) BOOL      isValidte;
@property (nonatomic, strong) NSString  *bankid;
@property (nonatomic, strong) NSString  *bankcode;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isSafe;

@property (nonatomic, assign) BOOL isUpdate;




- (void)reset;

/**
 *  绑定安全卡
 *
 */
- (void)safeBind:(NSDictionary *)bankinfo;

/**
 *  绑定其他卡
 *
 */
- (void)bind:(NSDictionary *)bankinfo;

@end
