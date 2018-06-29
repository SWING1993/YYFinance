//
//  ZJLabel.h
//  ZJLabel
//
//  Created by iOS on 16/6/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLabel : UIView
@property (nonatomic,assign)CGFloat present;
@property (nonatomic,assign)BOOL decimalsCount;//是否显示小数点
@property (nonatomic,strong)UILabel * presentlabel;
- (instancetype)initWithFrame:(CGRect)frame;
@end
