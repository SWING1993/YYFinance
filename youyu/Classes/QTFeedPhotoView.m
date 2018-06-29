//
//  QTFeedPhotoView.m
//  qtyd
//
//  Created by stephendsw on 16/4/25.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTFeedPhotoView.h"

@interface QTFeedPhotoView ()
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UIButton       *btn;
@property (weak, nonatomic) IBOutlet UILabel        *lbtip;

@end

@implementation QTFeedPhotoView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.hidden = YES;
    self.backgroundColor = [Theme backgroundColor];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.width = 80;
    self.height = 80;
    self.image = nil;
}

- (void)setImage:(UIImage *)image {
    if (image) {
        self.imageView.image = image;
        self.btn.hidden = NO;
        self.hasImage = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.image = [UIImage imageNamed:@"icon_+_yijianfankui_add"];
        self.btn.hidden = YES;
        self.hasImage = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
}

- (UIImage *)image {
    if (self.hasImage) {
        return self.imageView.image;
    } else {
        return nil;
    }
}

- (IBAction)click:(id)sender {
    self.image = nil;
}

@end
