//
//  SpecialBaseView.h
//  test
//
//  Created by stephen on 15/2/12.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+layout.h"
#import "UIViewExt.h"
#import "CGRect+other.h"
#import "NSObject+KVO.h"

#pragma mark - help
@interface UIView (Margin)

@property (nonatomic, strong) NSValue *margin;

@property (nonatomic, strong) NSValue *padding;

@end

// 处理label
@interface UILabel (autoHeight)

- (void)autoHeight;

@end

@interface DLayoutBaseView : UIView
{
    NSException *error;
    UIView *frontView;
}

- (instancetype)initWidth:(CGFloat)width;

- (void)addView:(UIView *)view;

- (void)deleteView:(UIView *)view;

/**
 *  内部调用
 */
- (void)updateView;

@end
