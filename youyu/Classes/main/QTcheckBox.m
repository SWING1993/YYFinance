//
//  QTcheckBox.m
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTcheckBox.h"

@interface QTcheckBox ()

@end

@implementation QTcheckBox

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setImage:[UIImage imageNamed:@"icon_comment_y"] forState:UIControlStateSelected];

    [self setImage:[UIImage imageNamed:@"icon_comment_n"] forState:UIControlStateNormal];

    [self clickOn:^(id value) {} off:^(id value) {}];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];

    [self sizeToFit];
    _title=title;
}

@end
