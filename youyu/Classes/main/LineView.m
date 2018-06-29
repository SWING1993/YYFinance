//
//  LineView.m
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "LineView.h"
#import "NSString+model.h"
#import "NSString+quick.h"
#import "UIView+layout.h"
#import "QTTheme.h"

@interface LineView ()
@property (weak, nonatomic) IBOutlet UILabel    *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbMoney;
@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end

@implementation LineView


-(void)setTip:(NSString *)tip
{
    self.lbTip.text=tip;
    self.lbTip.hidden=NO;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setBottomLine:Theme.borderColor];
    self.lbTip.layer.borderColor= [Theme darkOrangeColor].CGColor;
    self.lbTip.textColor= [Theme darkOrangeColor];
    self.lbTip.layer.borderWidth=1;
    self.lbTip.layer.cornerRadius=5;
    self.lbTip.hidden=YES;
}
- (void)setText:(NSString *)text money:(NSString *)money {
    self.lbTitle.text = text;
    self.lbMoney.text = [money  moneyFormatShow];
    
}

@end
