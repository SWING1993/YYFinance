//
//  QTBuyGoodViewController.h
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@interface QTBuyGoodViewController : QTBaseViewController

@property (nonatomic, strong) NSString *address_id;

@property (nonatomic, strong) NSDictionary *goodInfo;

@property (nonatomic, assign) float quantity;


@end
