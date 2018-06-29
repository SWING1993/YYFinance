//
//  QTMenuCell.m
//  qtyd
//
//  Created by stephendsw on 16/9/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMenuCell.h"

@interface QTMenuCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation QTMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorHex:@"ff4400"];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setSeparatorInset:UIEdgeInsetsZero];
    self.backgroundColor = [UIColor colorHex:@"990000"];
}

- (void)bind:(NSString *)obj {
    self.lbTitle.text = obj;
}

@end
