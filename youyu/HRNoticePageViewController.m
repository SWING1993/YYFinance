//
//  HRNoticePageViewController.m
//  hr
//
//  Created by 赵 on 01/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRNoticePageViewController.h"
#import "UIViewController+toast.h"
#import "QTJsonUtil.h"
#import "QTAnnouncementViewController.h"
#import "HSDTrendViewController.h"
#import "HSDAnnouncementViewController.h"

@interface HRNoticePageViewController ()

@end

@implementation HRNoticePageViewController
{
    QTJsonUtil *service;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    service = [QTJsonUtil new];
    self.title = @"发现";
    
    [self commonJson];
}


#pragma mark json
- (void)commonJson {
//    [self showHUD];
    [service post:@"article_sortList" data:nil complete:^(NSDictionary *value) {
        NSMutableArray *controllers = [NSMutableArray new];
        NSMutableArray *titles = [NSMutableArray new];
        
        QTAnnouncementViewController *controller1 = [QTAnnouncementViewController controllerFromXib];
//        HSDTrendViewController *controller1 = [HSDTrendViewController controllerFromXib];
//        controller1.type = QTAnnouncementNotice;
//        controller1.sort = @"2";
        [titles addObject:@"动态"];
        [controllers addObject:controller1];
        
        QTAnnouncementViewController *controller2 = [QTAnnouncementViewController controllerFromXib];
//        HSDAnnouncementViewController *controller2 = [HSDAnnouncementViewController controllerFromXib];
//        controller2.type = QTAnnouncementNotice;
//        controller2.sort = @"1";
        [titles addObject:@"公告"];
        [controllers addObject:controller2];
        
        self.titles = titles;
        self.viewControllerClasses = controllers;
        
        [QTTheme pageWMControlStyle:self];
        self.menuItemWidth = APP_WIDTH / 2;
        
        [self loadData];
    }];
}

@end

