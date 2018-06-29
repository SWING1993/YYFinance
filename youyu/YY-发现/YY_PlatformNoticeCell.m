//
//  YY_PlatformNoticeCell.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_PlatformNoticeCell.h"

@interface YY_PlatformNoticeCell()
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation YY_PlatformNoticeCell
static NSString * const identifier = @"YY_PlatformNoticeCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [Theme backgroundColor];
    //圆角,阴影
//    self.coverView.layer.masksToBounds = YES;
//    self.coverView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.coverView.layer.borderWidth = 0.3;
    self.coverView.layer.cornerRadius = 5;
    self.coverView.layer.shadowColor = LightGrayColor.CGColor;
    self.coverView.layer.shadowOpacity = 0.2;
    self.coverView.layer.shadowRadius = 5;
    self.coverView.layer.shadowOffset = CGSizeMake(0, 0);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YY_PlatformNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)bind:(NSDictionary *)obj {
    self.contentLabel.text = obj.str(@"abstract");
    self.titleLabel.text = obj.str(@"name");
    self.timeLabel.text = obj.str(@"publish");
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
