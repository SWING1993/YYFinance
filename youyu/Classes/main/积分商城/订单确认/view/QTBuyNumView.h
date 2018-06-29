//
//  QTBuyNumView.h
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTBuyNumView : UIView

@property (weak, nonatomic) IBOutlet PKYStepper *stepper;
@property (nonatomic, assign) NSInteger         num;
- (void)bind:(NSDictionary *)value;

@end
