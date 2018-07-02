//
//  YYInvestRecordController.m
//  youyu
//
//  Created by 宋国华 on 2018/7/2.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYInvestRecordController.h"
#import "MLMSegmentManager.h"
#import "QTInvestRecordViewController.h"

@interface YYInvestRecordController ()

@end

@implementation YYInvestRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initSubviews {
    [super initSubviews];
    self.titleView.title = @"投资记录";
    
    NSArray *titles = @[@"全部", @"履约中", @"已回款", @"未成功"];
    
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
    QTInvestRecordViewController *controller1 = [QTInvestRecordViewController controllerFromXib];
    controller1.segment = 0;
    
    QTInvestRecordViewController *controller2 = [QTInvestRecordViewController controllerFromXib];
    controller2.segment = 1;
    
    QTInvestRecordViewController *controller3 = [QTInvestRecordViewController controllerFromXib];
    controller3.segment = 2;
    
    QTInvestRecordViewController *controller4 = [QTInvestRecordViewController controllerFromXib];
    controller4.segment = 3;
    
    NSArray *controllers = @[controller1, controller2, controller3, controller4];
    return controllers;
}

@end
