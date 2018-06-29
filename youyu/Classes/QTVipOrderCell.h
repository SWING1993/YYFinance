//
//  QTVipOrderCell.h
//  qtyd
//
//  Created by stephendsw on 16/5/31.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"

@protocol QTVipOrderDelegate <NSObject>

-(void)vipOrderCancel:(NSDictionary *)item;

-(void)vipOrderDidSelect:(NSDictionary *)item;

@end

@interface QTVipOrderCell : DTableViewCell


@property (nonatomic , weak ) id<QTVipOrderDelegate> delegate;


@end
