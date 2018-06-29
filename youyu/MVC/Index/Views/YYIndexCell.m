//
//  YYIndexCell.m
//  youyu
//
//  Created by 宋国华 on 2018/6/20.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYIndexCell.h"

@interface YYIndexCell()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *aprLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) QMUIButton *btn;

@end

@implementation YYIndexCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.qmui_shouldShowDebugColor = YES;
        //        self.qmui_needsDifferentDebugColor = YES;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = kColorWhite;
        
        self.topLabel = [[UILabel alloc] initWithFont:UIFontBoldMake(14) textColor:kColorTextBlack];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScaleFrom_iPhone6_Desgin(20));
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        self.aprLabel = [[UILabel alloc] initWithFont:UIFontMake(40) textColor:kColorRed];
        self.aprLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.aprLabel];
        [self.aprLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.tagLabel = [[UILabel alloc] initWithFont:UIFontMake(12) textColor:UIColorMake(180, 180, 180)];
        self.tagLabel.text = @"预期年化";
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.tagLabel];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_centerY);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        self.btn = [[QMUIButton alloc] init];
        self.btn.backgroundColor = UIColorMake(255, 90, 0);
        YYViewBorderRadius(self.btn, 20, CGFLOAT_MIN, kColorClear);
        self.btn.titleLabel.font = UIFontMake(14);
        [self.btn setTitle:@"我要投资" forState:UIControlStateNormal];
        [self.btn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [self.contentView addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 40));
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(-kScaleFrom_iPhone6_Desgin(25));
        }];
        
        @weakify(self)
        [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.delegateSignal) {
                // 有值，才需要通知
                [self.delegateSignal sendNext:self.model];
            }
        }];
    }
    return self;
}

+ (CGFloat)rowHeight {
    return kScaleFrom_iPhone6_Desgin(177);
}

+ (NSString *)cellIdentifier {
    return @"YYIndexCellIdentifier";
}

- (void)configCellWithModel:(YYBorrowModel *)model {
    self.model = model;
    self.topLabel.text = [NSString stringWithFormat:@"%@  期限%@%@",model.borrow_name,model.loan_period[@"num"],model.loan_period[@"unit"]];
    self.aprLabel.text = [NSString stringWithFormat:@"%@%%",model.apr];
}

@end
