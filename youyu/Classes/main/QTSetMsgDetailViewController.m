//
//  QTSetMsgDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSetMsgDetailViewController.h"
#import "QTSetMsgView.h"
#import "QTcheckBox.h"

@interface QTSetMsgDetailViewController ()<QTSetMsgViewDelegate>
@property (strong, nonatomic) IBOutlet UIView   *viewHead;
@property (weak, nonatomic) IBOutlet UILabel    *lbTitle;
@property (weak, nonatomic) IBOutlet UISwitch   *switchBtn;

@end

@implementation QTSetMsgDetailViewController
{
    /**
     *  是否开启至少一条数据
     */
    BOOL hasOnData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(commonJson)];

    self.navigationItem.rightBarButtonItem = btn;
    self.titleView.title = self.name;
}

- (void)initUI {
    [self initScrollView];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    [stack addView:self.viewHead];

    [stack addLineForHeight:10];

    QTSetMsgView *item1 = [[QTSetMsgView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 120)];
    item1.title = @"资金变化";
    item1.item = @{@"201":@"收到还款", @"202":@"提现成功", @"203":@"充值成功", @"204":@"投资成功"};
    item1.delegate = self;
    [stack addView:item1];

    QTSetMsgView *item2 = [[QTSetMsgView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    item2.title = @"到期提醒";
    item2.delegate = self;
    item2.item = @{@"301":@"红包到期", @"302":@"年化劵到期"};
    [stack addView:item2 margin:UIEdgeInsetsMake(5, 0, 0, 0)];

    QTSetMsgView *item3 = [[QTSetMsgView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    item3.title = @"安全通知";
    item3.delegate = self;
    item3.item = @{@"401":@"登录密码修改", @"402":@"支付密码修改"};

    if ([self.type isEqualToString:@"短信通知"]) {
        [stack addView:item3 margin:UIEdgeInsetsMake(5, 0, 0, 0)];
    }

    QTSetMsgView *item4 = [[QTSetMsgView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    item4.title = @"其他";
    item4.delegate = self;

    if ([self.type isEqualToString:@"537"]) {
        item4.item = @{@"601":@"生日礼包(默认)"};
        item4.userInteractionEnabled = NO;
    }

    if ([self.type isEqualToString:@"536"]) {
        item4.item = @{@"501":@"系统公告", @"502":@"活动公告"};
    } else {
        item4.item = @{@"601":@"生日礼包"};
    }

    [stack addView:item4 margin:UIEdgeInsetsMake(5, 0, 0, 0)];

    if ([self.type isEqualToString:@"微信推送"]) {
        item4.hidden = YES;
    }

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];

    [self.switchBtn valueChange:^(id value) {
        if (self.switchBtn.on) {
            if (!hasOnData) {
                item1.isSelectdAll = YES;
                item2.isSelectdAll = YES;
                item3.isSelectdAll = YES;
                item4.isSelectdAll = YES;
            }
        } else {
            item1.isSelectdAll = NO;
            item2.isSelectdAll = NO;
            item3.isSelectdAll = NO;
            item4.isSelectdAll = NO;
        }
    }];
}

- (void)initData {
    self.isLockPage = YES;
    self.lbTitle.text = self.name;
    [self commonJsonGet];
}

- (NSString *)getLongID:(NSString *)shortid {
    return [self.type stringByAppendingString:shortid];
}

- (void)setMsgView:(QTSetMsgView *)view {
    int i = 0;

    for (UIView *item in self.view.allSubviews) {
        if ([item isKindOfClass:[QTcheckBox class]]) {
            if (((QTcheckBox *)item).selected) {
                i += 1;
                hasOnData = YES;
                self.switchBtn.on = YES;
            }
        }
    }

    if (i == 0) {
        hasOnData = NO;
        self.switchBtn.on = NO;
    }
}

#pragma mark - json
- (void)commonJson {
    [self showHUD];
    NSMutableString *attstr = [NSMutableString new];

    for (UIView *item in self.view.allSubviews) {
        if ([item isKindOfClass:[QTcheckBox class]]) {
            if (![NSString isEmpty:((QTcheckBox *)item).contentID]) {
                if (((QTcheckBox *)item).selected) {
                    [attstr appendString:[self getLongID:((QTcheckBox *)item).contentID]];
                    [attstr appendString:@","];
                }
            }
        }
    }

    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"settings"] = attstr;
    dic[@"channel"] = self.type;
    [service post:@"message_postSettingsPerChannel" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [self showToast:@"保存成功" done:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)commonJsonGet {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"channel"] = self.type;
    [service post:@"Message_settingsPerChannel" data:dic complete:^(NSDictionary *value) {
        NSArray *idlist = value.arr(@"settings");

        for (NSString *str in idlist) {
            for (UIView *item in self.view.allSubviews) {
                if ([item isKindOfClass:[QTcheckBox class]]) {
                    if (![NSString isEmpty:((QTcheckBox *)item).contentID]) {
                        NSString *contentid = [self getLongID:((QTcheckBox *)item).contentID];

                        if ([contentid isEqualToString:str]) {
                            ((QTcheckBox *)item).selected = YES;
                        }
                    }
                }
            }
        }
    }];
}

@end
