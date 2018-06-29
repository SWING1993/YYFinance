//
//  QTBankSelectCell.m
//  qtyd
//
//  Created by stephendsw on 15/11/10.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTBankSelectCell.h"
#import "BankModel.h"

@interface QTBankSelectCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel        *lbContent;

@end

@implementation QTBankSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    NSString *imageName=[NSString stringWithFormat:@"icon_%@_bank",obj[@"bank_code"]];
    
    self.image.image = [UIImage imageNamed:imageName];

    self.lbTitle.text = obj[@"bank_name"];

    self.updateTip = [BankModel getTipFormateForCode:obj state:QTbankStateBank_bind | QTbankStateQuick_bind];

    if (self.updateTip) {
        self.lbContent.text = @"升级中";
    } else {
        self.lbContent.text = @"";
    }
    
    
}

@end
