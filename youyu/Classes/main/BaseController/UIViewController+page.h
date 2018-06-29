//
//  QTBaseViewController+page.h
//  qtyd
//
//  Created by stephendsw on 15/8/28.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (page)

#pragma mark - tab

/**
 *  首页
 */
- (void)toHome;

/**
 *  投资列表
 */
- (void)toInvest;

/**
 * 账户中心
 *
 */
- (void)toAccount;

//  更多
- (void)toMore;

/**
 *  借款
 */
- (void)toLoan;
#pragma mark - 注册

/**
 *  注册
 */
- (void)toRegister;

/**
 *  新注册
 */

//- (void)ToNewRegister;

#pragma mark - 登录

/**
 *  登录
 */
- (void)toLogin;

/**
 *  重新登录 删除密码
 */
- (void)relogin;

/**
 *  登录-账户中心
 */
- (BOOL)loginAccount;

- (void)loginToAccount;

/**
 *  需要登录的操作
 */
- (void)loginedAction:(void (^)())block;

/**
 *  请求超时后登录
 */
- (void)loginTimeout;

/**
 *  安全退出
 */
- (void)logout;


#pragma mark - 账户中心

/**
 *  智慧投
 */
- (void)toLazyInvest;

/**
 *  账户明细
 */
- (void)toDetail;

/**
 *  还款日历
 */
- (void)toSignIn;

/**
 *  实名认证
 */
- (void)toOpenSina;

/**
 *  实名绑卡
 */

- (void)toBindCard;

/**
 *  我的资料
 */
- (void)toMyInfo;

/**
 *  邀请好友
 *
 */
- (void)toFriendPage;

/**
 *  红包券
 *
 */
- (void)toUserReward;

/**
 *  我的礼券
 */

- (void)toMyTicket:(int)selectIndex;

/**
 *  年化券
 *
 */
- (void)toTicket;

/**
 *  安全中心
 *
 */
- (void)toSafe;

/**
 *  我的资金
 *
 */
- (void)toFund;

/**
 *  充值
 *
 */
- (void)toPay;

/**
 *  提现
 *
 */
- (void)toWithdrew;

- (void)toMallComment:(NSString *)oid ;

- (void)toOrderList ;

/**
 * 银行卡
 *
 */
- (void)toBank;

/**
 *  投资记录
 *
 */
- (void)toInvestRecord;

/**
 * 交易记录
 *
 */
- (void)toRecord;

/**
 *   新手大礼包
 *
 */
- (void)toGift;

/**
 *  计算器
 */
- (void)toCalc;

/**
 *  还款日程
 */
- (void)toRepaymentSchedule;

/**
 *  还款明细
 */
- (void)toRepaymentDetail;

/**
 *  投资订单
 *
 */
- (void)toTrendOrder;

/**
 *  活动专区
 */
- (void)toActivity;

// 我的消息
- (void)toWebMessage;

#pragma mark - vip

/**
 *  vip首页
 */
- (void)toVipHome;

/**
 *  专属客服
 */
- (void)toMyService;

/**
 *  预约状态
 */
- (void)toVipOrderList;

/**
 *  我要预约
 */
- (void)toVipOrder;

/**
 *  风险测试
 */
- (void)toRiskTest;

/**
 *  我的vip订制
 */
- (void)toMyVipList;

/**
 *  消息设置
 */
- (void)toMessageSet;

/**
 *  个人中心
 */
- (void)toAccountHome;

/**
 *  修改手机号
 */
- (void)toModifyPhone;

#pragma mark 积分商城

/**
 *  积分商城首页
 */
- (void)toMallHome;

/**
 *  积分
 */
- (void)toPointRecrod;

/**
 *  成长值
 */
- (void)toGrow;

#pragma mark - 安全中心中心

/**
 *  绑定邮箱
 */
- (void)toBandEmail;

/**
 *  支付密码
 */
- (void)toPayPwd;

/**
 *  收货地址
 */
- (void)toReceivingAddress;

/**
 *  登陆密码
 */
- (void)toSetLoginPwd;

//系统设置
- (void)toSetUp;

/**
 *  安全保障
 */
- (void)toSafety;

#pragma mark - 更多
- (void)toNoticePage;


/**
 *  设置客服
 */


@end
