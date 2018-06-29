//
//  MainTabBarController.m
//  youyu
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YY_ActivityNoticeController.h"
#import "YY_PlatformNoticeController.h"
#import "YY_MediaController.h"
#import "YY_MyController.h"
#import "GVUserDefaults.h"
#import "QTMyViewController.h"
#import "QTInvestViewController.h"
#import "QTHomeViewController.h"
#import "QTMoreTableViewController.h"
#import "HRFindViewController.h"
#import "QTPageViewController.h"
#import "QTBrandViewController.h"
#import "HSDInvestmentViewController.h"
#import "YYInvestListViewController.h"
#import "HSDAnnouncementViewController.h"
#import "QTAnnouncementViewController.h"

#import "MainTabBarController.h"
#import "YYIndexViewController.h"
#import "YYFinanceController.h"
#import "YYActivityListController.h"

#import <EAIntroView/EAIntroView.h>

@interface MainTabBarController ()<EAIntroDelegate>

@property (nonatomic, strong) EAIntroView *introView;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *key = @"kShowIntroVersion";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:key];
    if ([value isEqualToString:kVersion]) {
        [self createTabBar];
    } else {
        [self showIntroWithCrossDissolve];
        [defaults setObject:kVersion forKey:key];
        [defaults synchronize];
    }
}

- (void)createTabBar {
    NSArray<NSString *> *titleList = @[@"首页",
                                       @"理财",
                                       @"动态",
                                       @"我的"];
    
    NSArray<NSNumber *> *tagList = @[@(HOME_TAG),
                                     @(TENDER_TAG),
                                     @(MORE_TAG),
                                     @(MY_TAG)];
    
    NSArray<NSString *> *imageList = @[@"tabbar_home",
                                       @"tabbar_hot",
                                       @"tabbar_discover",
                                       @"tabbar_account"];
    
    NSArray<NSString *> *selectedImageList = @[@"tabbar_home_selected",
                                               @"tabbar_hot_selected",
                                               @"tabbar_discover_selected",
                                               @"tabbar_account_selected"];
    
    YYIndexViewController * homeController = [[YYIndexViewController alloc] init];
    homeController.hidesBottomBarWhenPushed = NO;
    QMUINavigationController *homeNavController = [[QMUINavigationController alloc] initWithRootViewController:homeController];

//    YYInvestListViewController *xxx = [[YYInvestListViewController alloc]init];
//    investController.hidesBottomBarWhenPushed = NO;
//    UINavigationController *investNavController = [[UINavigationController alloc] initWithRootViewController:investController];
    
    YYFinanceController *investController = [[YYFinanceController alloc]initWithStyle:UITableViewStyleGrouped];
    investController.hidesBottomBarWhenPushed = NO;
    QMUINavigationController *investNavController = [[QMUINavigationController alloc] initWithRootViewController:investController];

//    NSArray *titles = @[@"活动公告",@"媒体报道",@"平台公告"];
//    NSMutableArray *controllerArr = [NSMutableArray array];
//    NSArray *controlles = @[[YY_ActivityNoticeController controllerFromXib],[YY_MediaController controllerFromXib],[YY_PlatformNoticeController controllerFromXib]];
//    for (UIViewController *vc in controlles) {
//        [controllerArr addObject:vc];
//    }

    YYActivityListController *activityController = [[YYActivityListController alloc] initWithStyle:UITableViewStyleGrouped];
    activityController.hidesBottomBarWhenPushed = NO;
    QMUINavigationController *activityNavController = [[QMUINavigationController alloc] initWithRootViewController:activityController];

    YY_MyController *accountController = [YY_MyController controllerFromXib];
    accountController.hidesBottomBarWhenPushed = NO;
    QMUINavigationController *accountNavController = [[QMUINavigationController alloc] initWithRootViewController:accountController];

    NSArray<UIViewController *> *controllerList = @[homeNavController,
                                                    investNavController,
                                                    activityNavController,
                                                    accountNavController];
    
    for (int i = 0; i < controllerList.count; i++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleList[i] image:[[UIImage imageNamed:imageList[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImageList[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        controllerList[i].tabBarItem = item;
        controllerList[i].tabBarItem.tag = [tagList[i] intValue];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:kColorTextGray} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:UIColorMake(255, 90, 0)} forState:UIControlStateSelected];
    }
    
    self.viewControllers = controllerList;
    self.selectedIndex = HOME_TAG;
}

- (void)showIntroWithCrossDissolve {

    NSArray *bgImages = @[@"IntroPageBg1",@"IntroPageBg2",@"IntroPageBg3"];
    NSArray *titles = @[@"银行存管",@"风控完善",@"新手福利"];
    NSArray *descs = @[@"资金安全 实力雄厚",@"六层保障 理财安心",@"688元新手标 18%新手标"];
    NSArray *tintColors = @[UIColorMake(255, 122, 12),UIColorMake(107, 191, 255),UIColorMake(240, 56, 56)];
    NSMutableArray *pages = [NSMutableArray arrayWithCapacity:bgImages.count];
    for (NSInteger i = 0; i < bgImages.count; i ++) {
        UIView *viewForPage = [[UIView alloc] initWithFrame:kScreenBounds];
        UILabel *titleLabel = [[UILabel alloc] initWithFont:UIFontBoldMake(30) textColor:tintColors[i]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text =  titles[i];
        [viewForPage addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-kScaleFrom_iPhone6_Desgin(160));
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFont:UIFontLightMake(20) textColor:tintColors[i]];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.text =  descs[i];
        [viewForPage addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        if (i == bgImages.count - 1) {
            QMUIButton *btn = [[QMUIButton alloc] init];
            btn.backgroundColor = UIColorMake(255, 90, 0);
            YYViewBorderRadius(btn, 20, CGFLOAT_MIN, kColorClear);
            btn.titleLabel.font = UIFontBoldMake(17);
            [btn setTitle:@"马上领取" forState:UIControlStateNormal];
            [btn setTitleColor:kColorWhite forState:UIControlStateNormal];
            [viewForPage addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(125, 40));
                make.centerX.mas_equalTo(viewForPage);
                make.top.mas_equalTo(subTitleLabel.mas_bottom);
            }];
            
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//                kTipAlert(@"马上领取？？？");
                [self.introView hideWithFadeOutDuration:0.3];
            }];
            
            QMUIButton *closeBtn = [[QMUIButton alloc] init];
            [closeBtn setImage:UIImageMake(@"introClose") forState:UIControlStateNormal];
            [viewForPage addSubview:closeBtn];
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(26, 26));
                make.right.mas_equalTo(-30);
                make.top.mas_equalTo(30);
            }];
            @weakify(self)
            [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self)
                [self.introView hideWithFadeOutDuration:0.3];
            }];
        }
        
        EAIntroPage *page = [EAIntroPage pageWithCustomView:viewForPage];
        page.bgImage = UIImageMake(bgImages[i]);
        [pages addObject:page];
    }
    
    self.introView = [[EAIntroView alloc] initWithFrame:kScreenBounds andPages:pages];
    self.introView.skipButton.hidden = YES;
    self.introView.swipeToExit = NO;
    self.introView.pageControlY = 42.f;
    [self.introView setDelegate:self];
    [self.introView showInView:self.view animateDuration:0.3];
}

#pragma mark - EAIntroView delegate
- (void)introWillFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    [self createTabBar];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
