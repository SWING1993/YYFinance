//
//  QTSelectAdressViewController.h
//  qtyd
//
//  Created by stephendsw on 16/1/29.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@protocol SelectAdressDelegate<NSObject>

- (void)selectedAddress:(NSString *)value tag:(NSInteger )tag;

@end

@interface QTSelectAdressViewController : QTBaseViewController

@property (nonatomic, weak) id<SelectAdressDelegate> delegate;
@property (nonatomic , assign ) NSInteger tag;

@end
