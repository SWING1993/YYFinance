//
//  QTVIPAlertView.m
//  qtyd
//
//  Created by stephendsw on 16/6/30.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVIPAlertView.h"

@interface QTVIPAlertView ()

@end

@implementation QTVIPAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    [QTTheme btnRedStyle:self.btnSubmit];
    [QTTheme btnWhiteStyle:self.btnCancel];
    self.lbTitle.textColor=[Theme redColor];
}

@end
