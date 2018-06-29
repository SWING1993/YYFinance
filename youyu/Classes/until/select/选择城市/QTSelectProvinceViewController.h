//
//  WLZJSelectProvinceViewController.h
//  Car_ZJ
//
//  Created by dsw on 14-6-9.
//  Copyright (c) 2014年 dsw. All rights reserved.
//

#import "QTBaseViewController.h"

typedef enum : NSUInteger {
    SelectProvice,
    SelectCity,
    SelectArea,
} Select;

@protocol SelectProvinceDelegate<NSObject>

@optional
- (void)selectedCity:(NSDictionary *)value;
- (void)selectedProvice:(NSDictionary *)value;
- (void)selectedArea:(NSDictionary *)value;

@end

@interface QTSelectProvinceViewController : QTBaseViewController

@property(nonatomic, weak)  id<SelectProvinceDelegate> delegate;

@property (nonatomic, strong) NSString *ProviceName;

@property (nonatomic, strong) NSString *CityName;

@property (nonatomic, assign) Select type;

@end
