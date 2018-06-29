//
//  QTOrderCell.h
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "DTableViewCell.h"

typedef void (^ clickBlock)(NSInteger index);

@interface QTOrderCell : DTableViewCell

@property (nonatomic, strong) clickBlock block;

@end
