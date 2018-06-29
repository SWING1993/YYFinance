//
//  QTSelectBankViewController.h
//  qtyd
//
//  Created by stephendsw on 15/7/23.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"

@protocol SelectBankDelegate <NSObject>

-(void)selectBankCode:(NSString *)code  name :(NSString *)name;

@end


@interface QTSelectBankViewController : QTBaseViewController
@property (nonatomic , weak ) id<SelectBankDelegate> delegate;

@end
