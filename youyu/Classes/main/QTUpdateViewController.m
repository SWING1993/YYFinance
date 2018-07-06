//
//  QTUpdateViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/8.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTUpdateViewController.h"

@interface QTUpdateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbtime;

@end

@implementation QTUpdateViewController
{
    NSTimer *time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setStartTime:(NSString *)s endTime:(NSString *)e {
    __block NSTimeInterval offtime = e.integerValue - s.integerValue;

    [time invalidate];

    if (offtime > 0) {
        time = [NSTimer timerExecuteCountPerSecond:offtime done:^(NSInteger vlaue) {
                if (vlaue == 0) {
                    self.view.hidden=YES;
                    [time invalidate];
                } else {
                    self.view.hidden=NO;
                    self.lbtime.text = [[@(vlaue)stringValue] secondToTimeFormat];
                }
            }];
    } else {
        self.view.hidden=YES;
    }
}

@end
