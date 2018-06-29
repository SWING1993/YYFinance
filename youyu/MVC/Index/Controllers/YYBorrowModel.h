//
//  YYBorrow.h
//  youyu
//
//  Created by 宋国华 on 2018/6/13.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBorrowModel : NSObject

@property (nonatomic, copy) NSString *apr;
@property (nonatomic, copy) NSString *apr_add;
@property (nonatomic, copy) NSString *borrow_name;
@property (nonatomic, copy) NSString *borrow_type;
//收益天数
@property (nonatomic, copy) NSString *borrow_rest_time;
@property (nonatomic, copy) NSString *full_time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) float invent_percent;
@property (nonatomic, copy) NSString *invest_balance;
//起投金额
@property (nonatomic, copy) NSString *invest_minimum;
@property (nonatomic, copy) NSString *investable_users;
//进度值
@property (nonatomic, copy) NSString *loan_amount;
@property (nonatomic, copy) NSDictionary *loan_period;
// 0 普通标 1 VIP标 2 新手标 3 聚财宝
@property (nonatomic, assign) NSInteger new_hand;
@property (nonatomic, copy) NSString *operate;
@property (nonatomic, copy) NSString *publish_time;
//标的状态 0 等待审核 1审核失败 2投资中 3满标 4已流标 5还款中 6已还款 7满标待窜
@property (nonatomic, assign) NSInteger real_state;
@property (nonatomic, copy) NSString *repay_time;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *thumbnails;
@property (nonatomic, copy) NSString *user_id;

@end
