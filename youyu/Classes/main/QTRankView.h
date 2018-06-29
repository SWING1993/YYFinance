//
//  QTRankView.h
//  qtyd
//
//  Created by stephendsw on 16/3/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTRankView : UIView

-(void)setImage:(NSString *)url rank:(NSString *)rank;

@property (nonatomic , assign ) CGFloat scrollOffsetX;

@end
