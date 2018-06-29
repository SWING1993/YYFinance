//
//  LineView.h
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

- (void)setText:(NSString *)text money:(NSString *)money;

@property (nonatomic , strong ) NSString *tip;

@end
