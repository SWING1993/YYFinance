//
//  YYInvestListTopView.m
//  hsd
//
//  Created by LimboDemon on 2017/11/14.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YYInvestListTopView.h"

@interface YYInvestListTopView ()
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rateLabel;//预期年化(数字)
@property (nonatomic, strong) UILabel *rateL;//预期年化(文字)
@property (nonatomic, strong) UILabel *dataLabel;//项目周期(数字)
@property (nonatomic, strong) UILabel *dataL;//项目周期(文字)

@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIView  *bgLineView;

//@property (nonatomic, strong) UIButton *investBtn;//投资按钮

@end

@implementation YYInvestListTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.bgImg];
        [self.bgImg addSubview:self.titleLabel];
        [self.bgImg addSubview:self.rateL];
        [self.bgImg addSubview:self.rateLabel];
        [self.bgImg addSubview:self.dataL];
        [self.bgImg addSubview:self.dataLabel];
        [self.bgImg addSubview:self.bgLineView];
        [self.bgImg addSubview:self.lineView];
//        [self addSubview:self.investBtn];
        [self autoLayout];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setModel:(HSDInvestmentModel *)model{
    if ([model.borrow_name containsString:@"】"] && [model.borrow_name containsString:@"【"]) {
        self.titleLabel.text = [model.borrow_name firstBorrowNameNoFormat];
    }else{
        self.titleLabel.text = model.borrow_name;
    }
    
    self.dataLabel.text = [NSString stringWithFormat:@"%@%@",model.loan_period[@"num"],model.loan_period[@"unit"]];
    self.rateLabel.text = model.apr.add(@"%");
    CGFloat percent = model.invent_percent/100.0;
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.lineView.width*percent);
    }];
    [self layoutIfNeeded];
}

- (void)autoLayout{
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(RSS(10));
        make.left.right.mas_equalTo(RSS(10));
        make.height.mas_equalTo(RSS(182));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImg).mas_offset(RSS(15));
        make.centerX.mas_equalTo(_bgImg);
        make.width.mas_lessThanOrEqualTo(RSS(210));
    }];
    
    [_rateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bgImg);
        make.left.mas_equalTo(RSS(80));
    }];
    
    [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_rateL);
        make.bottom.mas_equalTo(_rateL.mas_top).mas_offset(-RSS(2));
    }];
    
    [_dataL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bgImg);
        make.right.mas_equalTo(-RSS(80));
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_dataL);
        make.bottom.mas_equalTo(_dataL.mas_top).mas_offset(-RSS(4));
    }];
    
    [_bgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(RSS(12));
        make.left.mas_equalTo(_bgImg).mas_offset(RSS(40));
        make.right.mas_equalTo(_bgImg).mas_offset(-RSS(40));
        make.top.mas_equalTo(_dataL.mas_bottom).mas_offset(RSS(18));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(RSS(12));
        make.left.mas_equalTo(_bgImg).mas_offset(RSS(40));
        make.top.mas_equalTo(_dataL.mas_bottom).mas_offset(RSS(18));
    }];
    
//    [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_bgImg.mas_bottom).mas_offset(-RSS(20));
//        make.centerX.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(RSS(175), RSS(32)));
//    }];
    
}

-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [UIImageView new];
        _bgImg.image = IMG(@"InvestListTop");
        _bgImg.userInteractionEnabled = YES;
        _bgImg.layer.shadowColor = SecondaryTitleColor.CGColor;
        _bgImg.layer.shadowOpacity = 0.8;
        _bgImg.layer.shadowRadius = RSS(15);
        _bgImg.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _bgImg;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT(16);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UILabel *)rateLabel{
    if (!_rateLabel) {
        _rateLabel = [UILabel new];
        _rateLabel.backgroundColor = [UIColor clearColor];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
        _rateLabel.font = FONT(30);
        _rateLabel.textColor = RGBA(255, 225, 119, 1);
        
    }
    return _rateLabel;
}

-(UILabel *)rateL{
    if (!_rateL) {
        _rateL = [UILabel new];
        _rateL.backgroundColor = [UIColor clearColor];
        _rateL.text = @"预期年化";
        _rateL.textColor = [UIColor whiteColor];
        _rateL.font = FONT(12);
    }
    return _rateL;
}

-(UILabel *)dataLabel{
    if (!_dataLabel) {
        _dataLabel = [UILabel new];
        _dataLabel.backgroundColor = [UIColor clearColor];
        _dataLabel.textAlignment = NSTextAlignmentCenter;
        _dataLabel.font = FONT(30);
        _dataLabel.textColor = RGBA(255, 225, 119, 1);
        
    }
    return _dataLabel;
}

-(UILabel *)dataL{
    if (!_dataL) {
        _dataL = [UILabel new];
        _dataL.backgroundColor = [UIColor clearColor];
        _dataL.text = @"项目周期";
        _dataL.textColor = [UIColor whiteColor];
        _dataL.font = FONT(12);
    }
    return _dataL;
}

-(UIView *)bgLineView{
    if (!_bgLineView) {
        _bgLineView = [UIView new];
        _bgLineView.backgroundColor = RGBA(251, 181, 184, 1);
        _bgLineView.layer.cornerRadius = RSS(6);
        _bgLineView.layer.masksToBounds = YES;
    }
    return _bgLineView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGBA(255, 177, 61, 1);
        _lineView.layer.cornerRadius = RSS(6);
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

//-(UIButton *)investBtn{
//    if (!_investBtn) {
//        _investBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_investBtn setImage:IMG(@"invest_btn_bid") forState:UIControlStateNormal];
//        _investBtn.userInteractionEnabled = NO;
//    }
//    return _investBtn;
//}

























@end
