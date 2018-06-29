//
//  QTLoginCodeViewController.h
//  qtyd
//
//  Created by stephendsw on 2016/11/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@protocol QTLoginDelegate <NSObject>

-(void)loinWithCode:(NSString *)code;

@end


@interface QTLoginCodeViewController : QTBaseViewController


@property (nonatomic , strong ) NSString * phone;

@property (nonatomic , weak ) id<QTLoginDelegate> delegate;

@end
