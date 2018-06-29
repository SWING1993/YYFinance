//
//  QTBankViewController.h
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"
#import "QTBaseViewController+Table.h"

@protocol BankDelegate<NSObject>

- (void)bankSelect:(NSDictionary *)bankinfo;

@end

@interface QTBankViewController : QTBaseViewController

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL need_verified;

@property (nonatomic, weak) id<BankDelegate> bankDelegate;

@end
