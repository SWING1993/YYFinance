//
//  QTCirlce.h
//  circle
//
//  Created by stephendsw on 15/12/21.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTCirlceView : UIView

/**
 *  环半径
 */
@property (nonatomic, assign) float ringWidth;

@property (nonatomic , strong ) UIColor *ringColor;


@property (nonatomic , assign ) BOOL showInnerRing;


/**
 *  百分比
 */
@property (nonatomic, assign) float rate;

@end
