//
//  QTRepaymentScheduleCell.m
//  qtyd
//
//  Created by stephendsw on 16/5/9.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRepaymentScheduleCell.h"
#import "NSString+model.h"

@interface QTRepaymentScheduleCell ()
@property (weak, nonatomic) IBOutlet UILabel    *lbtitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbNum;
@property (weak, nonatomic) IBOutlet UILabel    *lbState;

@property (weak, nonatomic) IBOutlet UILabel *lbMoney;

@end

@implementation QTRepaymentScheduleCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    self.lbtitle.text = [obj.str(@"borrow_name") firstBorrowName];
    self.lbNum.text = [NSString stringWithFormat:@"%@/%@期", obj.str(@"current_stage"), obj.str(@"total_stage")];

    NSString *money = [[NSString stringWithFormat:@"%f", obj.fl(@"capital") + obj.fl(@"interest")] moneyFormatShow];

    self.lbMoney.text = [NSString stringWithFormat:@"本息总额(元) %@", money];

    if (obj.i(@"pay_status") == 0) {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@""];
        UIImage *image = [[UIImage imageNamed:@"icon_unfinished"]  imageWithColor:[Theme grayColor]];
        [attstr appendImage:image];
        
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 待还款"]];
        
        self.lbState.attributedText = attstr;
    } else {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@""];
        UIImage *image = [[UIImage imageNamed:@"icon_complete"]  imageWithColor:[Theme greenColor]];
        [attstr appendImage:image];

        
        [attstr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 已回款"]];
        
        self.lbState.attributedText = attstr;
    }
}

@end
