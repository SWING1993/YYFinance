//
//  MXMarqueeView.h
//  MXMarqueeViewDemo
//
//  Created by Long on 12-9-24.
//  Copyright (c) 2012年 Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXMarqueeView : UIView

@property (nonatomic,assign) float textSpace;
@property (nonatomic,retain) NSAttributedString *text;
@property (nonatomic,retain) UIFont *font;
@property (nonatomic,assign) float speed;

- (void)setBackgroundImage:(UIImage *)image;
- (void)startAnimation;
- (void)stopAnimation;

@end
