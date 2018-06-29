//
//  YYMessageListCell.h
//  youyu
//
//  Created by 宋国华 on 2018/6/15.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageModel.h"

@interface YYMessageListCell : QMUITableViewCell

+ (CGFloat)rowHeight;
+ (NSString *)cellIdentifier;

//- (void)configCellWithModel:(YYMessageModel *)model;

@end
