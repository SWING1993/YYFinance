//
//  QTBaseViewController+BankDetail.h
//  qtyd
//
//  Created by stephendsw on 15/8/18.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"
#import "BankModel.h"

@interface QTBaseViewController (BankDetail)

- (UIView *)getNoticeView:(NSDictionary *)value state:(QTbankState)state;

@end
