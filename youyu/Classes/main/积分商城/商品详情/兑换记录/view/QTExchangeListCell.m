//
//  QTExchangeListCell.m
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTExchangeListCell.h"
#import "NSString+model.h"

@interface QTExchangeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbNAME;

@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel    *lbNum;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end

@implementation QTExchangeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)bind:(NSDictionary *)obj {
    if ([NSString isEmpty:obj.str(@"nick_name")]) {
        self.lbNAME.text = obj.str(@"phone");
    } else {
        self.lbNAME.text = [obj.str(@"nick_name")  realNameFormat];
    }

    self.lbPoint.text = [@(obj.fl(@"point") * obj.fl(@"unit"))stringValue];
    self.lbNum.text = obj.str(@"unit");
    self.lbTime.text = [obj.str(@"addtime") timeValue];
}

@end
