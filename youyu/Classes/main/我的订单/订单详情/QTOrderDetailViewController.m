//
//  QTOrderDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTOrderDetailViewController.h"
#import "QTGoodView.h"
#import "QTAdressView.h"
#import "QTExpressView.h"
#import "QTExpressViewController.h"

@interface QTOrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView   *viewSum;
@property (weak, nonatomic) IBOutlet UILabel    *lbAll;
@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;

@end

@implementation QTOrderDetailViewController
{
    QTAdressView    *addressView;
    QTGoodView      *goodView;

    QTExpressView *expressView;

    UIButton *sumbitBtn;

    UILabel *lbOther;

    NSString *orderNo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"订单详情";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];
    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    expressView = [QTExpressView viewNib];
    [stack addView:expressView];
    [expressView setBottomLine:[Theme borderColor]];

    addressView = [QTAdressView viewNib];
    addressView.type = AddressTypeOrder;
    [stack addView:addressView];

    goodView = [QTGoodView viewNib];
    [stack addView:goodView];
    [goodView setBottomLine:[Theme borderColor]];

    [stack addView:self.viewSum];

    lbOther = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
    lbOther.font = [UIFont systemFontOfSize:14];
    lbOther.textColor = [UIColor darkGrayColor];

    [stack addView:lbOther margin:UIEdgeInsetsMake(8, 16, 8, 16)];

    sumbitBtn = [stack addRowButtonTitle:@"确认收货" click:^(id value) {}];
    [self addBottomView:sumbitBtn padding:UIEdgeInsetsMake(0, 16, 8, 16)];

    sumbitBtn.hidden = YES;

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.isLockPage = YES;
    [self firstGetData];
}

#pragma mark json
- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"order_id"] = self.orderID;

    [service post:@"mall_orderinfo" data:dic complete:^(NSDictionary *value) {
        [expressView bind:value];

        WEAKSELF;

        [addressView bind:value];

        NSMutableDictionary *goodinfo = [NSMutableDictionary new];
        goodinfo[@"good_info"] = value;

        goodView.num = value.i(@"unit");
        [goodView bind:goodinfo];

        self.lbPoint.text = [NSString stringWithFormat:@"合计: %@ 积分", @(value.i(@"need_point") * value.i(@"unit"))];
        self.lbAll.text = [NSString stringWithFormat:@"共记 %@ 件商品", value.str(@"unit")];

        NSString *other = [NSString stringWithFormat:@"订单编号:%@\n兑换时间:%@", value.str(@"order_no"), value.str(@"addtime").timeValue];

        if (value.str(@"delivery_time").length > 0) {
            NSString *sendTime = [NSString stringWithFormat:@"\n发货时间:%@", value.str(@"delivery_time").timeValue];
            other = other.add(sendTime);
        }

        NSMutableAttributedString *tip = [[NSMutableAttributedString alloc] initWithString:other];
        [tip setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
            Paragraph.lineSpacing = 5;
        }];

        lbOther.attributedText = tip;

        orderNo = dic.str(@"order_no");

        if ([expressView.status isEqualToString:@"待收货"]) {
            sumbitBtn.hidden = NO;
            [sumbitBtn setTitle:@"确认收货 并评价" forState:UIControlStateNormal];
            [sumbitBtn click:^(id value1) {
                [self commonJsonOrderreceipt:value.str(@"order_id")];
            }];

            [expressView addTapGesture:^{
                QTExpressViewController *controller = [QTExpressViewController controllerFromXib];

                controller.express_company_type = value.str(@"express_company_type");
                controller.express_no = value.str(@"express_no");

                [weakSelf.navigationController pushViewController:controller animated:YES];
            }];
        } else if ([expressView.status isEqualToString:@"待评价"]) {
            sumbitBtn.hidden = NO;
            [sumbitBtn setTitle:@"评价" forState:UIControlStateNormal];

            [sumbitBtn click:^(id value) {
                [self toMallComment:dic.str(@"order_id")];
            }];
        } else {
            sumbitBtn.hidden = YES;
        }

        [self hideHUD];
    }];
}

- (void)commonJsonOrderreceipt:(NSString *)orderid {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"order_id"] = orderid;
    [service post:@"mall_orderreceipt" data:dic complete:^(id value) {
        [self hideHUD];
        NOTICE_POST(NOTICEORDER);

        DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"确定收货成功" message:@"是否去评价"];

        [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];

        [alert addActionWithTitle:@"评价" handler:^(CKAlertAction *action) {
            [self toMallComment:dic.str(@"order_no")];
        }];

        [alert show];
    }];
}

@end
