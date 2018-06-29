//
//  YYActivityListCell.m
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYActivityListCell.h"

@interface YYActivityListCell()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIImageView *litImageView;
@property (nonatomic, strong) UILabel *azstatusLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation YYActivityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = kColorClear;
        self.contentView.backgroundColor = kColorClear;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kColorWhite;
        YYViewBorderRadius(bgView, 12, CGFLOAT_MIN, kColorClear);
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        self.topLabel = [[UILabel alloc] initWithFont:UIFontLightMake(14) textColor:kColorTextBlack];
        [bgView addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(34));
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        self.bottomLabel = [[UILabel alloc] initWithFont:UIFontLightMake(12) textColor:kColorTextGray];
        self.bottomLabel.text = @"查看详情";
        [bgView addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(kScaleFrom_iPhone6_Desgin(50));
        }];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage qmui_imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(11, 15) lineWidth:1 tintColor:UIColorMake(173, 180, 190)]];
        [self.bottomLabel addSubview:bottomImageView];
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(11, 15));
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.bottomLabel);
        }];
        
        self.litImageView = [[UIImageView alloc] init];
        self.litImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.litImageView.clipsToBounds = YES;
        [bgView addSubview:self.litImageView];
        [self.litImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topLabel.mas_bottom);
            make.bottom.mas_equalTo(self.bottomLabel.mas_top);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        self.azstatusLabel = [[UILabel alloc] initWithFont:UIFontLightMake(12) textColor:kColorWhite];
        YYViewBorderRadius(self.azstatusLabel, 2, 0, kColorClear);
        self.azstatusLabel.textAlignment = NSTextAlignmentCenter;
        self.azstatusLabel.backgroundColor = UIColorMake(255, 100, 0);
        [self.litImageView addSubview:self.azstatusLabel];
        [self.azstatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(52, 18));
        }];
    }
    return self;
}

+ (CGFloat)rowHeight {
     return kScaleFrom_iPhone6_Desgin(220);
}

+ (NSString *)cellIdentifier {
    return @"YYActivityListCellIdentifier";
}

- (void)configCellWithModel:(YYMediaModel *)model {
    [self.litImageView sd_setImageWithURL:[NSURL URLWithString:model.litpic] placeholderImage:kPlaceholderImage];
    
    switch (model.azstatus) {
        case 0:{
            self.azstatusLabel.text = @"";
            self.azstatusLabel.hidden = YES;
            self.litImageView.alpha = 1.f;
            [self.timer invalidate];
            self.timer = nil;
            @weakify(self)
            __block NSTimeInterval timeInterval = [model sinceTimeInterval];
            self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
                @strongify(self)
                timeInterval = timeInterval - 1;
                if (timeInterval <= 0) {
                    self.topLabel.text = model.name;
                    self.topLabel.textColor = kColorTextBlack;
                    self.azstatusLabel.hidden = NO;
                    self.azstatusLabel.text = @"进行中";
                    [self.timer invalidate];
                    self.timer = nil;
                } else {
                    self.topLabel.textColor = UIColorMake(249, 35, 29);
                    self.topLabel.text = [NSString stringWithFormat:@"距开始时间 %@",[self getDetailTimeWithTimestamp:timeInterval]];
                }
            } repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
            break;
        case 1:{
            self.azstatusLabel.text = @"进行中";
            self.azstatusLabel.hidden = NO;
            self.litImageView.alpha = 1.f;
            [self.timer invalidate];
            self.timer = nil;
            self.topLabel.text = model.name;
            self.topLabel.textColor = kColorTextBlack;
        }
            break;
        case 2:{
            self.azstatusLabel.text = @"已结束";
            self.azstatusLabel.hidden = NO;
            self.litImageView.alpha = 0.5f;
            [self.timer invalidate];
            self.timer = nil;
            self.topLabel.text = model.name;
            self.topLabel.textColor = kColorTextBlack;
        }
            break;
            
        default:{
            
        }
            break;
    }
}

- (NSString *)getDetailTimeWithTimestamp:(NSTimeInterval)timestamp {
    NSInteger ms = timestamp;
    NSInteger mi = 60;
    NSInteger hh = 3600;
    NSInteger dd = 3600 * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi);// 秒
    NSString *str = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",(long)day,hour,minute,second];
    NSLog(@"lalalala:%@",str);
    return str;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
