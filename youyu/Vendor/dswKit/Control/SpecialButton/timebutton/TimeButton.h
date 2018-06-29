//
//  TimeButton.h
//  qtyd
//
//  Created by stephendsw on 15/9/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeButton;

@protocol TimeButtonDatasource<NSObject>

- (NSString *)timeButtonRunningTitle:(TimeButton *)timeButton second:(NSInteger)second;

- (NSString *)timeButtonStoppingTitle:(TimeButton *)timeButton;

@end

@interface TimeButton : UIButton
{
    NSTimer *time;

    NSInteger _second;
}

@property (nonatomic, weak) id<TimeButtonDatasource> datasource;

- (void)startSecond:(NSInteger)second;

@end
