//
//  QTTicketCell.h
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"

@interface QTTicketCell : DTableViewCell

- (void)bindSelect:(NSDictionary *)obj;

@property (nonatomic, strong) NSString *money;


@end
