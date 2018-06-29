//
//  QTSelectedBtn.m
//  qtyd
//
//  Created by stephendsw on 16/4/14.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSelectedBtn.h"

@interface QTSelectedBtn ()

@end

@implementation QTSelectedBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    [self unselectCss];

    [self setTitleColor:[Theme darkOrangeColor] forState:UIControlStateSelected];
    [self setTitleColor:[Theme borderColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        [self selectCSS];
    } else {
        [self unselectCss];
    }
}

- (void)selectCSS {
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [Theme darkOrangeColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)unselectCss {
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [Theme borderColor].CGColor;
    self.layer.borderWidth = 1;
}

@end
