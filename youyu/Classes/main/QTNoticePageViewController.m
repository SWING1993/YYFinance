//
//  QTNoticePageViewController.m
//  qtyd
//
//  Created by stephendsw on 2016/11/24.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTNoticePageViewController.h"
#import "UIViewController+toast.h"
#import "QTJsonUtil.h"
#import "QTAnnouncementViewController.h"

@interface QTNoticePageViewController ()

@end

@implementation QTNoticePageViewController
{
    QTJsonUtil *service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    service = [QTJsonUtil new];
    self.titleView.title = @"官方公告";

    [self commonJson];
}

#pragma mark json
- (void)commonJson {
    [self showHUD];
    [service post:@"article_sortList" data:nil complete:^(NSDictionary *value) {
        NSMutableArray *controllers = [NSMutableArray new];
        NSMutableArray *titles = [NSMutableArray new];

        QTAnnouncementViewController *controller1 = [QTAnnouncementViewController controllerFromXib];

        controller1.type = QTAnnouncementNotice;
        controller1.sort = @"";
        [titles addObject:@"全部"];
        [controllers addObject:controller1];

        for (NSDictionary *item  in value.arr(@"sort_list")) {
            QTAnnouncementViewController *controller1 = [QTAnnouncementViewController controllerFromXib];
            controller1.type = QTAnnouncementNotice;
            controller1.sort = item.str(@"sort_info.value");
            [titles addObject:item.str(@"sort_info.name")];
            [controllers addObject:controller1];
        }

        self.titles = titles;
        self.viewControllerClasses = controllers;

        [QTTheme pageWMControlStyle:self];
        self.menuItemWidth = APP_WIDTH / 4;

        [self loadData];
    }];
}

@end
