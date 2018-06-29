//
//  QTAdressView.h
//  qtyd
//
//  Created by stephendsw on 16/3/21.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, AddressType) {
    /**
     *  订单详情
     */
    AddressTypeOrder = 0,

    /**
     *  确认订单
     */
    AddressTypeMall = 1,
};

@interface QTAdressView : UIView

@property (nonatomic, assign) AddressType type;

@property (nonatomic , readonly ) NSString *address;


- (void)bind:(NSDictionary *)value;



@end
