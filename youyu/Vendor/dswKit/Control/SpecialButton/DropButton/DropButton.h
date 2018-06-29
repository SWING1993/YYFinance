//
//  DropButton.h
//  qtyd
//
//  Created by stephendsw on 15/8/7.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+BlockEvent.h"

@interface DropButton : UIControl

@property (weak, nonatomic) IBOutlet UILabel *lbtitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//重写系统属性，适配iOS11
@property(nonatomic, assign) CGSize intrinsicContentSize;

- (void)clickDown:(eventBlock)done;

- (void)show;
- (void)hide;

@end
