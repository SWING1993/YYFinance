//
//  GJCommonButton.m
//  CPH
//
//  Created by gaojun on 16/6/24.
//  Copyright © 2016年 gaojun. All rights reserved.
//
#import "GJCommonButton.h"

@implementation GJCommonButton

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //设置默认值0,外界可修改
        self.imageEdageHeight = 0.f;
        self.imageLeftRightEdageHeight = 0.f;
    }
    return  self;
}

//设置title显示的位置(1)
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat y = contentRect.size.height * self.scale;
    CGFloat height = contentRect.size.height * (1 - self.scale);
    return CGRectMake(0, y, contentRect.size.width, height);
}

//设置图片显示的位置(2)
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat height = contentRect.size.height * self.scale;
    return CGRectMake(self.imageLeftRightEdageHeight, self.imageEdageHeight, contentRect.size.width - 2 * self.imageLeftRightEdageHeight, height * self.imageScale);
}

//设置button的contentRect(3)
- (CGRect)contentRectForBounds:(CGRect)bounds {
    
    return CGRectMake(0, 10, bounds.size.width, bounds.size.height);
}

//note:上述三个方法的调用次序为:3,1,3,2,3,

//重写下面的方法(什么也不实现)可以让button在长按的时候不变色
- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
