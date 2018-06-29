//
//  QTUser_rewardinfoCell.m
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTUserRewardinfoCell.h"
#import "QTTheme.h"
#import "NSString+model.h"

@interface QTUserRewardinfoCell ()


@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UILabel *lbtime;
@property (nonatomic, strong) UILabel *lbmoney;
@property (nonatomic, strong) UILabel *lbstate;

@end

@implementation QTUserRewardinfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.qmui_shouldShowDebugColor = YES;
//        self.qmui_needsDifferentDebugColor = YES;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = kColorWhite;
       
        self.lbtime = [[UILabel alloc] initWithFont:UIFontMake(13) textColor:kColorRed];
        [self.contentView addSubview:self.lbtime];
        [self.lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(150);
        }];
        
        self.lbstate = [[UILabel alloc] initWithFont:UIFontLightMake(13) textColor:kColorTextGray];
        self.lbstate.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.lbstate];
        [self.lbstate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(150);
        }];
        
        self.title = [[UILabel alloc] initWithFont:UIFontLightMake(13) textColor:kColorTextBlack];
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.lbtime.mas_top);
            make.left.mas_equalTo(self.lbtime);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(150);
        }];

        self.lbmoney = [[UILabel alloc] initWithFont:UIFontLightMake(13) textColor:kColorTextGray];
        self.lbmoney.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.lbmoney];
        [self.lbmoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.lbtime.mas_top);
            make.right.mas_equalTo(self.lbstate);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(150);
        }];
        
        self.subtitle = [[UILabel alloc] initWithFont:UIFontMake(13) textColor:kColorTextGray];
        [self.contentView addSubview:self.subtitle];
        [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lbtime.mas_bottom);
            make.left.mas_equalTo(self.lbtime);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.lbstate);
        }];
        
    }
    return self;
}

+ (NSString *)cellIdentifier {
    return @"QTUserRewardinfoCellIdentifier";
}

- (void)bind:(NSDictionary *)obj {
    self.title.text = obj.str(@"reward_name");
    self.lbmoney.text = [obj.str(@"money") moneyFormatShow];
    self.lbtime.text = [@"有效期至: " stringByAppendingString:obj.str(@"timeout").dateValue];

    NSString *is_use = obj.str(@"is_use");
    NSDate *timeout = [NSDate dateWithTimeIntervalSince1970:[obj[@"timeout"] integerValue]];
    NSTimeInterval offtime = [[NSDate systemDate] timeIntervalSinceDate:timeout];

    if ([is_use isEqualToString:@"0"] && ([[obj[@"timeout"] stringValue] isEqualToString:@"0"] || (offtime <= 0))) {
        self.lbstate.text = @"未使用";
    } else if ([is_use isEqualToString:@"0"] && (offtime > 0)) {
        self.lbstate.text = @"已过期";
        self.lbtime.text = [@"过期时间: "stringByAppendingString:[obj.str(@"timeout")  dateValue]];
    } else if ([is_use isEqualToString:@"1"]) {
        self.lbstate.text = @"已使用";
        self.lbtime.text = [@"使用时间: "stringByAppendingString:[obj.str(@"usetime") dateValue]];
    } else if (is_use.integerValue == 2) {
        self.lbstate.text = @"冻结中";
    }
    
    NSMutableString *subtitleStr = [NSMutableString stringWithFormat:@"\n投资≥%@元", obj.str(@"money_limit")];
    if (obj.i(@"borrow_days") > 0) {
        [subtitleStr appendFormat:@" 标的期限≥%@天", obj.str(@"borrow_days")];
    } else {
        [subtitleStr appendFormat:@" 标的期限:不限"];
    }
    self.subtitle.text = subtitleStr;
}

@end
