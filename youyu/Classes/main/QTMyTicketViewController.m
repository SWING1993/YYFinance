//
//  QTMyTicketViewController.m
//  qtyd
//
//  Created by stephendsw on 16/8/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMyTicketViewController.h"
#import "MLMSegmentManager.h"
#import "QTUser_rewardinfoViewController.h"
#import "QTTicketViewController.h"
#import "QTGetRewardViewController.h"

@interface QTMyTicketViewController ()

@end

@implementation QTMyTicketViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"礼券兑换" target:self action:@selector(toRewardCode)];
    self.titleView.title = @"我的礼券";
    
}

/**
 *  兑换券
 */
- (void)toRewardCode {
    QTGetRewardViewController *controller = [QTGetRewardViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initSubviews {
    [super initSubviews];
    NSArray *titles = @[@"现金券", @"红包券", @"年化券"];

    MLMSegmentHead *segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, kNaviHeigh, SCREEN_WIDTH, 40) titles:titles headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    //    segHead.fontScale = .85;
    segHead.fontSize = 14;
    segHead.lineScale = .4;
    segHead.selectColor = kColorRed;
    segHead.deSelectColor = kColorTextGray;
    segHead.bottomLineHeight = 0.5f;
    segHead.bottomLineColor = kColorBackGround;
    segHead.lineColor = kColorRed;
    MLMSegmentScroll *segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(segHead.frame)) vcOrViews:[self vcArr]];
    segScroll.loadAll = NO;
    segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:segHead withScroll:segScroll completion:^{
        [self.view addSubview:segHead];
        [self.view addSubview:segScroll];
    }];
}

#pragma mark - 数据源
- (NSArray *)vcArr {
    QTUser_rewardinfoViewController *controller1 = [QTUser_rewardinfoViewController controllerFromXib];
    controller1.segment = 0;
    
    QTUser_rewardinfoViewController *controller2 = [QTUser_rewardinfoViewController controllerFromXib];
    controller2.segment = 1;
    
    QTTicketViewController *controller3 = [QTTicketViewController controllerFromXib];
    
    NSArray *controllers = @[controller1, controller2, controller3];
    return controllers;
}

@end
