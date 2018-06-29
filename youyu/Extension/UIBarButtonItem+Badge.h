//
//  UIBarButtonItem+Badge.h
//  BlackCard
//
//  Created by ChenXue on 2017/6/30.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Badge)
@property (strong, nonatomic) UIView *badge;
@property (assign, nonatomic) UIColor *badgeColor;
@property (assign, nonatomic) CGFloat badgeOriginX;
@property (assign, nonatomic) CGFloat badgeOriginY;
@property (assign, nonatomic) CGFloat badgeSize; // badge width and height
@property BOOL hasBadge; // show badge or not
@end
