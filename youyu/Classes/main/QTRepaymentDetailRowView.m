//
//  QTRepaymentDetailRowView.m
//  qtyd
//
//  Created by stephendsw on 16/5/10.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRepaymentDetailRowView.h"

@interface QTRepaymentDetailRowView ()
@property (weak, nonatomic) IBOutlet UILabel        *lbStage;
@property (weak, nonatomic) IBOutlet UILabel        *lbCapital;
@property (weak, nonatomic) IBOutlet UILabel        *lbInterest;
@property (weak, nonatomic) IBOutlet UILabel        *lbTime;
@property (weak, nonatomic) IBOutlet UIImageView    *img;

@end

@implementation QTRepaymentDetailRowView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [Theme viewBackgroundColor];
    self.lbStage.text = @"期数";
    self.lbCapital.text = @"本金(元)";
    self.lbInterest.text = @"利息(元)";
    self.lbTime.text = @"状态";
}

- (void)bind:(NSDictionary *)item {
    NSString *stage = [NSString stringWithFormat:@"%@/%@期", item.str(@"current_stage"), item.str(@"total_stage")];

    self.lbStage.text = stage;
    self.lbCapital.text = item.str(@"capital");
    self.lbInterest.text = item.str(@"interest");

    NSString                    *t = item.str(@"repay_time").timeValue;
    NSMutableAttributedString   *attstr = [[NSMutableAttributedString alloc] initWithString:[t stringWithDateFormat:@"MM-dd"].add(@" ")];

    BOOL hasGet = item.i(@"repay_status");

    if (hasGet) {
        UIImage *image = [[UIImage imageNamed:@"icon_complete"] imageWithColor:[Theme greenColor]];

        self.img.image = image;
    } else {
        UIImage *image = [[UIImage imageNamed:@"icon_unfinished"] imageWithColor:[Theme grayColor]];

        self.img.image = image;
    }

    self.lbTime.attributedText = attstr;
}

@end
