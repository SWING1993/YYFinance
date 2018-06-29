//
//  YYIndexCell.h
//  youyu
//
//  Created by 宋国华 on 2018/6/20.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBorrowModel.h"

@interface YYIndexCell : UITableViewCell
@property (nonatomic, strong) RACSubject *delegateSignal;
@property (nonatomic, strong) YYBorrowModel *model;

+ (CGFloat)rowHeight;
+ (NSString *)cellIdentifier;

- (void)configCellWithModel:(YYBorrowModel *)model;

@end
