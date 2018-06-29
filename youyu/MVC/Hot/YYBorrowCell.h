//
//  YYBorrowCell.h
//  youyu
//
//  Created by 宋国华 on 2018/6/13.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBorrowModel.h"

@interface YYBorrowCell : UITableViewCell

+ (CGFloat)rowHeight;
+ (NSString *)cellIdentifier;

- (void)configCellWithModel:(YYBorrowModel *)model;

@end
