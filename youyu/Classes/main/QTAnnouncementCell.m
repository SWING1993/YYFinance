//
//  QTAnnouncementCell.m
//  qtyd
//
//  Created by yl on 15/11/2.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTAnnouncementCell.h"
#import "NSString+model.h"
#import "QTTheme.h"

#import "NSDate+RMCalendarLogic.h"

@interface QTAnnouncementCell ()
@property (weak, nonatomic) IBOutlet UILabel    *lbContent;
@property (weak, nonatomic) IBOutlet UIView     *backView;
@property (weak, nonatomic) IBOutlet UILabel    *lbTime;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopMargin;

@end

@implementation QTAnnouncementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = Theme.backgroundColor;
    self.backView.layer.cornerRadius = 5;

    self.backView.layer.masksToBounds = YES;
    self.lbContent.preferredMaxLayoutWidth = APP_WIDTH - 32;
}

- (void)bind:(NSDictionary *)dic {
    NSString    *title = dic.str(@"name");
    NSString    *content = dic.str(@"abstract");

    if (content.length > 80) {
        content = [content substringToIndex:80];
    }

    NSString *time = dic.str(@"publish");

    NSMutableAttributedString *attributes = [NSMutableAttributedString new];

    NSString *serviceTime = [dic.str(@"serviceTime") dateValue];

    NSString *now = time.dateValue;

    if ([serviceTime isEqualToString:now]) {
        self.image.hidden = NO;
    } else {
        self.image.hidden = YES;
//        [attributes appendImageName:@"icon_gonggao_03"];
    }

    NSString *str = [NSString stringWithFormat:@"%@\n%@", title, content];

    [attributes appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
    [attributes setFont:[UIFont systemFontOfSize:15] string:title];
    [attributes setColor:[UIColor blackColor] string:title];
//    [attributes setColor:Theme.redColor string:@"more"];

    //
    [attributes setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 4;  // 行自定义行高度
        Paragraph.paragraphSpacing = 5;
    }];

    self.lbContent.attributedText = attributes;
    if (time.length > 0) {
        self.lineViewTopMargin.constant = 31;
        self.lbTime.hidden = NO;
        self.lbTime.text = time;
    }else{
        self.lbTime.hidden = YES;
        self.lineViewTopMargin.constant = 8;
    }
    
}

@end
