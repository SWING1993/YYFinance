//
//  QTSafeCell.m
//  qtyd
//
//  Created by stephendsw on 15/8/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTSafeCell.h"
#import <Foundation/Foundation.h>

@interface QTSafeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *Image;

@property (weak, nonatomic) IBOutlet UILabel *lbtitile;

@property (weak, nonatomic) IBOutlet UIImageView *image_arrows;


@end

@implementation QTSafeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)bindName:(NSString *)str imageName:(NSString *)imgurl index:(NSIndexPath *)indexPath {
    NSRange range = [str rangeOfString:@"已"];
    
    if (indexPath.row!=5) {
        self.GestureSW.hidden = YES;
    }
    
    if (_isFromAccount) {
        self.GestureSW.hidden = YES;
    }
    
    if ((range.location != NSNotFound) && (indexPath.row == 0)) {
        self.image_arrows.hidden = YES;
        self.lbtitile.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.image_arrows.hidden = NO;
        self.lbtitile.textColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    if ([str containsString:@"已"]) {
        self.Image.image = [[UIImage imageNamed:imgurl] imageWithColor:[Theme darkOrangeColor]];
    } else {
        self.Image.image = [[UIImage imageNamed:imgurl] imageWithColor:[Theme grayColor]];
    }

    if ([str containsString:@"登录密码"]) {
        str = @"已设置登录密码";
    }

    if ([str containsString:@"登录详情"]) {
        str = @"登录详情";
    }

    if ((range.location != NSNotFound) || [str containsString:@"登录密码"]) {
        self.lbtitile.textColor = [UIColor grayColor];
    }

    self.lbtitile.text = str;
}

@end
