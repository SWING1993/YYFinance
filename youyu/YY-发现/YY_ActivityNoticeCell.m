//
//  YY_ActivityNoticeCell.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_ActivityNoticeCell.h"

@interface YY_ActivityNoticeCell()
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *imView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation YY_ActivityNoticeCell
static NSString *const identifier = @"YY_ActivityNoticeCell";
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [Theme backgroundColor];
    self.contentView.backgroundColor = [Theme backgroundColor];
    //圆角,阴影
//    self.coverView.layer.masksToBounds = YES;
    self.coverView.layer.cornerRadius = 5;
    self.coverView.layer.shadowColor = LightGrayColor.CGColor;
    self.coverView.layer.shadowOpacity = 0.2;
    self.coverView.layer.shadowRadius = 5;
    self.coverView.layer.shadowOffset = CGSizeMake(0, 0);
    
    //圆角
    self.imView.layer.masksToBounds = YES;
    self.imView.layer.cornerRadius = 5;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YY_ActivityNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)bind:(NSDictionary *)obj {
    /**id = 802;
    litpic = "http://www.hushangdai.com/";
    name = "\U4f5c\U4e3a\U4e00\U540d\U5ba2\U670d\Uff0c\U6211\U4eec\U8be5\U5982\U4f55\U6b23\U8d4f\U5ba2\U6237\Uff1f";
    publish = "2017-05-09 13:37:45";
    summary = "";};*/
    [self.imView sd_setImageWithURL:[NSURL URLWithString:obj.str(@"litpic")] placeholderImage:[UIImage imageNamed:@"mall_default"]];//
    self.titleLabel.text = obj.str(@"name");
    self.timeLabel.text = obj.str(@"publish");

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
