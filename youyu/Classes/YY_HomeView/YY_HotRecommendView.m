//
//  YY_HotRecommendView.m
//  hsd
//
//  Created by LimboDemon on 2017/11/8.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_HotRecommendView.h"

@interface YY_HotRecommendView ()

@property (nonatomic, strong) UIImageView *topIcon;//顶部icon
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *dateLabel;//项目期限
@property (nonatomic, strong) UILabel *balanceLabel;//项目余额
@property (nonatomic, strong) UILabel *investBtn;//立即投资
@property (nonatomic, strong) UIView *circleView;//圆圈
@end


@implementation YY_HotRecommendView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.topIcon];
        [self addSubview:self.titleLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.balanceLabel];
        [self addSubview:self.investBtn];
    }
    return self;
}














-(UIImageView *)topIcon{
    if (!_topIcon) {
        _topIcon = [[UIImageView alloc] init];
        _topIcon.image = [UIImage imageNamed:@"yy_热门推荐"];
    }
    return _topIcon;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
    }
    return _titleLabel;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"项目期限 ";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = RGBA(153, 153, 153, 1);
    }
    return _dateLabel;
}

-(UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.text = @"项目余额 ";
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        _balanceLabel.textColor = RGBA(153, 153, 153, 1);
    }
    return _balanceLabel;
}






















@end
