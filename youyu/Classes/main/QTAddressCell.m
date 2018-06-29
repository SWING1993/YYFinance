//
//  QTAddressCell.m
//  qtyd
//
//  Created by yl on 15/10/8.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTAddressCell.h"
#import "NSString+model.h"

@interface QTAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbDefault;

@end

@implementation QTAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[Theme greenColor] title:@"修改"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[Theme redColor] title:@"删除"];

    self.rightUtilityButtons = rightUtilityButtons;
    
    self.lbDefault.preferredMaxLayoutWidth=APP_WIDTH-20-20;
}

- (void)bind:(NSDictionary *)dic {
    NSString    *name = dic[@"user_name"];
    NSString    *phone = [dic.str(@"user_mobile") phoneFormat];

    NSString *address = [dic.str(@"area_name") stringByReplacingOccurrencesOfString:@"_" withString:@" "].add(@" ").add(dic[@"user_address"]);

    NSString                    *showText;
    NSMutableAttributedString   *attStr;

    if ([dic.str(@"address_default") isEqualToString:@"1"]) {
        showText = [NSString stringWithFormat:@"%@ %@\n默认 %@", name, phone, address];

        attStr = [[NSMutableAttributedString alloc]initWithString:showText];

        [attStr setColor:[UIColor colorHex:@"33AA33"] string:@"默认"];
    } else {
        showText = [NSString stringWithFormat:@"%@ %@\n%@", name, phone, address];
        attStr = [[NSMutableAttributedString alloc]initWithString:showText];
    }

    [attStr setColor:[UIColor colorHex:@"333333"] string:name];
    [attStr setColor:[UIColor colorHex:@"999999"] string:phone];
    [attStr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 5;
    }];
    self.lbDefault.attributedText = attStr;
}

@end
