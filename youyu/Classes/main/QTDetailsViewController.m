//
//  QTDetailsViewController.m
//  qtyd
//
//  Created by stephendsw on 16/9/19.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTDetailsViewController.h"
#import "QTAccountDetailsView.h"

@interface QTDetailsViewController ()

@end

@implementation QTDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleView.title = @"账户明细";
    self.navigationItem.rightBarButtonItem = nil;
    self.isLockPage = YES;
}

- (void)initUI {
    [self initScrollView];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];
    stack.backgroundColor = [Theme backgroundColor];

    QTAccountDetailsView *view3 = [QTAccountDetailsView viewNib];
    view3.title = @"交易流水";
    view3.imageName = @"icon_trade_record";
    [view3 addTapGesture:^{
        [self toRecord];
    }];
    QTAccountDetailsView *view4 = [QTAccountDetailsView viewNib];
    view4.title = @"积分流水";
    view4.imageName = @"icon_point_record";
    [view4 addTapGesture:^{
        [self toPointRecrod];
    }];

    [stack addView:view3 margin:UIEdgeInsetsMake(0, 0, 15, 0)];
//    [stack addView:view4 margin:UIEdgeInsetsMake(0, 0, 0, 0)];

    for (int i = 0; i < 1; i++) {
        UIView *view = stack.subviews[i];

        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, APP_WIDTH, 140)].CGPath;

        // 阴影的颜色
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOffset = CGSizeMake(0, 2);
        // 阴影透明度
        view.layer.shadowOpacity = 0.1;
        // 阴影圆角度数
        view.layer.shadowRadius = 2;
    }

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

@end
