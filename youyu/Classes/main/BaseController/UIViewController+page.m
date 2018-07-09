//
//  QTBaseViewController+page.m
//  qtyd
//
//  Created by stephendsw on 15/8/28.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "UIViewController+page.h"
#import "WMPageController.h"
#import "SystemConfigDefaults.h"
#import "QTChangePwdViewController.h"
#import "QTRecordViewController.h"
#import "QTBankViewController.h"
#import "QTSafeViewController.h"
#import "QTInvestRecordViewController.h"
#import "QTallMoneyViewController.h"
#import "QTNewGiftViewController.h"
#import "QTRegisterViewController.h"
#import "QTInvestViewController.h"
#import "QTOpenSinaViewController.h"
#import "QTloginViewController.h"
#import "QTIncomeController.h"
#import "QTPageViewController.h"
#import "QTPayResetPwdViewController.h"
#import "QTBandEmailViewController.h"
#import "QTResetPwdViewController.h"
#import "QTAddAddressController.h"
#import "QTAddressController.h"
#import "QTMyInfoViewController.h"
#import "QTPointRecordViewController.h"
#import "QTGrowViewController.h"
#import "QTWebViewController.h"
#import "QTSignInViewController.h"
#import "QTRepaymentDetailViewController.h"
#import "QTRepaymentScheduleViewController.h"
#import "QTVipHomeViewController.h"
#import "QTVipOrderListViewController.h"
#import "QTVipOrderViewController.h"
#import "QTMyServiceViewController.h"
#import "QTMyVipListViewController.h"
#import "QTLoanViewController.h"
#import "QTAnnouncementViewController.h"
#import "CreditWebViewController.h"
#import "CreditWebViewController.h"
#import "QTPayResetPwdViewController.h"
#import "QTSinaWithdrewViewController.h"
#import "QTallMoneyViewController.h"
#import "QTMyTicketViewController.h"
#import "QTSetMsgViewController.h"
#import "QTAccuntHomeViewController.h"
#import "QTActivityListViewController.h"
#import "QTDetailsViewController.h"
#import "QTMessageViewController.h"
#import "QTNoticePageViewController.h"
#import "QTPayViewController.h"
#import "QTOrderListViewController.h"
#import "QTCommentViewController.h"
#import "QTAboutTableViewController.h"
#import "QTFeedbackViewController.h"
#import "HRSetUpViewController.h"
#import "HRModifyPhoneOldViewController.h"
#import "QTMyViewController.h"
#import "HRRegisterViewController.h"
#import "HRLoginViewController.h"
#import "HRBindBankViewController.h"
#import "HSDSafeViewController.h"
#import "YYInvestRecordController.h"


@implementation UIViewController (page)

#pragma mark - tab

