//
//  YYInvestListNormalView.m
//  hsd
//
//  Created by LimboDemon on 2017/11/14.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YYInvestListNormalView.h"
#import "ZZCircleProgress.h"

@interface YYInvestListNormalView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *rateLabel;//预期年化(数字)
@property (nonatomic, strong) UILabel *rateL;//预期年化(文字)
@property (nonatomic, strong) UILabel *dataLabel;//项目周期(数字)
@property (nonatomic, strong) UILabel *dataL;//项目周期(文字)
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) ZZCircleProgress *circle;

@end

@implementation YYInvestListNormalView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super  initWithFrame:frame]) {

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.layer.cornerRadius = RSS(5);
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView addSubview:self.titleLabel];
        [bgView addSubview:self.rateL];
        [bgView addSubview:self.rateLabel];
        [bgView addSubview:self.dataL];
        [bgView addSubview:self.dataLabel];
        [bgView addSubview:self.line];
        [bgView addSubview:self.iconLabel];
        [bgView addSubview:self.circle];// 这个需要在初始话的时候设置frame，这里直接用frame做适配
        [self autoLayout];
        self.layer.shadowColor = LightGrayColor.CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = RSS(5);
        self.layer.shadowOffset = CGSizeMake(0, 0);

        
    }
    return self;
}

-(void)setModel:(HSDInvestmentModel *)model{
    if (model) {
        self.titleLabel.text = model.borrow_name;
        if (model.loan_period) {
            self.dataLabel.text = [NSString stringWithFormat:@"%@%@",model.loan_period[@"num"],model.loan_period[@"unit"]];
        }else{
            self.dataLabel.text = [NSString stringWithFormat:@"%@天",model.borrow_rest_time];
        }
        
        self.rateLabel.text = model.apr.add(@"%");
        self.circle.progress =  model.invent_percent/100.0;
        if ([model.sign length] > 0 && ![model.sign isEqualToString:@"null"]) {
            self.iconLabel.hidden = NO;
            self.iconLabel.text = [NSString stringWithFormat:@" %@   ",model.sign];
        }else
            self.iconLabel.hidden = YES;

//        [self layoutIfNeeded];
    }
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RSS(18));
        make.left.mas_equalTo(RSS(20));
        make.width.mas_lessThanOrEqualTo(APP_WIDTH - RSS(70));
    }];
    
    [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).mas_offset(RSS(10));
        make.centerY.mas_equalTo(_titleLabel);
        make.width.mas_greaterThanOrEqualTo(RSS(50));
        make.height.mas_equalTo(RSS(18));
    }];
    
    [_rateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RSS(33));
        make.bottom.mas_equalTo(self).mas_offset(-RSS(15));
    }];
    
    [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_rateL);
        make.bottom.mas_equalTo(_rateL.mas_top).mas_offset(-RSS(13));
        
    }];
    
    [_dataL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_rateL.mas_right).mas_offset(RSS(50));
        make.centerY.mas_equalTo(_rateL);
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_dataL);
        make.bottom.mas_equalTo(_dataL.mas_top).mas_offset(-RSS(13));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(RSS(220));
        make.width.mas_equalTo(RSS(1));
        make.top.mas_equalTo(RSS(27));
        make.bottom.mas_equalTo(-RSS(27));
    }];
    
//    [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(_line.mas_left).mas_offset(-RSS(20));
//        make.centerY.mas_equalTo(_titleLabel);
//        make.width.mas_greaterThanOrEqualTo(RSS(50));
//        make.height.mas_equalTo(RSS(18));
//    }];
    
    [self layoutIfNeeded];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = SecondaryTitleColor;
        _titleLabel.font = FONT(14);
        
    }
    return _titleLabel;
}

-(UILabel *)iconLabel{
    if (!_iconLabel) {
        _iconLabel = [UILabel new];
        _iconLabel.backgroundColor = RGBA(102, 240, 162, 1);
        _iconLabel.textColor = [UIColor whiteColor];
        _iconLabel.font = FONT(12);
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        _iconLabel.layer.cornerRadius = RSS(9);
        _iconLabel.layer.masksToBounds = YES;
    }
    return _iconLabel;
}

-(UILabel *)rateL{
    if (!_rateL) {
        _rateL = [UILabel new];
        _rateL.textColor = LightGrayColor;
        _rateL.text = @"预期年化";
        _rateL.font = FONT(12);
    }
    return _rateL;
}

-(UILabel *)rateLabel{
    if (!_rateLabel) {
        _rateLabel = [UILabel new];
        _rateLabel.textColor = MainColor;
        _rateLabel.font = [UIFont boldSystemFontOfSize:21];
    }
    return _rateLabel;
}

-(UILabel *)dataL{
    if (!_dataL) {
        _dataL = [UILabel new];
        _dataL.textColor = LightGrayColor;
        _dataL.text = @"项目周期";
        _dataL.font = FONT(12);
    }
    return _dataL;
}

-(UILabel *)dataLabel{
    if (!_dataLabel) {
        _dataLabel = [UILabel new];
        _dataLabel.textColor = MainTitleColor;
        _dataLabel.font = FONT(14);
    }
    return _dataLabel;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [Theme backgroundColor];
        _line.hidden = YES;
    }
    return _line;
}

-(ZZCircleProgress *)circle{
    if (!_circle) {
        _circle = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(APP_WIDTH - RSS(130), RSS(45), RSS(70), RSS(70)) pathBackColor:nil pathFillColor:MainColor startAngle:0 strokeWidth:RSS(6)];
        _circle.showPoint = NO;
        _circle.pathFillColor = MainColor;
        _circle.pathBackColor = RGBA(251, 181, 184, 1);
        _circle.animationModel = CircleIncreaseSameTime;
    }
    return _circle;
}







@end
