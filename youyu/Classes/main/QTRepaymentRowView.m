//
//  QTRepaymentRowView.m
//  qtyd
//
//  Created by stephendsw on 16/5/10.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRepaymentRowView.h"

@interface QTRepaymentRowView ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbNum;

@property (weak, nonatomic) IBOutlet UILabel *lbMoney;

@end

@implementation QTRepaymentRowView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.width=APP_WIDTH;
    [self setBottomLine:[Theme borderColor]];
    
}

- (void)bindName:(NSString *)name num:(NSString *)num money:(NSString *)money {
    self.lbName.text = name;
    self.lbNum.text = num;
    self.lbMoney.text = money;
}

@end
