//
//  QTLogTableHead.m
//  qtyd
//
//  Created by stephendsw on 15/9/23.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTBorrowTenderLogTableHeadView.h"
#import "QTTheme.h"

@interface QTBorrowTenderLogTableHeadView ()

@end

@implementation QTBorrowTenderLogTableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBottomLine:Theme.backgroundColor];
}

@end
