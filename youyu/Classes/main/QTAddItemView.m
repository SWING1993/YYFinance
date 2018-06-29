//
//  QTAddItemView.m
//  qtyd
//
//  Created by stephendsw on 16/4/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTAddItemView.h"

@interface QTAddItemView ()
@property (weak, nonatomic) IBOutlet UILabel    *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton   *btn;
@property (weak, nonatomic) IBOutlet UIView     *backView;

@end

@implementation QTAddItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showBackgroundColorHighlighted = YES;

    CGFloat         viewWidth = APP_WIDTH - 80;
    CGFloat         viewHeight = 60;
    CAShapeLayer    *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:10].CGPath;
    borderLayer.lineWidth = 4. / [[UIScreen mainScreen] scale];
    borderLayer.lineDashPattern = @[@8, @4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [Theme lightGrayColor].CGColor;
    [self.backView.layer addSublayer:borderLayer];
    self.backView.cornerRadius = 10;
    self.backView.clipsToBounds = YES;

    self.backgroundColor = [Theme backgroundColor];
    self.lbTitle.textColor = [Theme redColor];
}

- (void)willTouch {
    [self.btn setImage:[UIImage imageNamed:@"icon_add_circle_gray"] forState:UIControlStateNormal];
}

- (void)didTouch {
    [self.btn setImage:[UIImage imageNamed:@"icon_add_circle"] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    self.lbTitle.text = title;
}

- (NSString *)title {
    return self.lbTitle.text;
}

@end
