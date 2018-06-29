//
//  OrderInfo.h
//  helpdesk_sdk
//
//  Created by 赵 蕾 on 16/5/5.
//  Copyright © 2016年 hyphenate. All rights reserved.
//

#import "HContent.h"

@interface HOrderInfo : HContent
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* orderTitle;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString* itemUrl;
@property (nonatomic, copy) NSString* desc;

@end
