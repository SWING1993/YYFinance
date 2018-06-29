//
//  YYArticleModel.h
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMediaModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *litpic;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *publish;
@property (nonatomic, copy) NSString *summary;
//0 未开始 1进行中 2 结束
@property (nonatomic, assign) NSInteger azstatus;
@property (nonatomic, copy) NSString *now;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;

- (NSTimeInterval)sinceTimeInterval;

@end
