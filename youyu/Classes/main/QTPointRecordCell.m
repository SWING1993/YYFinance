//
//  QTPointRecordCell.m
//  qtyd
//
//  Created by stephendsw on 16/3/1.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTPointRecordCell.h"
#import "UIColor+hexColor.h"

@interface QTPointRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel    *lbTime;
@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;

@end

@implementation QTPointRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lbTitle.preferredMaxLayoutWidth=APP_WIDTH-(320-288);
}

- (void)bind:(NSDictionary *)obj {
    self.lbTitle.text = obj.str(@"source");
    self.lbTime.text = [obj.str(@"addtime") timeValue];

    NSString *point_type = obj.str(@"point_type");

    if ([point_type isEqualToString:@"1"]) {
        self.lbPoint.text = @"+".add(obj.str(@"point"));
        self.lbPoint.textColor=[UIColor redColor];
    } else {
        self.lbPoint.text = @"-".add(obj.str(@"point"));
        self.lbPoint.textColor=[UIColor colorHex:@"#8fc31f"];
    }
}

@end
