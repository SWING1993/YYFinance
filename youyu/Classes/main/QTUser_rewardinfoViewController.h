//
//  QTUser_rewardinfoViewController.h
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@interface QTUser_rewardinfoViewController : QTBaseViewController

/**
 *  0 红包  1 红包券 2 红包合并 3 合并详情
 */
@property (nonatomic, assign) NSInteger segment;

@property (nonatomic, strong) NSString *  rewardID;

@end
