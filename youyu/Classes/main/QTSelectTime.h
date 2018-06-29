//
//  QTSelectTime.h
//  qtyd
//
//  Created by stephendsw on 16/3/2.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QTSelectTimeDelegate<NSObject>

- (void)selectTimeStart:(NSDate *)s end:(NSDate *)e;

@end

@interface QTSelectTime : UIView

@property (nonatomic, weak) id<QTSelectTimeDelegate> delegate;

- (void)setTimeInView:(UIView *)tableView;

@property (nonatomic, strong) NSDate        *sDate;
@property (nonatomic, readonly) NSString    *sDateStr;

@property (nonatomic, strong) NSDate        *eDate;
@property (nonatomic, readonly) NSString    *eDateStr;
@end
