//
//  QTActivityCell.m
//  qtyd
//
//  Created by stephendsw on 16/8/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTActivityCell.h"
#import "UIImageView+WebCache.h"

@interface QTActivityCell ()

@property (weak, nonatomic) IBOutlet UILabel    *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbDay;

@property (weak, nonatomic) IBOutlet UILabel        *lbState;
@property (weak, nonatomic) IBOutlet UIImageView    *img;
@property (weak, nonatomic) IBOutlet UIView         *lineView;
@property (weak, nonatomic) IBOutlet UIView         *shadowView;

@end

@implementation QTActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.img.clipsToBounds = YES;
    self.lineView.backgroundColor = [UIColor colorHex:@"f5f5f5"];

    self.layer.shadowPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, APP_WIDTH, 5)].CGPath;
    // 阴影的颜色
    self.shadowView.layer.shadowColor = [[UIColor colorWithWhite:0.5 alpha:0.3] CGColor];
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 4);
    // 阴影透明度
    self.shadowView.layer.shadowOpacity = 3;
    // 阴影圆角度数
    self.shadowView.layer.shadowRadius = 2;
}

- (void)bind:(NSDictionary *)obj {
    [self.lbState setRotation:-M_PI_4];

    [self.img clearSubviews];

    [self.img setImageWithURLString:obj.str(@"app_image") placeholderImageString:@"mall_default"];
    self.lbTitle.text = obj.str(@"title");
    NSInteger now = [NSDate date].timeIntervalSince1970;

    NSString    *sday = [NSString stringWithFormat:@"%@月%@日", obj.str(@"start_time").monthValue, obj.str(@"start_time").dayValue];
    NSString    *eday = [NSString stringWithFormat:@"%@月%@日", obj.str(@"end_time").monthValue, obj.str(@"end_time").dayValue];

    // 已结束
    if (now > obj.i(@"end_time")) {
        self.lbState.text = @"已结束";
        self.lbDay.text = obj.str(@"");
        self.lbState.backgroundColor = [Theme grayColor];

        UIView *maskview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_WIDTH / 328.0 * 164.0)];
        maskview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        self.contentView.backgroundColor = [UIColor colorWithWhite:230.0 / 255.0 alpha:1];
        self.shadowView.backgroundColor = [UIColor colorWithWhite:230.0 / 255.0 alpha:1];
        [self.img addSubview:maskview];
    }
    // 未开始
    else if (now < obj.i(@"start_time")) {
        self.lbState.text = @"未开始";
        self.lbDay.text = [NSString stringWithFormat:@"%@-%@", sday, eday];
        self.lbState.backgroundColor = [Theme grayColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.shadowView.backgroundColor = [UIColor whiteColor];
    }
    // 进行中
    else {
        self.lbState.text = @"进行中";
        self.lbDay.text = [NSString stringWithFormat:@"%@-%@", sday, eday];
        self.lbState.backgroundColor = [Theme darkOrangeColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.shadowView.backgroundColor = [UIColor whiteColor];
    }
}

@end
