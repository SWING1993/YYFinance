//
//  QTMallViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/16.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMallViewController.h"
#import "QTWebViewController.h"
#import "QTMallListView.h"
#import "QTMallListViewController.h"
#import "QTVipView.h"

@interface QTMallViewController ()
@property (strong, nonatomic) IBOutlet UIView   *viewHot;
@property (strong, nonatomic) IBOutlet UIView   *viewTitle;
@property (strong, nonatomic)IBOutletCollection(UIImageView) NSArray * imageviews;
@property (strong, nonatomic) IBOutlet UIView *viewItem;

@end

@implementation QTMallViewController
{
    AdView *adviewContent;

    UIImageView *imageView;

    DWrapView *warp2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUI {
    [self initScrollView];
    [self setRefreshScrollView];

    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    // banner
    adviewContent = [[AdView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_WIDTH / 320 * 100)];
    adviewContent.placeHoldImage = [UIImage imageNamed:@"mall_default"];
    [adviewContent setPageControlShowStyle:UIPageControlShowStyleCenter];
    [QTTheme pageControlStyle:adviewContent.pageControl];
    [stack addView:adviewContent];
    //按钮
    DWrapView *warp = [[DWrapView alloc]initWidth:APP_WIDTH columns:4];
    warp.subHeight = 90;

    WEAKSELF;

    QTVipView *item1 = [QTVipView viewNib];
    [item1 setText:@"赚积分" img:@"icon_scindex_zhuanjifen"];
    [item1 addTapGesture:^{
        QTWebViewController *contrller = [QTWebViewController controllerFromXib];
        contrller.url = WEB_URL(@"/phone/zt/earn_point");
        contrller.isNeedLogin = YES;
        [weakSelf.navigationController pushViewController:contrller animated:YES];
    }];

    [warp addView:item1];

    QTVipView *item2 = [QTVipView viewNib];
    [item2 setText:@"查积分" img:@"icon_scindex_chajifen"];
    [item2 addTapGesture:^{
        [weakSelf loginedAction:^{
            [weakSelf toPointRecrod];
        }];
    }];
    [warp addView:item2];

    QTVipView *item3 = [QTVipView viewNib];
    [item3 setText:@"成长值" img:@"icon_scindex_chengzhangzhi"];
    [item3 addTapGesture:^{
        [weakSelf loginedAction:^{
            [weakSelf toGrow];
        }];
    }];
    [warp addView:item3];

    QTVipView *item4 = [QTVipView viewNib];
    [item4 setText:@"看订单" img:@"icon_scindex_dingdan"];
    [item4 addTapGesture:^{
        [weakSelf loginedAction:^{
            [weakSelf toOrderListWithBackBefore:YES];
        }];
    }];

    [warp addView:item4];

    [stack addView:warp];

    [stack addLineForHeight:10];
    // banner

    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
    // [stack addView:imageView];
    // 推荐
    self.viewHot.height = 178 / 320.0 * APP_WIDTH;
    self.viewHot.backgroundColor = [Theme backgroundColor];
    [stack addView:self.viewHot];

    //
    self.viewTitle.backgroundColor = [Theme backgroundColor];
    [stack addView:self.viewTitle margin:UIEdgeInsetsZero];
    // 热门
    [stack addView:self.viewItem];
    [self.viewItem addTapGesture:^{
        [weakSelf toMallList];
    }];

    warp2 = [[DWrapView alloc]initWidth:APP_WIDTH];
    warp2.subHeight = APP_WIDTH / 2 / 160 * 210;
    [stack addView:warp2];

    [stack addLineForHeight:20];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    // self
    [self.imageviews.lastObject addTapGesture:^{
        [self clickMore];
    }];

    [self firstGetData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"积分商城";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - event

- (IBAction)clickMore {
    QTMallListViewController *controller = [QTMallListViewController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark  - json

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"recommend_num"] = @"4";
    dic[@"hot_num"] = @"6";

    [service post:@"mall_index" data:dic complete:^(NSDictionary *value) {
        NSArray *picList = [value.arr(@"pic_list") getArrayForKey:@"pic_info.url"];

        [adviewContent setimageLinkURL:picList];
        [adviewContent click:^(NSInteger index, NSString *imageURL) {
            NSDictionary *picInfo = (NSDictionary *)value.arr(@"pic_list")[index];
            NSString *href = picInfo.str(@"pic_info.href");
            [self handelBanner:href];
        }];

        // 热门
        NSArray<NSDictionary *> *hot_goods_list = value.arr(@"hot_goods_list");

        [warp2 clearSubviews];

        for (NSDictionary *item in hot_goods_list) {
            QTMallListView *itemView = [QTMallListView viewNib];
            itemView.height = APP_WIDTH / 2 / 160 * 210;
            itemView.width = (APP_WIDTH - 1) / 2;
            [itemView bind:item.dic(@"hot_goods_info")];
            [itemView addTapGesture:^{
                [self toMallDetail:item.str(@"hot_goods_info.id")];
            }];

            [warp2 addView:itemView];
        }

        [self hideHUD];
        [super commonJson];
    }];

    [service post:@"mall_wapad" data:nil complete:^(NSDictionary *value) {
        // 精品
        NSArray<NSDictionary *> *recommend_goods_list = value.arr(@"pic_list");

        for (int i = 0; i < recommend_goods_list.count; i++) {
            [self.imageviews[i] setImageWithURL:[NSURL URLWithString:recommend_goods_list[i].str(@"pic_info.url")] placeholderImage:[UIImage imageNamed:@"mall_default"]];

            NSString *mallid = [recommend_goods_list[i].str(@"pic_info.href") componentsSeparatedByString:@"/"].lastObject;

            if (![NSString isEmpty:mallid] && (mallid.intValue > 0)) {
                [self.imageviews[i] addTapGesture:^{
                    [self toMallDetail:mallid];
                }];
            }
        }
    }];
}

- (void)handelBanner:(NSString *)url {
    if ([url isExistsSubStr:@"phone/mall/product_primary/"]) {
        NSString *mallid = [url componentsSeparatedByString:@"/"].lastObject;
        [self toMallDetail:mallid];
    } else if (![NSString isEmpty:url]) {
        QTWebViewController *webController = [[QTWebViewController alloc]init];

        if ([url isExistsSubStr:@"https://"] || [url isExistsSubStr:@"http://"]) {
            webController.url = url;
        } else {
            webController.url = WEB_URL(url);
        }

        webController.isNeedLogin = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}

@end
