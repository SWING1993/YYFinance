//
//  QTRecordDetailCell.m
//  qtyd
//
//  Created by stephendsw on 15/8/5.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTRecordDetailCell.h"
#import "NSString+model.h"

@interface QTRecordDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbnum;

@property (weak, nonatomic) IBOutlet UILabel    *lbtime;
@property (weak, nonatomic) IBOutlet UILabel    *lbrate;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lbType;

@end

@implementation QTRecordDetailCell

- (void)bind:(NSDictionary *)obj {
    self.lbnum.text = obj.str(@"sn");
    self.lbtime.text = [obj.str(@"repay_time") dateValue];
    self.lbType.clipsToBounds = YES;
    self.lbType.layer.cornerRadius = 3.0f;
    self.lbType.text = obj[@"repay_type"];
    self.lbrate.text = [NSString stringWithFormat:@"%@ 元", obj[@"repay_money"]];

    if (obj.i(@"repay_status") == 0) {
        self.image.hidden = YES;
    } else {
        self.image.hidden = NO;
    }
}

@end
