//
//  QTSelectTime.m
//  qtyd
//
//  Created by stephendsw on 16/3/2.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSelectTime.h"
#import "RMCalendarController.h"
#import "UIView+layout.h"
#import "UIViewController+toast.h"
#import "UIViewExt.h"
#import "QTTheme.h"

@interface QTSelectTime ()
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet UIButton *btnEnd;
@end

@implementation QTSelectTime
{
    int selectBtnTag;
}

@synthesize sDate;
@synthesize eDate;

- (NSString *)sDateStr {
    NSTimeInterval time = [[NSString stringFromDate:sDate Format:@"yyyy-MM-dd"].add(@" 00:00:00") timeIntervalValue];

    return [NSString stringFormValue:time];
}

- (NSString *)eDateStr {
    NSTimeInterval time = [[NSString stringFromDate:eDate Format:@"yyyy-MM-dd"].add(@" 23:59:59") timeIntervalValue];

    return [NSString stringFormValue:time];
}

- (void)setTimeInView:(UIView *)tableView {
    NSString *date = [NSString stringFromDate:[NSDate systemDate] Format:@"yyyy-MM-dd"];

    eDate = [NSDate systemDate];
    sDate = [NSDate systemDate];
    sDate = [sDate dayInTheFollowingMonth:-12];

    [self.btnEnd setTitle:date forState:UIControlStateNormal];
    [self.btnStart setTitle:[NSString stringFromDate:sDate Format:@"yyyy-MM-dd"] forState:UIControlStateNormal];

    [QTTheme btnGreenStyle:self.btnEnd];
    [QTTheme btnGreenStyle:self.btnStart];
    // 日历
    RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];

    __weak RMCalendarController *weakC = c;

    c.isEnable = YES;
    c.calendarBlock = ^(RMCalendarModel *model) {
        NSString *data = [[NSDate systemDate]stringFromDate:model.date];

        if (selectBtnTag == 0) {
            sDate = model.date;
            [self.btnStart setTitle:data forState:UIControlStateNormal];
        } else if (selectBtnTag == 1) {
            eDate = model.date;
            [self.btnEnd setTitle:data forState:UIControlStateNormal];
        }

        [weakC.collectionView removeFromSuperview];

        if ([sDate compare:eDate] == NSOrderedAscending) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeStart:end:)]) {
                [self.delegate selectTimeStart:sDate end:eDate];
            }
        } else {
            [self.viewController showToast:@"结束时间大于起始时间"];
        }
    };

    [self.btnStart clickOn:^(id value) {
        selectBtnTag = 0;

        c.view.frame = tableView.frame;

        c.collectionView.top = tableView.top;
        c.collectionView.height = tableView.height;

        [self.viewController.view insertSubview:c.collectionView aboveSubview:tableView];
    } off:^(id value) {
        [c.collectionView removeFromSuperview];
    }];

    [self.btnEnd clickOn:^(id value) {
        selectBtnTag = 1;

        c.view.frame = tableView.frame;

        c.collectionView.top = tableView.top;
        c.collectionView.height = tableView.height;

        [self.viewController.view insertSubview:c.collectionView aboveSubview:tableView];
    } off:^(id value) {
        [c.collectionView removeFromSuperview];
    }];
}

@end
