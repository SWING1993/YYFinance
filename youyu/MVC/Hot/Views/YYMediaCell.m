//
//  YYMediaCell.m
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMediaCell.h"

@interface YYMediaCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *cellImage;
@end

@implementation YYMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//                self.qmui_shouldShowDebugColor = YES;
//                self.qmui_needsDifferentDebugColor = YES;
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = kColorWhite;
        
        self.cellImage = [[UIImageView alloc] init];
        self.cellImage.contentMode = UIViewContentModeScaleAspectFill;
        self.cellImage.clipsToBounds = YES;
        [self.contentView addSubview:self.cellImage];
        [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(kScaleFrom_iPhone6_Desgin(115));
            make.right.mas_equalTo(-15);
        }];
        YYViewBorderRadius(self.cellImage, 4, CGFLOAT_MIN, kColorClear);
        
        self.timeLabel = [[UILabel alloc] initWithFont:UIFontLightMake(12) textColor:kColorTextGray];
        self.timeLabel.text = @"查看详情";
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.cellImage.mas_left).mas_offset(-15);
            make.height.mas_equalTo(12);
        }];
        
        self.contentLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:kColorTextBlack];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.cellImage.mas_left).mas_offset(-15);
            make.bottom.mas_equalTo(self.timeLabel.mas_top).mas_offset(-10);
        }];

    }
    return self;
}

+ (CGFloat)rowHeight {
    return kScaleFrom_iPhone6_Desgin(100);
}

+ (NSString *)cellIdentifier {
    return @"YYMediaCellIdentifier";
}

- (void)configCellWithModel:(YYMediaModel *)model {
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.abstract dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.contentLabel.attributedText = attrStr;
    self.timeLabel.text = model.publish;
    if (!model.litpic.isEmptyString) {
        [self.cellImage sd_setImageWithURL:YYURLWithStr(model.litpic) placeholderImage:kPlaceholderImage];
    }
}

@end
