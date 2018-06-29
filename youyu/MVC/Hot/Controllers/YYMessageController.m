//
//  YYMessageController.m
//  youyu
//
//  Created by 宋国华 on 2018/6/15.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYMessageController.h"
#import "YYMessageListController.h"
#import "MLMSegmentManager.h"

@interface YYMessageController ()

@end

@implementation YYMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleView.title = @"消息中心";

}

- (void)initSubviews {
    [super initSubviews];
    NSArray * list = @[@"系统公告",@"我的消息"];
    MLMSegmentHead *segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, kNaviHeigh, SCREEN_WIDTH, 40) titles:list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
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
    NSMutableArray *arr = [NSMutableArray array];
    YYMessageListController *vc1 = [[YYMessageListController alloc] initWithStyle:UITableViewStyleGrouped];
    vc1.type_id = @"2";
    [arr addObject:vc1];
    
    YYMessageListController *vc2 = [[YYMessageListController alloc] initWithStyle:UITableViewStyleGrouped];
    vc2.type_id = @"1";
    [arr addObject:vc2];
    return arr;
}

@end
