//
//  QTBaseViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "QTBaseViewController+Table.h"
#import "MJRefresh.h"
#import "QTUpdateViewController.h"

@interface QTBaseViewController ()

//@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@end

@implementation QTBaseViewController
{
    QTUpdateViewController *controller;
}

#pragma mark - ui

- (void)setRightNavItemTitle:(NSString *)str {
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithTitle:str style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = itembar;
}

- (void)setRightNavItemImage:(UIImage *)image {
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = itembar;
}

- (void)rightClick {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = Theme.backgroundColor;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netFailure) name:NoticePostNetworkError object:nil];

    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;

    service = [QTJsonUtil new];
    service.delegate = self;

    // xib 中scrollerview初始化
    if (self.scrollview) {
        [self initScrollView];
    }
    //
    self.canRefresh = YES;
    [self initUI];
    [self initData];
}

- (void)setRefreshScrollView {
    if (self.scrollview) {
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self commonJson];
            }];
        mj_header.arrowView.image = [UIImage imageNamed:@"icon_common_arrow_down"];
        self.scrollview.mj_header = mj_header;
    }
}

//- (void)autoInputNext {
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    [MobClick event:[NSString stringWithUTF8String:object_getClassName(self)]];
    // NSString *url = [NSString stringWithFormat:@"http://qttz.cn-hangzhou.log.aliyuncs.com/logstores/m-php-log/track?APIVersion=0.6.0&pageAppear=%@", NSStringFromClass([self class])];

    // [service get:url complete:^(id value) {}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


//- (void)dealloc {
//    self.returnKeyHandler = nil;
//}

#pragma  mark - jsondelegate

- (void)jsonFailureTimeout {
    [self hideHUD];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.scrollview.mj_header endRefreshing];
    [self.scrollview.mj_footer endRefreshing];
    [self showToast:NETERROR duration:3];
}

- (void)jsonFailure:(NSDictionary *)dic {
    [self hideHUD];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.scrollview.mj_header endRefreshing];
    [self.scrollview.mj_footer endRefreshing];
    
    [dic handleError];
    

    /*
    if ([dic isKindOfClass:[NSDictionary class]]) {
        // 后台错误提示
        NSInteger code = [dic code];
        NSLog(@"错误代码 --------------------------------------  %ld", (long)code);

        if (code == 110023) {
            return;
        }

        // 重新登录
        if ((code == 110025) || (code == 110026) || (code == 110019)) {
            NSString *errorTip = @"";

            if ((code == 110025) || (code == 110019)) {
                // 被踢了
                errorTip = LOGINOTHERTIP;
            } else if (code == 110026) {
                // 超时
                errorTip = UNLOGINTIP;
            }

//            [GVUserDefaults shareInstance].isLogin = NO;
            self.tabBarController.tabBar.userInteractionEnabled = NO;
            [self showToast:errorTip done:^{
                [self loginTimeout];
                self.tabBarController.tabBar.userInteractionEnabled = YES;
            }];
            return;
        }

        NSString *msg = [dic msg];

        // 系统维护
        if (code == 999999) {
            if (!controller) {
                controller = [QTUpdateViewController controllerFromXib];
            }

            [controller setStartTime:[SystemConfigDefaults  sharedInstance].server_time endTime:dic.str(@"response.info.maintain_endtime")];
            controller.view.frame = APP_FRAEM;
            controller.view.top = 20;
            [self.navigationController.view addSubview:controller.view];
        } else {
            if (msg.length > 0) {
                [self showToast:msg];
            }
        }
    } else {
        // 本地错误提示
        [self showToast:NETERROR duration:2];
    }
     */
}

- (void)netFailure {
    [self hideHUD];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.scrollview.mj_header endRefreshing];
    [self.scrollview.mj_footer endRefreshing];
    [self showMeg:NETTIP];
}

#pragma  mark - view
- (void)initScrollView {
    if (!self.scrollview) {
        self.scrollview = [[UIScrollView alloc]init];
    }
    self.scrollview.delegate = self;
    self.scrollview.backgroundColor = Theme.backgroundColor;
    [self.view addSubview:self.scrollview];
    [self addCenterView:self.scrollview];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.alwaysBounceVertical = YES;
}

#pragma mark -resfresh
- (void)scrollViewRrefresh {
    [self.scrollview.mj_header endRefreshing];
    [self.scrollview.mj_header beginRefreshing];
}

- (void)initData {
    
}

- (void)initUI {
    
}

- (void)commonJson {
    [self.scrollview.mj_header endRefreshing];
}

- (void)firstGetData {
    [self showHUD];
    self.current_page = @"1";
    [self commonJson];
}

@end
