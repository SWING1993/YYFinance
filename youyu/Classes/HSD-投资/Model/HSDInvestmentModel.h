//
//  HSDInvestmentModel.h
//  hsd
//
//  Created by 杨旭冉 on 2017/10/25.
//  Copyright © 2017年 qtyd. All rights reserved.
//  湖商贷-投资-Model

#import <Foundation/Foundation.h>

@interface HSDInvestmentModel : NSObject

//obj.str(@"borrow_name");
//t = obj.str(@"apr");
//nvest_percent.add(@"%");
//m =obj.str(@"invest_minimum");
// =invest_mininum.add(@"元起投");
//time = obj.str(@"borrow_rest_tim
//收益期限".add(borrow_reset_time).a
//e = obj.str(@"invest_balance");
//= @"剩余金额".add([invest_balance
//IntegerValue]).add(@"元");

@property (nonatomic, copy) NSString *borrow_name; //title
@property (nonatomic, copy) NSString *apr; //年化
@property (nonatomic, copy) NSString *invest_minimum; //起投金额
@property (nonatomic, copy) NSString *borrow_rest_time; //收益天数
@property (nonatomic, copy) NSString *invest_balance; //剩余金额
@property (nonatomic, strong) NSDictionary *loan_period; //loan_period[@"num"] 收益天数
@property (nonatomic, assign) CGFloat invent_percent; //进度值
@property (nonatomic, copy) NSString *typeID; //
@property (nonatomic, copy) NSString *real_state; //标的状态
@property (nonatomic, assign) NSInteger new_hand; // 是否是新手标
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_content;

@end



