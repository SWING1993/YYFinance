//
//  QTSelectRedPacketViewController.h
//  qtyd
//
//  Created by stephendsw on 16/4/5.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@protocol QTSelectCouponDelegate<NSObject>

- (void)didselectCoupon:(NSDictionary *)obj;

@end

@interface QTSelectCouponViewController : QTBaseViewController

@property (nonatomic, strong) NSString *money;

@property (nonatomic, strong) NSDictionary *value;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, weak) id<QTSelectCouponDelegate> delegate;



@end
