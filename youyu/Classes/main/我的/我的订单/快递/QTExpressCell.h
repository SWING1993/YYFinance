//
//  QTExpressCell.h
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"

typedef enum : NSUInteger {
    ExpressCellTypeFirst,
    ExpressCellTypeList,
    ExpressCellTypeLast,
} ExpressCellType;

@interface QTExpressCell : DTableViewCell

@property (nonatomic, assign) ExpressCellType type;

@end
