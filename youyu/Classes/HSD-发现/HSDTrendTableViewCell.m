//
//  HSDTrendTableViewCell.m
//  hsd
//
//  Created by 杨旭冉 on 2017/10/24.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDTrendTableViewCell.h"

@implementation HSDTrendTableViewCell

static NSString *const identifier = @"HSDTrendTableViewCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype) cellWithTableView:(UITableView *)tableView{
    HSDTrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
