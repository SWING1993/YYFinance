//
//  RecordModel.h
//  qtyd
//
//  Created by stephendsw on 15/7/29.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) NSArray *listkey;

- (NSString *)getName:(NSString *)ID;

@end
