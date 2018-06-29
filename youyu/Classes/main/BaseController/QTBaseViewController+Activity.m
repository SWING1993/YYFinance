//
//  QTBaseViewController+Activity.m
//  qtyd
//
//  Created by stephendsw on 16/1/6.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBaseViewController+Activity.h"
#import "UIViewController+Share.h"
#import "QTWebViewController.h"

@implementation QTBaseViewController (Activity)

- (BOOL)webToAppPage:(NSString *)url {
    if ([url containsString:@"app:"]) {
        if ([url isEqualToString:@"app:borrow_list"]) {
            // 投资列表
            [self toInvest];
            return NO;
        }
        else if ([url isEqualToString:@"app:recordOrder"]) {
            //
            [self toTrendOrder];
            return NO;
        }
        else if ([url isEqualToString:@"app:login"]) {
            //登录
            [self toLogin];
            return NO;
        }
        else if ([url isEqualToString:@"app:pay"]) {
            // 充值
            [self toPay];
            return NO;
        }
        else if ([url isEqualToString:@"app:withdrew"]) {
            // 提现
            [self toWithdrew];
            return NO;
        } else if ([url isEqualToString:@"app:home"]) {
            // 首页
            [self toHome];
            return NO;
        } else if ([url isEqualToString:@"app:register"]) {
            // 注册
            [self toRegister];
            return NO;
        } else if ([url isEqualToString:@"app:account"]) {
            // 账户中心
            [self toAccount];
            return NO;
        } else if ([url isEqualToString:@"app:Friend"]) {
            // 邀请好友
            [self toFriendPage];
            return NO;
        } else if ([url isEqualToString:@"app:userReward"]) {
            // 红包券
            [self toUserReward];
            return NO;
        } else if ([url isEqualToString:@"app:ticket"]) {
            // 年化倦
            [self toTicket];
            return NO;
        } else if ([url isEqualToString:@"app:safe"]) {
            // 安全中心
            [self toSafe];
            return NO;
        } else if ([url isEqualToString:@"app:fund"]) {
            // 我的资金
            [self toFund];
            return NO;
        } else if ([url isEqualToString:@"app:banklist"]) {
            // 银行卡列表
            [self toBank];
            return NO;
        } else if ([url isEqualToString:@"app:investRecord"]) {
            // 投资记录
            [self toInvestRecord];
            return NO;
        } else if ([url isEqualToString:@"app:record"]) {
            // 交易记录
            [self toRecord];
            return NO;
        } else if ([url isEqualToString:@"app:gift"]) {
            // 新手大礼包
            [self toGift];
            return NO;
        } else if ([url isEqualToString:@"app:calc"]) {
            // 计算器
            [self toCalc];
            return NO;
        } else if ([url isEqualToString:@"app:email"]) {
            // 绑定邮箱
            [self toBandEmail];
            return NO;
        } else if ([url isEqualToString:@"app:paypwd"]) {
            // 支付密码
            [self toPayPwd];
            return NO;
        } else if ([url isEqualToString:@"app:receivingAddress"]) {
            // 收货地址
            [self toReceivingAddress];
            return NO;
        } else if ([url isEqualToString:@"app:setLoginPwd"]) {
            // 登陆密码
            [self toSetLoginPwd];
            return NO;
        } else if ([url isEqualToString:@"app:openSina"]) {
            // 实名认证
            [self toOpenSina];
            return NO;
        } else if ([url isEqualToString:@"app:myinfo"]) {
            // 我的资料
            [self toMyInfo];
            return NO;
        } else if ([url isEqualToString:@"app:mallhome"]) {
            // 商城首页
            [self toMallHome];
            return NO;
        } else if ([url isEqualToString:@"app:vipHome"]) {
            // VIP首页
            [self toVipHome];
            return NO;
        } else if ([url isEqualToString:@"app:toPointRecrod"]) {
            // 积分
            [self toPointRecrod];
            return NO;
        } else if ([url isEqualToString:@"app:toGrow"]) {
            // 成长值
            [self toGrow];
            return NO;
        } else if ([url isEqualToString:@"app:toSignIn"]) {
            // 签到日历
            [self toSignIn];
            return NO;
        } 
        else if ([url isEqualToString:@"app:back"]) {
            // 返回
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }
        
        else if ([url containsString:@"app:share"]) {
            // 分享

            NSString *list = [url stringByReplacingOccurrencesOfString:@"app:share:" withString:@""];
            list = [list getDecodeUrl];

            NSDictionary *dic = [NSDictionary dictionaryWithJsonString:list];
            [self share:dic];
            return NO;
        } else {
            return YES;
        }
    } else if ([url containsString:@"apph5:"]) {
        QTWebViewController *controller = [QTWebViewController controllerFromXib];
        controller.url = [url stringByReplacingOccurrencesOfString:@"apph5:" withString:@""];
        controller.isNeedLogin = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    } else {
        return YES;
    }
}

@end
