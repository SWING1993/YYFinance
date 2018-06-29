//
//  QTJsonUtil+Login.h
//  qtyd
//
//  Created by stephendsw on 16/1/11.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTJsonUtil.h"

typedef void (^ loginBlock)(NSDictionary *value);

@interface QTJsonUtil (other)

- (void)loginPara:(NSDictionary *)para done:(loginBlock)block;

@end
