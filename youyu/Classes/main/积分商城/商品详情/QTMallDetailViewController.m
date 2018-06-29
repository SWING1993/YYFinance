//
//  QTMallDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMallDetailViewController.h"
#import "QTBuyGoodViewController.h"

#import "QTExchangeListViewController.h"
#import "QTWebViewController.h"

#import "NSDictionary+Order.h"

@interface QTMallDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView   *viewDetail;
@property (weak, nonatomic) IBOutlet UILabel    *lbDetail;
@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel    *lbPrice;

@property (strong, nonatomic) IBOutlet UIView *viewTip;

@property (weak, nonatomic) IBOutlet UILabel *lbHas;

@property (weak, nonatomic) IBOutlet UILabel    *lbExchange;
@property (weak, nonatomic) IBOutlet UILabel    *lbClick;
@property (strong, nonatomic) IBOutlet UIView   *viewBottom;
@property (weak, nonatomic) IBOutlet PKYStepper *stepper;

@property (weak, nonatomic) IBOutlet UILabel *lbBuyTIp;

@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;

@property (nonatomic, strong) NSDictionary *goodInfo;

@end

@implementation QTMallDetailViewController
{
    AdView *adviewContent;

    UILabel *lbSummary;

    DTimer *time;
}
@synthesize sumbitBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUI {
    [self initScrollView];
    [self setRefreshScrollView];

    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];
    stack.backgroundColor = [UIColor whiteColor];

    adviewContent = [[AdView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_WIDTH / 320 * 200)];
    adviewContent.placeHoldImage = [UIImage imageNamed:@"mall_default"];
    [adviewContent setPageControlShowStyle:UIPageControlShowStyleCenter];
    [QTTheme pageControlStyle:adviewContent.pageControl];

    [stack addView:adviewContent];
    [stack addLineForHeight:1 color:[Theme borderColor]];

    [stack addView:self.lbDetail margin:UIEdgeInsetsMake(8, 16, 0, 16)];
    [stack addView:self.viewDetail];
    [stack addView:self.viewTip];
    self.viewTip.backgroundColor = [Theme backgroundColor];

    lbSummary = [[UILabel alloc]init];
    [stack addView:lbSummary margin:UIEdgeInsetsMake(8, 16, 8, 16)];

    [stack addView:self.viewBottom];

    self.sumbitBtn = [stack addRowButtonTitle:@"" click:^(id value) {}];
    [self.sumbitBtn removeFromSuperview];
   
    [stack addLineForHeight:8];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    };
    self.stepper.value = 1;
    [QTTheme stepperStyle:self.stepper];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self firstGetData];
}

- (UIView *)WMPageControllerAddBottomView:(WMPageController *)pagec {
    return self.sumbitBtn;
}

#pragma  mark json

- (void)setAdView:(NSDictionary *)value {
    NSArray *picList = [value.arr(@"img_list") getArrayForKey:@"img_info.img_url_full"];

    [adviewContent setimageLinkURL:picList];
}

- (void)setDetail:(NSDictionary *)value {
    //
    NSString                    *content = [NSString stringWithFormat:@"%@ ", value.str(@"good_info.title")];
    NSMutableAttributedString   *attStr = [[NSMutableAttributedString alloc]initWithString:content];

    [attStr appendImageName:@"icon_baoyou_shangpinxiangqing"];

    [attStr setFont:[UIFont boldSystemFontOfSize:17] string:value.str(@"good_info.title")];
    [attStr setColor:[UIColor blackColor] string:value.str(@"good_info.title")];
    self.lbDetail.attributedText = attStr;
    //
    NSString                    *point = [NSString stringWithFormat:@"兑换价: %@ 积分", value.str(@"good_info.need_point")];
    NSMutableAttributedString   *attStr2 = [[NSMutableAttributedString alloc]initWithString:point];
    [attStr2 setFont:[UIFont boldSystemFontOfSize:18]  string:value.str(@"good_info.need_point")];
    [attStr2 setColor:[Theme darkOrangeColor] string:@" ".add(value.str(@"good_info.need_point"))];
    self.lbPoint.attributedText = attStr2;
    //
    NSString                    *price = [NSString stringWithFormat:@"市场价:￥%@", value.str(@"good_info.market_price")];
    NSMutableAttributedString   *attStr3 = [[NSMutableAttributedString alloc]initWithString:price];

    [attStr3 setUnderlineString:price];
    self.lbPrice.attributedText = attStr3;
    //
    self.lbHas.text = [NSString stringWithFormat:@"库存量: %@ 件", value.str(@"good_info.inventory")];
    self.lbExchange.text = [NSString stringWithFormat:@"已兑换: %@ 件", value.str(@"good_info.exchange_count")];
    self.lbClick.text = [NSString stringWithFormat:@"人气: %@ ", value.str(@"good_info.clicks")];
}

