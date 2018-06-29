//
//  QTUser_rewardinfoCell.h
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"

@interface QTUser_rewardinfoCellQuan : DTableViewCell

@property (nonatomic, assign) BOOL isQuan;

-(void)setTap;

- (void)setSelectStyle;

- (void)setUnselectStyle;

- (void)setMergeStyle;

- (void)setInvestStyle;

@end
