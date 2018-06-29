//
//  QTUser_rewardinfoCell.h
//  qtyd
//
//  Created by stephendsw on 15/7/20.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

@interface QTUserRewardinfoCell : UITableViewCell
@property (nonatomic,assign)BOOL isQuan;

+ (NSString *)cellIdentifier;
- (void)bind:(NSDictionary *)obj;

@end