- (void)toHome {
    self.navigationController.tabBarController.selectedIndex = HOME_TAG;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toInvest {
    self.navigationController.tabBarController.selectedIndex = TENDER_TAG;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toAccount {
    self.navigationController.tabBarController.selectedIndex = MY_TAG;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//  更多
- (void)toMore {
    UIViewController *controller = [UIViewController storyboard:@"moreStoryboard" viewid:@"more"];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  借款
 */
- (void)toLoan {
    UIViewController *controller = [QTLoanViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 安全中心中心

/**
 *  绑定邮箱
 */
- (void)toBandEmail {
    UIViewController *controller = [QTBandEmailViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  收货地址
 */
- (void)toReceivingAddress {
    UIViewController *controller = [QTAddressController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  登陆密码
 */
- (void)toSetLoginPwd {
    if ([GVUserDefaults shareInstance].isLogin) {
        UIViewController *controller = [QTChangePwdViewController controllerFromXib];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UIViewController *controller = [QTResetPwdViewController controllerFromXib];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


/**
 *  支付密码
 */
- (void)toPayPwd {
    UIViewController *controller = [QTPayResetPwdViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 账户中心

/**
 *  智慧投
 */
- (void)toLazyInvest {
    QTWebViewController * controller=[QTWebViewController controllerFromXib];
    controller.isNeedLogin=YES;
    controller.url=WEB_URL(@"/account/lazy_list");
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  账户明细
 */
- (void)toDetail {
//    QTDetailsViewController *controller = [QTDetailsViewController controllerFromXib];
//    [NAVIGATION pushViewController:controller animated:YES];
    //业务调整，直接跳转到交易明细
    [self toRecord];
}

/**
 *  还款日历
 */
- (void)toSignIn {
    QTSignInViewController *controller = [QTSignInViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  我的资料
 */
- (void)toMyInfo {
    UIViewController *controller = [QTMyInfoViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

// 邀请好友
- (void)toFriendPage {
    QTWebViewController *controller = [QTWebViewController controllerFromXib];
    controller.isNeedLogin = YES;
    controller.url = WEB_URL(@"/user_center/invite");
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  我的礼券
 */
- (void)toMyTicket:(int)selectIndex {
    QTMyTicketViewController *pageController = [[QTMyTicketViewController alloc] init];
    [self.navigationController pushViewController:pageController animated:YES];
}

// 红包券
- (void)toUserReward {
    [self toMyTicket:1];
}

// 年化券
- (void)toTicket {
    [self toMyTicket:2];
}

// 计算器
- (void)toCalc {
    QTIncomeController *controller = [QTIncomeController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  我的资金
 *
 */
- (void)toFund {
    QTallMoneyViewController *controller2 = [QTallMoneyViewController controllerFromXib];
    [self.navigationController pushViewController:controller2 animated:YES];
}

// 充值
- (void)toPay {
    UIViewController *controller = [QTPayViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)toMallComment:(NSString *)oid {
    QTCommentViewController *controller = [QTCommentViewController controllerFromXib];
    controller.orderID = oid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toOrderList {
    QTOrderListViewController *controller1 = [QTOrderListViewController controllerFromXib];
    controller1.status = @"";

    QTOrderListViewController *controller2 = [QTOrderListViewController controllerFromXib];
    controller2.status = @"0";
    
    QTOrderListViewController *controller3 = [QTOrderListViewController controllerFromXib];
    controller3.status = @"1";
    
    QTOrderListViewController *controller4 = [QTOrderListViewController controllerFromXib];
    controller4.status = @"2";
    
    NSArray *controllers = @[controller1, controller2, controller3, controller4];
    NSArray *titles = @[@"全部", @"待发货", @"待收货", @"待评价"];
    
    QTPageViewController *pageController = [[QTPageViewController alloc]initWithViewControllerClasses:controllers andTheirTitles:titles];
    pageController.type = 2;
    [QTTheme pageWMControlStyle:pageController];
    pageController.menuItemWidth = APP_WIDTH / 4;
    pageController.titleView.title = @"我的订单";
    [self.navigationController pushViewController:pageController animated:YES];
}

// 提现
- (void)toWithdrew {
    UIViewController *controller = [QTSinaWithdrewViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

// 银行卡
- (void)toBank {
    UIViewController *controller = [QTBankViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

//  投资记录
- (void)toInvestRecord {
    YYInvestRecordController *controller = [[YYInvestRecordController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

//  交易记录
- (void)toRecord {
    UIViewController *controller = [QTRecordViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

// 投资订单
- (void)toTrendOrder {
    QTRecordViewController *controller = [QTRecordViewController controllerFromXib];

    controller.isOrder = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 新手大礼包
- (void)toGift {
    UIViewController *controller = [QTNewGiftViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  实名认证
 */
- (void)toOpenSina {
    QTOpenSinaViewController *controller = [QTOpenSinaViewController controllerFromXib];

    controller.isGoBack = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  实名绑卡
 */

- (void)toBindCard{
    HRBindBankViewController *controller = [HRBindBankViewController controllerFromXib];
    controller.isGoBack = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 安全中心
- (void)toSafe {
    UIViewController *controller = [QTSafeViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  还款日程
 */
- (void)toRepaymentSchedule {
    QTRepaymentScheduleViewController *controller = [QTRepaymentScheduleViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  还款明细
 */
- (void)toRepaymentDetail {
    QTRepaymentDetailViewController *controller = [QTRepaymentDetailViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}


/**
 *  消息设置
 */
- (void)toMessageSet {
    QTSetMsgViewController *controller = [QTSetMsgViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  个人中心
 */
- (void)toAccountHome {
    QTAccuntHomeViewController *controller = [QTAccuntHomeViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toActivity {
    QTActivityListViewController *controller = [QTActivityListViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

// 我的消息
- (void)toWebMessage {
    QTMessageViewController *controller1 = [QTMessageViewController controllerFromXib];

    controller1.type = @"0";
    QTMessageViewController *controller2 = [QTMessageViewController controllerFromXib];
    controller2.type = @"2";

    QTMessageViewController *controller3 = [QTMessageViewController controllerFromXib];
    controller3.type = @"1";

    QTMessageViewController *controller4 = [QTMessageViewController controllerFromXib];
    controller4.type = @"3";

    NSArray *controllers = @[controller1, controller2, controller3, controller4];
    NSArray *titles = @[@"全部", @"系统公告", @"账户通知", @"活动通知"];

    QTPageViewController *pageController = [[QTPageViewController alloc]initWithViewControllerClasses:controllers andTheirTitles:titles];
    [QTTheme pageWMControlStyle:pageController];
    pageController.menuItemWidth = APP_WIDTH / 4;

    pageController.titleView.title = @"我的消息";

    [self.navigationController pushViewController:pageController animated:YES];
}

#pragma mark - vip

/**
 *  我的vip订制
 */
- (void)toMyVipList {
    QTMyVipListViewController *controller = [QTMyVipListViewController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  vip首页
 */
- (void)toVipHome {
    QTVipHomeViewController *controller = [QTVipHomeViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  专属客服
 */
- (void)toMyService {
    QTMyServiceViewController *controller = [QTMyServiceViewController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  预约状态
 */
- (void)toVipOrderList {
    QTVipOrderListViewController *controller = [QTVipOrderListViewController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  我的预约
 */
- (void)toVipOrder {
    QTVipOrderViewController *controller = [QTVipOrderViewController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  风险测试
 */
- (void)toRiskTest {
    QTWebViewController *controller = [QTWebViewController controllerFromXib];

    controller.url = WEB_URL(@"/account/vip_survey");
    controller.isNeedLogin = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toPointRecrod {
    QTPointRecordViewController *controller = [QTPointRecordViewController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)toGrow {
    QTGrowViewController *controller = [QTGrowViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}
//修改手机号
- (void)toModifyPhone{
    HRModifyPhoneOldViewController *controller = [HRModifyPhoneOldViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - 注册
- (void)toRegister {
    if ([self isKindOfClass:[QTRegisterViewController class]]) {
        return;
    }
    QTRegisterViewController *controller = [QTRegisterViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}


//- (void)ToNewRegister{
//    if ([self isKindOfClass:[HRLoginViewController class]]) {
//        return;
//    }
//    HRLoginViewController *controller = [HRLoginViewController controllerFromXib];
//    [self.navigationController pushViewController:controller animated:YES];
//}

#pragma mark - 登录

////////////// 私有  //////////////

- (BOOL)login:(void (^)(QTloginViewController *controller))block {
    BOOL isLogin = [GVUserDefaults shareInstance].isLogin;
    if (isLogin) {
        return YES;
    } else {
        if ([self isKindOfClass:[QTloginViewController class]]) {
            return YES;
        }
        QTloginViewController *controller = [QTloginViewController controllerFromXib];
        if (block) {
            block(controller);
        }
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }
}


- (void)toLogin {
    QTloginViewController *controller = [QTloginViewController controllerFromXib];
    controller.isBackHome = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//- (void)toNewLogin {
//    USER_DATA.isLogin = NO;
//    HRLoginViewController *controller = [HRLoginViewController controllerFromXib];
//    [self.navigationController pushViewController:controller animated:YES];
//}


- (void)loginedAction:(void (^)())block {
    if ([GVUserDefaults  shareInstance].isLogin) {
        block();
    } else {
        [self login:^(QTloginViewController *controller) {
            [controller backAction:^{
                block();
            }];
        }];
    }
}

- (BOOL)loginAccount {
    return [self login:^(QTloginViewController *controller) {
        controller.isLoginedToAccout = YES;
    }];
}

- (void)loginToAccount {
    [self login:^(QTloginViewController *controller) {
        controller.isLoginedToAccout = YES;
        controller.isBackHome = YES;
        controller.isBackToSecondPage = NO;
    }];
}

- (void)loginTimeout {
    [self login:^(QTloginViewController *controller) {
        controller.isLoginedToAccout = NO;
        controller.isBackHome = YES;
        controller.isBackToSecondPage = NO;
    }];
}

// 重新登陆 删除密码
- (void)relogin {
    [[GVUserDefaults shareInstance] clear];
    [self login:^(QTloginViewController *controller) {
        controller.isBackToSecondPage = YES;
        controller.isLoginedToAccout = NO;
        controller.isBackHome = NO;
    }];
}

// 安全退出
- (void)logout {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoreUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStorePws];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *userlist = [[NSMutableArray alloc] initWithArray:[SystemConfigDefaults sharedInstance].userList];
    [SystemConfigDefaults sharedInstance].userList = userlist;
    [[GVUserDefaults shareInstance] clear];
    [self showToast:@"已安全退出" done:^{
        self.navigationController.tabBarController.selectedIndex = HOME_TAG;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - 更多
- (void)toNoticePage {
    QTNoticePageViewController *controller = [QTNoticePageViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)toMallHome {
    CreditWebViewController *controller = [[CreditWebViewController alloc]initWithUrl:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

//公司简介
//- (void)toCompany{
//    QTWebViewController *controller = [QTWebViewController controllerFromXib];
//    controller.url = WEB_URL(@"/welcome/about");
//    controller.title = @"公司简介";
//    [self.navigationController pushViewController:controller animated:YES];
//}

//联系我们
//- (void)telephoneToUs{
//    QTAboutTableViewController *controller = [QTAboutTableViewController controllerFromXib];
//    [self.navigationController pushViewController:controller animated:YES];
//}

//意见反馈
//- (void)toFeedback{
//    [self loginedAction:^{
//        QTFeedbackViewController *controller = [QTFeedbackViewController controllerFromXib];
//        [self.navigationController pushViewController:controller animated:YES];
//    }];
//}

//慧员问答
- (void)toQA {
    QTWebViewController *controller = [QTWebViewController controllerFromXib];
    controller.url = WEB_URL(@"/article/article_faq");
    [self.navigationController pushViewController:controller animated:YES];
}

//系统设置
- (void)toSetUp {
    HRSetUpViewController *controller = [HRSetUpViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

//安全保障
- (void)toSafety {
    HSDSafeViewController *safeVC = [HSDSafeViewController controllerFromXib];
    [self.navigationController pushViewController:safeVC animated:YES];
}

@end
