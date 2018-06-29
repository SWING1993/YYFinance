//
//  QTVipView.h
//  qtyd
//
//  Created by stephendsw on 16/3/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTVipView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UIImageView        *lbImage;

@property (nonatomic , strong ) NSString *text;

- (void)setText:(NSString *)text img:(NSString *)imageName;

- (void)setDisable;

@property (nonatomic, assign) CGFloat radioWidth;

@end
