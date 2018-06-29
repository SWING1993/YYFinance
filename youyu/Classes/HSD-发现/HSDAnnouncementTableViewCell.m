//
//  HSDAnnouncementTableViewCell.m
//  hsd
//
//  Created by 杨旭冉 on 2017/10/24.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDAnnouncementTableViewCell.h"

@interface HSDAnnouncementTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLable;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopMargin;

@end

@implementation HSDAnnouncementTableViewCell

static NSString *const identifier = @"HSDAnnouncementTableViewCell";

+ (instancetype) cellWithTableView:(UITableView *)tableView {
    HSDAnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)bind:(NSDictionary *)dic {
    NSString    *title = dic.str(@"name");
    NSString    *content = dic.str(@"abstract");
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (content.length > 80) {
        content = [content substringToIndex:80];
    }
    NSString *time = dic.str(@"publish");
    
    self.timeLable.text = title;
    self.contentLable.text = content;
    self.timeLable.text = time;
//    if (time.length > 0) {
//
//    }else{
////        self.lineViewTopMargin.constant = 6;
//    }
    
//    NSMutableAttributedString *attributes = [NSMutableAttributedString new];
//
//    NSString *serviceTime = [dic.str(@"serviceTime") dateValue];
//
//    NSString *now = time.dateValue;
    
//    if ([serviceTime isEqualToString:now]) {
//        self.image.hidden = NO;
//    } else {
//        self.image.hidden = YES;
//        [attributes appendImageName:@"icon_gonggao_03"];
//    }
    
//    NSString *str = [NSString stringWithFormat:@"%@\n%@...more", title, content];
    
//    [attributes appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
//    [attributes setFont:[UIFont systemFontOfSize:15] string:title];
//    [attributes setColor:[UIColor blackColor] string:title];
//    [attributes setColor:Theme.redColor string:@"more"];
    
    //
//    [attributes setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
//        Paragraph.lineSpacing = 4;  // 行自定义行高度
//        Paragraph.paragraphSpacing = 5;
//    }];
    
//    self.lbContent.attributedText = attributes;
//    self.lbTime.text = time;
}

@end
