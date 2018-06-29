//
//  QTAboutCell.m
//  qtyd
//
//  Created by stephendsw on 15/10/29.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTAboutCell.h"


@interface QTAboutCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel        *lbContent;

@end

@implementation QTAboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    self.image.image = [UIImage imageNamed:obj[@"image"]];

    self.lbTitle.text = obj[@"title"];

    if ([obj[@"content"] isKindOfClass:[NSAttributedString class]]) {
        self.lbContent.attributedText = obj[@"content"];
    } else {
        self.lbContent.text = obj[@"content"];
    }
}

@end
