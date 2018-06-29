//
//  QTVipTipView.m
//  qtyd
//
//  Created by stephendsw on 16/6/23.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVipTipView.h"
#import "UIViewController+page.h"
#import "QTVipHomeViewController.h"

@interface QTVipTipView ()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation QTVipTipView

- (void)awakeFromNib {
    [super awakeFromNib];
    [QTTheme btnRedStyle:self.btn];
    [self.btn click:^(id value) {
        [[AppDelegate presentingVC] toVipHome];
    }];
}

@end
