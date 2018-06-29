//
//  QTHomeCardView.h
//  qtyd
//
//  Created by stephendsw on 2017/1/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTHomeCardView : UIView

@property (strong, nonatomic)  UIImageView *image;

@property (strong, nonatomic)  UILabel *lbTitle;

- (void)setText:(NSString *)text img:(NSString *)imageName;


@end
