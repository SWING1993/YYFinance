//
//  QTPageInvestRecordViewController.h
//  qtyd
//
//  Created by stephendsw on 15/10/14.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "WMPageController.h"

@interface QTPageViewController : WMPageController

/**
 *  1 : 投资记录 2.我的订单
 */

@property (nonatomic, assign) NSInteger type;

/**
 *  返回上一页
 */
@property (nonatomic, assign) BOOL backBefore;

@end
