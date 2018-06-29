//
//  CAShapeLayer+qtlayer.h
//  qtyd
//
//  Created by stephendsw on 16/4/12.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (qtlayer)

/**
 *  虚线
 *
 */
+ (CAShapeLayer *)layerDottedLine:(CGRect)rect;

@end
