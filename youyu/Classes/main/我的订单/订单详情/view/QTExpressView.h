//
//  QTExpressView.h
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTExpressView : UIView

- (void)bind:(NSDictionary *)value;

@property (nonatomic , strong ) NSString *status;

@end
