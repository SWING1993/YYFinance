//
//  QTNewGiftCell.m
//  qtyd
//
//  Created by stephendsw on 15/9/18.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTNewGiftCell.h"
#import "QTTheme.h"
#import "UIViewController+menu.h"
#import "QTBaseViewController.h"
#import "UIViewController+toast.h"
#import "QTAlertWeiXinView.h"

@interface QTNewGiftCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel    *lbSubTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbCondition;
@property (weak, nonatomic) IBOutlet UIButton   *btn;
@property (weak, nonatomic) IBOutlet UIView     *lineView;

@end

@implementation QTNewGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lbCondition.textColor = [UIColor lightGrayColor];

    self.lbTitle.textColor = Theme.redColor;

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];

    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
    [NSNumber numberWithInt:1], nil]];

    int height = 0;

    if (IPHONE6 || IPHONE6PLUS) {
        height = 100;
    } else {
        height = 80;
    }

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 50, height);
    CGPathAddLineToPoint(path, NULL, APP_WIDTH, height);

    [shapeLayer setPath:path];
    CGPathRelease(path);

    [self.contentView.layer addSublayer:shapeLayer];

    self.contentView.clipsToBounds = YES;

    self.lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];

    self.image.backgroundColor = [UIColor whiteColor];
}

- (void)bind:(NSDictionary *)obj IndexPath:(NSIndexPath *)indexPath  {
    //    obj[@"title"] = @"小试牛刀";
    //    obj[@"subtitle"] = @"完成任务:奖励10元红包券";
    //    obj[@"condition"] = @"通关秘籍:成功完成首次投资";
    //    obj[@"name"] = @"立即投资";
    //    obj[@"state"] = @(0);

    [self.btn click:^(id value) {
        if ((indexPath.row == 0)) {
            [self.viewController toInvest];
        } else if ((indexPath.row == 1)) {
            [self.viewController toSignIn];
        }
    }];

    self.lbTitle.text = obj[@"title"];

    self.lbSubTitle.text = obj[@"subtitle"];

    self.lbCondition.text = obj[@"condition"];

    BOOL state = obj.i(@"state");

    if (state) {
        self.image.image = [[UIImage imageNamed:@"icon_task_gift"] imageWithColor:[UIColor colorHex:@"#5eb95e"]];
        [self.btn setTitle:@"已完成" forState:UIControlStateNormal];
        [QTTheme btnGrayStyle:self.btn];
        self.lbTitle.textColor = Theme.greenColor;
    } else {
        self.image.image = [[UIImage imageNamed:@"icon_task_gift"] imageWithColor:[Theme grayColor]];
        [self.btn setTitle:obj[@"name"] forState:UIControlStateNormal];
        [QTTheme btnRedStyle:self.btn];
    }

    self.btn.titleLabel.font = [UIFont systemFontOfSize:12];
}

@end
