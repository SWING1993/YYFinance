//
//  WLBaseTableViewCell.m
//  Car_ZJ
//
//  Created by stephen on 15/1/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"

@implementation DTableViewCell

- (void)hideLine {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj
{}

- (void)bind:(NSDictionary *)obj IndexPath:(NSIndexPath *)indexPath
{}

- (CGFloat)height {
    return 0;
}

- (CGFloat)height:(NSDictionary *)obj {
    return 0;
}

- (CGFloat)height:(NSDictionary *)obj IndexPath:(NSIndexPath *)indexPath {
    return 0;
}

@end
