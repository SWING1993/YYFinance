//
//  YYMessageModel.h
//  youyu
//
//  Created by 宋国华 on 2018/6/15.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMessageModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *sendtime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger read_state;

@end
