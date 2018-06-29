//
//  HSDHomeNewHandView.h
//  hsd
//
//  Created by 杨旭冉 on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSDInvestmentModel;

@interface HSDHomeNewHandView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *overageLabel;
@property (weak, nonatomic) IBOutlet UIButton *intevtBtn;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (nonatomic, strong) HSDInvestmentModel *model;

+ (instancetype) creatNewHandView;

@end
