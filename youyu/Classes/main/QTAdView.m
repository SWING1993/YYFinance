//
//  QTAdView.m
//  qtyd
//
//  Created by stephendsw on 16/5/4.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTAdView.h"

@interface QTAdView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hConstraint;

@end

@implementation QTAdView

- (void)awakeFromNib {
    if (IPHONE6PLUS) {
        _hConstraint.constant = 120;
    } else if (IPHONE6) {
        _hConstraint.constant = 120;
    } else if (IPHONE5) {
        _hConstraint.constant = 100;
    } else if (IPHONE4) {
        _hConstraint.constant = 80;
    }
}

@end
