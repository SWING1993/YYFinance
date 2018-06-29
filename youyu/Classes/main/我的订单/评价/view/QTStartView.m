//
//  QTStartView.m
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTStartView.h"

@interface QTStartView ()
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView    *image;

@end

@implementation QTStartView

- (void)setTitle:(NSString *)title {
    self.lbTitle.text = title;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        [self.image setImage:[UIImage imageNamed:@"icon_comment_y"]];
        self.lbTitle.textColor = [Theme darkOrangeColor];
    } else {
        [self.image setImage:[UIImage imageNamed:@"icon_comment_n"]];
        self.lbTitle.textColor = [Theme darkGrayColor];
    }
}

@end
