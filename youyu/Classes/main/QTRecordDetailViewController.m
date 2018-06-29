//
//  QTRecordDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 16/8/11.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRecordDetailViewController.h"
#import "QTWebViewController.h"

@interface QTRecordDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton   *btnPay;
@property (strong, nonatomic) IBOutlet UILabel  *lbStatus;

@property (strong, nonatomic) IBOutlet UILabel *lbMoney;

@end

@implementation QTRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"交易记录";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self commonJson];
}

- (void)initUI {
    [self initScrollView];

    self.lbStatus.textColor = [Theme grayColor];
    self.lbMoney.textColor = [Theme darkOrangeColor];
    [self.btnPay setBackgroundColor:[Theme redColor]];

    self.bottomView.cornerRadius = 5;
    self.bottomView.borderColor = [Theme redColor];
    self.bottomView.borderWidth = 1;
}

- (void)initData {
    [self.btnPay click:^(id value) {
        [self commonJsonPay];
    }];
}

#pragma mark  json
- (void)commonJson {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"tender_id"] = self.tender_id;
    [service post:@"corder_detail_v2" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];

        [self.scrollview clearSubviews];

        DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
        [grid setColumn:16 height:44];

        [grid addView:self.lbStatus margin:UIEdgeInsetsMake(40, 0, 8, 0)];
        [grid addView:self.lbMoney margin:UIEdgeInsetsMake(0, 0, 18, 0)];

        [grid addRowLabel:@"交易类型" text:[value.str(@"borrow_name")  firstBorrowName]];

        NSString *tender_status = @"";

        if (value.i(@"tender_status") == 0) {
            tender_status = @"待支付";

            UILabel *label = [grid addRowLabel:@"交易状态" text:tender_status];
            label.textColor = [Theme redColor];
            [grid addRowLabel:@"交易创建时间" text:[value.str(@"addtime") timeValue]];
            [grid addRowLabel:@"交易完成时间" text:@" "];

            self.bottomView.alpha = 1;
            [self addBottomView:self.bottomView padding:UIEdgeInsetsMake(0, 16, 16, 16)];
        } else if (value.i(@"tender_status") == 1) {
            tender_status = @"投资成功";
            [grid addRowLabel:@"交易状态" text:tender_status];
            [grid addRowLabel:@"交易创建时间" text:[value.str(@"addtime") timeValue]];
            [grid addRowLabel:@"交易完成时间" text:[value.str(@"complete_time") timeValue]];
            self.bottomView.alpha = 0;
        } else if (value.i(@"tender_status") == 2) {
            tender_status = @"投资失败";
            [grid addRowLabel:@"交易状态" text:tender_status];
            [grid addRowLabel:@"交易创建时间" text:[value.str(@"addtime") timeValue]];
            [grid addRowLabel:@"交易关闭时间" text:[value.str(@"complete_time") timeValue]];
            self.bottomView.alpha = 0;
        }

        self.lbStatus.text = tender_status;
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:@"-"];
        [attstr appendAttributedString:[value.str(@"tender_money")  moneyFormatZeroShow]];
        self.lbMoney.attributedText = attstr;

        [self.scrollview addSubview:grid];
        [self.scrollview autoContentSize];
    }];
}

- (void)commonJsonPay {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"tender_id"] = self.tender_id;
    dic[@"return_url"] = RETURN_URL(@"app_back");
    [service post:@"corder_pay_v2" data:dic complete:^(id value) {
        [self hideHUD];
        QTWebViewController *controller = [QTWebViewController controllerFromXib];
        controller.htmlContent = [value getDecodeUrl];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}

@end
