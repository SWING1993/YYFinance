//
//  HRHomeTableViewCell.h
//  hr
//
//  Created by 赵 on 05/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"
@class HSDInvestmentModel;

@interface HRHomeTableViewCell : DTableViewCell

@property (nonatomic, strong) HSDInvestmentModel *model;
@property (nonatomic,assign) BOOL enable;
//@property (weak, nonatomic) IBOutlet UIButton *investButton;

@property (nonatomic, copy) void (^investmentBlock) (void);

@end
