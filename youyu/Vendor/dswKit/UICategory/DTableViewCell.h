//
//  WLBaseTableViewCell.h
//  Car_ZJ
//
//  Created by stephen on 15/1/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+quick.h"
#import "UIView+layout.h"
#import "UIViewExt.h"
#import "AppUtil.h"
#import "UIImageView+webImage.h"



@interface DTableViewCell : UITableViewCell

- (void)hideLine;

// 数据
- (void)bind:(NSDictionary *)obj;

- (void)bind:(NSDictionary *)obj IndexPath:(NSIndexPath *)indexPath;

// 高度
- (CGFloat)height;

- (CGFloat)height:(NSDictionary *)obj;

- (CGFloat)height:(NSDictionary *)obj IndexPath:(NSIndexPath *)indexPath;
@end