- (void)setBottom:(NSDictionary *)value {
    NSString *str = [NSString stringWithFormat:@"商品描述\n%@", value.str(@"good_info.summary")];

    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:str];

    [attstr setFont:[UIFont systemFontOfSize:15] string:@"商品描述"];

    [attstr setFont:[UIFont systemFontOfSize:13] string:value.str(@"good_info.summary")];
    [attstr setColor:[UIColor darkGrayColor] string:value.str(@"good_info.summary")];
    [attstr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 5;
    }];

    lbSummary.attributedText = attstr;

    NSInteger user_exchanged_count = value.i(@"user_exchanged_count");

    NSInteger exchange_limit = value.i(@"good_info.exchange_limit");

    NSInteger inventory = value.i(@"good_info.inventory");

    NSInteger now = [SystemConfigDefaults new].server_time.integerValue;

    NSInteger stime = value.i(@"good_info.shelves_start_time");

    if (exchange_limit == 0) {
        self.stepper.maximum = [value getCanBuyNum];
        self.lbBuyTIp.text = @"";
    } else {
        self.stepper.maximum = [value getCanBuyNum];
        self.lbBuyTIp.text = [NSString stringWithFormat:@"每个id限购%ld件", (long)exchange_limit];
    }

    self.stepper.minimum = 1;

    // 兑换条件

    if (now < stime) {
        __block NSTimeInterval offtime = stime - now;

        [time stop];

        if (offtime > 0) {
            time = [[DTimer alloc]initCountdown:offtime done:^(NSTimeInterval vlaue) {
                    if (vlaue == 0) {
                        [self commonJson];
                        [time stop];
                    } else {
                        NSString *timeStr = [[@(vlaue)stringValue] secondToTimeFormat];
                        [sumbitBtn setTitle:timeStr forState:UIControlStateDisabled];
                    }
                }];
        }

        [QTTheme btnGrayStyle:sumbitBtn];
    } else if (inventory == 0) {
        [sumbitBtn setTitle:@"售罄" forState:UIControlStateDisabled];
        [QTTheme btnGrayStyle:sumbitBtn];
    } else {
        if (![GVUserDefaults shareInstance].isLogin) {
            [sumbitBtn setTitle:@"请您先登录" forState:UIControlStateNormal];
            [QTTheme btnRedStyle:sumbitBtn];
            [sumbitBtn click:^(id value) {
                [self loginBack];
            }];
        } else if ([GVUserDefaults shareInstance].sina_status != 3) {
            [sumbitBtn setTitle:@"请您先实名认证" forState:UIControlStateNormal];
            [QTTheme btnRedStyle:sumbitBtn];
            [sumbitBtn click:^(id value) {
                [self toOpenSina];
            }];
        } else if (value.i(@"user_point") < value.i(@"good_info.need_point")) {
            [sumbitBtn setTitle:@"积分不足" forState:UIControlStateDisabled];
            [QTTheme btnGrayStyle:sumbitBtn];
        } else if ((exchange_limit != 0) && (user_exchanged_count >= exchange_limit)) {
            [sumbitBtn setTitle:@"已超出兑换限制" forState:UIControlStateDisabled];
            [QTTheme btnGrayStyle:sumbitBtn];
        } else {
            [sumbitBtn setTitle:@"兑换" forState:UIControlStateNormal];
            [QTTheme btnRedStyle:sumbitBtn];
            [sumbitBtn click:^(id value) {
                QTBuyGoodViewController *controller = [QTBuyGoodViewController controllerFromXib];
                controller.goodInfo = self.goodInfo;
                controller.quantity = self.stepper.value;
                [APPDELEGATE.tabController.navigationController pushViewController:controller animated:YES];
                
            }];
        }
    }
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"good_id"] = self.good_id;
    [service post:@"pgoods_goodinfo" data:dic complete:^(NSDictionary *value) {
        self.goodInfo = value;
        [self setAdView:value];
        [self setDetail:value];
        [self setBottom:value];

        [self hideHUD];
        [super commonJson];
    }];
}

@end
