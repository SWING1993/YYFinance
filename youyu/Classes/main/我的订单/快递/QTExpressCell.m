//
//  QTExpressCell.m
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTExpressCell.h"

@interface QTExpressCell ()
@property (weak, nonatomic) IBOutlet UILabel    *lbContent;
@property (weak, nonatomic) IBOutlet UIView     *viewline;
@property (weak, nonatomic) IBOutlet UIView     *viewCircle;

@end

@implementation QTExpressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewline.backgroundColor = [Theme borderColor];
    self.lbContent.preferredMaxLayoutWidth=APP_WIDTH-(320-259);
}

- (void)bind:(NSDictionary *)obj {
    NSString *content = obj.str(@"context");

    NSString *time = obj.str(@"ftime");

    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@", content, time]];

    self.lbContent.attributedText = attstr;

    [self getLine:self.type];
}

- (void)getLine:(ExpressCellType)type {
    if (type == ExpressCellTypeFirst) {
        self.viewCircle.layer.cornerRadius = self.viewCircle.width / 2;
        self.viewCircle.layer.borderWidth = 2;
        self.viewCircle.layer.borderColor = [UIColor colorHex:@"AAE2C2"].CGColor;

        self.viewCircle.backgroundColor = [Theme greenColor];

        self.viewline.transform = CGAffineTransformMakeTranslation(0, 10);
    } else if (type == ExpressCellTypeList) {
        self.viewCircle.layer.cornerRadius = self.viewCircle.width / 2;
        self.viewCircle.layer.borderWidth = 2;
        self.viewCircle.layer.borderColor = [UIColor whiteColor].CGColor;
        self.viewCircle.backgroundColor = [Theme borderColor];

        self.viewline.transform = CGAffineTransformMakeTranslation(0, 0);
    } else if (type == ExpressCellTypeLast) {
        self.viewCircle.layer.cornerRadius = self.viewCircle.width / 2;
        self.viewCircle.layer.borderWidth = 2;
        self.viewCircle.layer.borderColor = [UIColor whiteColor].CGColor;
        self.viewCircle.backgroundColor = [Theme borderColor];

        self.viewline.transform = CGAffineTransformMakeTranslation(0, 0);
    }

    [self.contentView bringSubviewToFront:self.viewCircle];
}

@end
