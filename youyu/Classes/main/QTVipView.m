//
//  QTVipView.m
//  qtyd
//
//  Created by stephendsw on 16/3/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVipView.h"

@interface QTVipView ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cHeight;

@end

@implementation QTVipView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setText:(NSString *)text img:(NSString *)imageName {
    self.lbName.text = text;
    self.lbImage.image = [UIImage imageNamed:imageName];
}

- (void)setText:(NSString *)text {
    self.lbName.text = text;
}

- (NSString *)text {
    return self.lbName.text;
}

- (void)setDisable {
    self.lbImage.image = [self.lbImage.image imageWithColor:[Theme grayColor]];
}

- (void)setRadioWidth:(CGFloat)radioWidth {
    self.cWidth.constant = radioWidth;
    self.cHeight.constant = radioWidth;
}

@end
