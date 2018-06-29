//
//  QTMessageCell.m
//  qtyd
//
//  Created by stephendsw on 2016/11/14.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMessageCell.h"

@interface QTMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel    *lbContent;
@property (weak, nonatomic) IBOutlet UILabel    *lbTime;

@end

@implementation QTMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.lbTime.backgroundColor = [UIColor whiteColor];
    self.lbContent.backgroundColor = [UIColor whiteColor];
    self.lbContent.preferredMaxLayoutWidth=APP_WIDTH-16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.editing) {
        [super setSelected:selected animated:animated];
    }

    self.selectedBackgroundView.alpha = 0;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

- (void)bind:(NSDictionary *)dic {
    NSString    *title = dic.str(@"title");
    NSString    *content = dic.str(@"content");

    NSMutableAttributedString *attributes = [NSMutableAttributedString new];

    NSString *str = [NSString stringWithFormat:@"%@\n%@\n", title, content];

    [attributes appendAttributedString:[[NSAttributedString alloc] initWithString:str]];

    if (dic.i(@"read_state") == 1) {
        [attributes setFont:[UIFont systemFontOfSize:15] string:title];
        [attributes setColor:[UIColor darkGrayColor] string:title];
    } else {
        [attributes setFont:[UIFont boldSystemFontOfSize:15] string:title];
        [attributes setColor:[UIColor blackColor] string:title];
    }

    //
    [attributes setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 2;  // 行自定义行高度
        Paragraph.paragraphSpacing = 3;
    }];

    self.lbContent.attributedText = attributes;

    if (self.shortContent) {
        self.lbContent.lineBreakMode = NSLineBreakByTruncatingTail;
    } else {
        self.lbContent.lineBreakMode = NSLineBreakByWordWrapping;
    }

    self.lbTime.text = dic.str(@"sendtime").timeValue;
}

@end
