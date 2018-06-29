//
//  QTHomeCardView.m
//  qtyd
//
//  Created by stephendsw on 2017/1/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "QTHomeCardView.h"

@interface QTHomeCardView ()


@end

@implementation QTHomeCardView

- (void)setText:(NSString *)text img:(NSString *)imageName {
    self.lbTitle.text = text;
    self.image.image = [UIImage imageNamed:imageName];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.lbTitle];
        [self addSubview:self.image];
        [self layout];
    }
    return self;
}

- (void)layout{
    
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-22);
    }];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_lbTitle.mas_centerY);
        make.left.mas_equalTo(_lbTitle.mas_right).mas_offset(10);
    }];
    
    [self layoutIfNeeded];
}


-(UILabel *)lbTitle{
    if (!_lbTitle) {
        _lbTitle = [UILabel new];
        _lbTitle.font = FONT(15);
        _lbTitle.textColor = SecondaryTitleColor;
    }
    return _lbTitle;
}

-(UIImageView *)image{
    if (!_image) {
        _image = [UIImageView new];
    }
    return _image;
}





//+(QTHomeCardView *)nibXib{
//    return [[NSBundle mainBundle] loadNibNamed:@"QTHomeCardView" owner:nil options:nil].firstObject;
//
//
//}

@end
