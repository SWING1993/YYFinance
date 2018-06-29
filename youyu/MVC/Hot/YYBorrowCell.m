//
//  YYBorrowCell.m
//  youyu
//
//  Created by 宋国华 on 2018/6/13.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYBorrowCell.h"
#import "M13ProgressViewBar.h"

@interface YYBorrowCell()

@property (nonatomic, strong) UILabel *borrowNameLabel;
@property (nonatomic, strong) UILabel *aprLabel;
@property (nonatomic, strong) UILabel *loanPeriodLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) M13ProgressViewBar *progressView;


@end

@implementation YYBorrowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.qmui_shouldShowDebugColor = YES;
//        self.qmui_needsDifferentDebugColor = YES;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = kColorWhite;
        
        self.borrowNameLabel = [[UILabel alloc] initWithFont:UIFontLightMake(15) textColor:kColorTextBlack];
        [self.contentView addSubview:self.borrowNameLabel];
        [self.borrowNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(35));
            make.width.mas_equalTo(kScreenW/2);
        }];
        
        self.bottomLabel = [[UILabel alloc] initWithFont:UIFontMake(11) textColor:kColorTextGray];
        self.bottomLabel.text = @"预期年化";
        [self.contentView addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(25));
            make.width.mas_equalTo(80);
        }];
        
        self.aprLabel = [[UILabel alloc] initWithFont:UIFontMake(30 ) textColor:kColorRed];
        [self.contentView addSubview:self.aprLabel];
        [self.aprLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.borrowNameLabel.mas_bottom);
            make.bottom.mas_equalTo(self.bottomLabel.mas_top);
            make.left.mas_equalTo(self.borrowNameLabel);
            make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-30);
        }];
        
        self.loanPeriodLabel = [[UILabel alloc] initWithFont:UIFontLightMake(15) textColor:kColorTextGray];
        [self.contentView addSubview:self.loanPeriodLabel];
        [self.loanPeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.aprLabel);
            make.left.mas_equalTo(self.contentView.mas_centerX);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        self.progressView = [[M13ProgressViewBar alloc] initWithFrame:CGRectMake(0,0, 150, 15)];
        self.progressView.showPercentage = YES;
        self.progressView.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
        self.progressView.percentagePosition = M13ProgressViewBarPercentagePositionRight;
        self.progressView.progressBarCornerRadius = 0.0;
        [self.contentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 15));
            make.left.mas_equalTo(self.loanPeriodLabel);
            make.centerY.mas_equalTo(self.bottomLabel);
        }];
        
    }
    
    return self;
}

+ (CGFloat)rowHeight {
    return kScaleFrom_iPhone6_Desgin(114);
}

+ (NSString *)cellIdentifier {
    return @"YYBorrowCellIdentifier";
}

- (void)configCellWithModel:(YYBorrowModel *)model {
    self.borrowNameLabel.text = model.borrow_name;
    self.aprLabel.text = [NSString stringWithFormat:@"%@%%",model.apr];
    self.loanPeriodLabel.text = [NSString stringWithFormat:@"投资期限%@%@",model.loan_period[@"num"],model.loan_period[@"unit"]];
    [self.progressView setProgress:model.invent_percent/100.0f animated:YES];
    
    if (model.real_state == 2) {
        self.aprLabel.textColor = kColorRed;
        self.tagLabel.textColor = kColorRed;
        self.bottomLabel.textColor = kColorTextGray;
        self.borrowNameLabel.textColor = kColorTextGray;
        self.loanPeriodLabel.textColor = kColorTextBlack;
        self.progressView.primaryColor = UIColorMake(255, 90, 0);
    } else {
        UIColor *textColor = UIColorMake(153, 153, 153);
        self.aprLabel.textColor = textColor;
        self.tagLabel.textColor = textColor;
        self.bottomLabel.textColor = textColor;
        self.borrowNameLabel.textColor = textColor;
        self.loanPeriodLabel.textColor = textColor;
        self.progressView.primaryColor = textColor;
    }
}

@end
