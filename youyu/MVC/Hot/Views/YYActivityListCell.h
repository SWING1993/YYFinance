//
//  YYActivityListCell.h
//  youyu
//
//  Created by 宋国华 on 2018/6/14.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMediaModel.h"
@interface YYActivityListCell : UITableViewCell

+ (CGFloat)rowHeight;
+ (NSString *)cellIdentifier;

- (void)configCellWithModel:(YYMediaModel *)model;

@end
