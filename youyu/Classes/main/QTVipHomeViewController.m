//
//  QTVipHomeViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/17.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVipHomeViewController.h"

#import "QTVipView.h"

#define  TEXT   @[@"我要预约", @"专属客服", @"我的VIP订制", @"查看预约状态"]

#define IMAGE   @[@"icon_vip_shalou", @"icon_vip_kefu", @"icon_vip_rank", @"icon_vip_search"]

@implementation QTVipHomeViewController
{
    BOOL        isTest;
    DWrapView   *wrap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"VIP订制";
    self.navigationItem.rightBarButtonItem=nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    [self toAccount];
    return NO;
}

- (void)initUI {
    [self initScrollView];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"custom_focus.jpg"]];

    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.height = APP_WIDTH / 750.0 * 417.0;
    [stack addView:imageview];

    wrap = [[DWrapView alloc]initWidth:APP_WIDTH columns:3];
    wrap.backgroundColor = Theme.backgroundColor;
    wrap.subHeight = APP_WIDTH / 3.0f - 30;
    NSArray *textArray = TEXT;
    NSArray *pages = @[

        @"toVipOrder",                              // 我要预约
        @"toMyService",                             // 专属客服
        @"toMyVipList",                             // 我的vip订制
        @"toVipOrderList"                           // 查看预约状态

    ];

    for (int i = 0; i < TEXT.count; i++) {
        QTVipView *item = [QTVipView viewNib];
        item.radioWidth = 30;
        item.width = wrap.subHeight;
        item.height = wrap.subHeight;
        [item setText:textArray[i] img:IMAGE[i]];
        [item addTapGesture:^(id value) {
            SuppressPerformSelectorLeakWarning(
                [self performSelector:NSSelectorFromString(pages[i])]);
        }];

        item.layer.borderColor = [Theme borderColor].CGColor;
        item.layer.borderWidth = 0.5;

        [wrap addView:item margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    }

    [stack addView:wrap];

    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor darkGrayColor];

    NSMutableAttributedString *attsrt = [[NSMutableAttributedString alloc]initWithString:@"VIP订制产品是有余金服为平台V7用户“私人订制”的债权项目，一对一的专属服务，更高更稳的理财回报，短期长线，多种配置方案随心打造！"];
    [attsrt setFont:[UIFont systemFontOfSize:12]];
    [attsrt setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 8;
    }];

    label.attributedText = attsrt;

    [stack addView:label margin:UIEdgeInsetsMake(20, 16, 20, 16)];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.isLockPage = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self commonJson];
}

#pragma mark - json

- (void)commonJson {
    [service post:@"puser_home" data:nil complete:^(NSDictionary *value) {
        [[GVUserDefaults  shareInstance] saveLocal];

        NSInteger level = [value.str(@"user_level") stringByReplacingOccurrencesOfString:@"V" withString:@""].integerValue;

        if (level != 7) {
            QTVipView *item1 = wrap.subviews[0];
            [item1 setDisable];
            [item1 addTapGesture:^{
                [self showToast:@"VIP订制为V7用户专享特权,升级成为V7会员即可拥有更多会员专享特权哦!" duration:2];
            }];

            if (level < 5) {
                QTVipView *item2 = wrap.subviews[1];
                [item2 setDisable];
                [item2 addTapGesture:^{
                    [self showToast:@"V5及以上会员可享此特权，随时随地解答您的疑问。" duration:2];
                }];
            }

            QTVipView *item3 = wrap.subviews[2];
            [item3 setDisable];
            [item3 addTapGesture:^{
                [self showToast:@"VIP订制为V7用户专享特权,升级成为V7会员即可拥有更多会员专享特权哦!" duration:2];
            }];

            QTVipView *item4 = wrap.subviews[3];
            [item4 setDisable];
            [item4 addTapGesture:^{
                [self showToast:@"VIP订制为V7用户专享特权,升级成为V7会员即可拥有更多会员专享特权哦!" duration:2];
            }];
        } else {
            [service post:@"vipcustom_index" data:nil complete:^(NSDictionary *value) {
                if (value.i(@"apply_num") >= 3) {
                    [wrap.subviews.firstObject addTapGesture:^{
                        [self showToast:@"处于审核状态中的预约申请最多3个" duration:3];
                    }];
                }
            }];
        }
    }];
}

@end
