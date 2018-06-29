//
//  QTAccountDetailsView.m
//  qtyd
//
//  Created by stephendsw on 16/8/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTAccountDetailsView.h"

@interface QTAccountDetailsView ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation QTAccountDetailsView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.borderColor = [Theme borderColor];
    self.borderWidth = 0.5;
    self.lbTitle.textColor = [Theme redColor];
    self.clipsToBounds=NO;
}

- (void)setTitle:(NSString *)title {
    self.lbTitle.text = title;
}

- (void)setImageName:(NSString *)imageName {
    self.image.image = [UIImage imageNamed:imageName];
}

- (NSString *)title {
    return @"";
}

- (NSString *)imageName {
    return @"";
}

@end
