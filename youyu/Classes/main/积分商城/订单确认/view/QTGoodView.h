//
//  QTGoodView.h
//  qtyd
//
//  Created by stephendsw on 16/3/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTGoodView : UIView

@property (nonatomic, assign) NSInteger num;

- (void)bind:(NSDictionary *)value;

@end
