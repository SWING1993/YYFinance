//
//  QTExpressModel.h
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTExpressModel : NSObject


+ (NSDictionary *)getExpressDic;
+ (NSString *)getName:(NSInteger)num;

+ (NSString *)getType:(NSInteger)num;

@end
