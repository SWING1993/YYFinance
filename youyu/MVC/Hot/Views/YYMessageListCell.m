//
//  YYMessageListCell.m
//  youyu
//
//  Created by 宋国华 on 2018/6/15.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMessageListCell.h"

@implementation YYMessageListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = UIFontLightMake(14);
        self.detailTextLabel.font = UIFontLightMake(11);
        self.detailTextLabel.textColor = kColorTextGray;
    }
    return self;
}

+ (CGFloat)rowHeight {
    return kScaleFrom_iPhone6_Desgin(50);
}

+ (NSString *)cellIdentifier {
    return @"YYMessageListCellIdentifier";
}

//- (void)configCellWithModel:(YYMessageModel *)model {
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.abstract dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    self.contentLabel.attributedText = attrStr;
//    self.timeLabel.text = model.publish;
//    if (!model.litpic.isEmptyString) {
//        [self.cellImage sd_setImageWithURL:[NSURL URLWithString:model.litpic] placeholderImage:kPlaceholderImage];
//    }
//}
@end
