//
//  QTVipOrderViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/17.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVipOrderViewController.h"
#import "GVUserDefaults.h"
#import "QTVIPAlertView.h"

@interface QTVipOrderViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)  WTReTextField *tfMoney;

@property (strong, nonatomic)  WTReTextField *tf_reservation_borrow_days;

@property (strong, nonatomic)  WTReTextField *tf_reservation_apr;

@property (strong, nonatomic)  UISwitch *swcall;

@property (strong, nonatomic)  UISwitch *swmsg;

@property (strong, nonatomic)  UISwitch *swweixin;

@property (strong, nonatomic)  UILabel *lbMthods;

@end

@implementation QTVipOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"我要预约";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:20];

    [grid addRowLabel:@"姓        名" text:[GVUserDefaults  shareInstance].realname];

    self.tfMoney = [grid addRowInput:@"投资总额" placeholder:@"50-300" tagText:@"万"];
    self.tfMoney.delegate = self;
    self.tf_reservation_borrow_days = [grid addRowInput:@"期        限" placeholder:@"90-720" tagText:@"天"];
    self.tf_reservation_borrow_days.delegate = self;
    self.tf_reservation_apr = [grid addRowInput:@"预计年化" placeholder:@"请输入预计年化" tagText:@"%"];
    self.tf_reservation_apr.delegate = self;

    [grid addLineForHeight:20];
    self.lbMthods = [grid addRowLabel:@"通知方式" text:@""];

    self.swcall = [grid addRowSwitch:@"电        话"];
    self.swmsg = [grid addRowSwitch:@"短        信"];
    self.swweixin = [grid addRowSwitch:@"微信推送"];

    [self.swcall valueChange:^(id value) {
        if (self.swcall.on) {
            self.lbMthods.text = @[self.lbMthods.text,@" 电话 "].joinedString;
        } else {
            if (!self.swcall.on && !self.swmsg.on && !self.swweixin.on) {
                [self showToast:@"请至少选择一种通知方式"];
                self.swcall.on = YES;
            } else {
                self.lbMthods.text = [self.lbMthods.text stringByReplacingOccurrencesOfString:@" 电话 " withString:@""];
            }
        }
    }];
    self.swcall.on = YES;
    self.lbMthods.text =@[self.lbMthods.text,@" 电话 "].joinedString;

    [self.swmsg valueChange:^(id value) {
        if (self.swmsg.on) {
            self.lbMthods.text =@[self.lbMthods.text,@" 短信 "].joinedString;
        } else {
            if (!self.swcall.on && !self.swmsg.on && !self.swweixin.on) {
                [self showToast:@"请至少选择一种通知方式"];
                self.swmsg.on = YES;
            } else {
                self.lbMthods.text = [self.lbMthods.text stringByReplacingOccurrencesOfString:@" 短信 " withString:@""];
            }
        }
    }];
    [self.swweixin valueChange:^(id value) {
        if (self.swweixin.on) {
            self.lbMthods.text =@[self.lbMthods.text,@" 微信推送 "].joinedString;
        } else {
            if (!self.swcall.on && !self.swmsg.on && !self.swweixin.on) {
                [self showToast:@"请至少选择一种通知方式"];
                self.swweixin.on = YES;
            } else {
                self.lbMthods.text = [self.lbMthods.text stringByReplacingOccurrencesOfString:@" 微信推送 " withString:@""];
            }
        }
    }];

    [grid addLineForHeight:20];
    [grid addRowButtonTitle:@"确认预约" click:^(id value) {
        [self clickSubmit];
    }];

    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor darkGrayColor];

    NSMutableAttributedString *attsrt = [[NSMutableAttributedString alloc]initWithString:@"VIP订制规则\n1.	VIP订制项目类别不限，单个项目投资金额50万元起，最高投资300万元，项目周期90-720天；\n2.	每个V7账户最多可同时预约3个订制标，若其中有1个订制标配对成功或审核失败，则可再次预约，以此类推。\n3.	VIP订制项目不参与“王者归来”活动，不能使用红包、红包券、加息券；\n4.	收到预约申请后，您的专属客服24小时内会与您确认订制需求，待项目匹配成功后会再次联系您，您也可以在VIP订制专区 “我的VIP订制”查看您的订制项目，完成投资；\n5.	所有VIP订制项目满标计息，当预约成功并确认后，需要在48小时内完成投资，若项目超过48小时未满标，我们会解冻该项目已投金额，并将项目转给其他用户。"];
    [attsrt setFont:[UIFont systemFontOfSize:12]];
    [attsrt setFont:[UIFont systemFontOfSize:14] string:@"VIP订制规则"];
    [attsrt setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 8;
    }];

    label.attributedText = attsrt;

    [grid addView:label margin:UIEdgeInsetsMake(10, 0, 20, 0)];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];

    for (UIView *item in grid.allSubviews) {
        if ([item isKindOfClass:[WTReTextField class]]) {
            ((WTReTextField *)item).textAlignment = NSTextAlignmentRight;
        }
    }
}

- (void)initData {
    self.isLockPage = YES;

    [self.tfMoney setPositiveInteger:6];
    self.tfMoney.nilTip = @"请输入投资总额";
    self.tfMoney.errorTip = @"请输入有效的投资总额";
    self.tfMoney.isNeed = YES;

    [self.tf_reservation_borrow_days setPositiveInteger:3];
    self.tf_reservation_borrow_days.nilTip = @"请输入收益期限";
    self.tf_reservation_borrow_days.errorTip = @"请输入有效的收益期限";
    self.tf_reservation_borrow_days.isNeed = YES;

    [self.tf_reservation_apr setMoney];
    self.tf_reservation_apr.nilTip = @"请输入预计年化";
    self.tf_reservation_apr.errorTip = @"请输入有效的预计年化";
    self.tfMoney.isNeed = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;

    if ([textField isEqual:self.tfMoney]) {
        if (text.length == 0) {
            [self showToast:@"请输入有效的投资总额"];
        } else if ((text.floatValue < 50) || (text.floatValue > 300)) {
            [self showToast:@"单个项目投资金额50万元起，最高投资300万元"];
        }
    }

    if ([textField isEqual:self.tf_reservation_borrow_days]) {
        if (text.length == 0) {
            [self showToast:@"请输入有效的收益期限"];
        } else if ((text.floatValue < 90) || (text.floatValue > 720)) {
            [self showToast:@"项目周期90-720天"];
        }
    }

    if ([textField isEqual:self.tf_reservation_apr]) {
        if (text.length == 0) {
            [self showToast:@"请输入有效的预计年化"];
        }
    }
}

- (void)clickSubmit {
    if (![self.view validation:0]) {
        return;
    }

    if ((!self.swcall.on) && (!self.swweixin.on) && (!self.swmsg.on)) {
        [self showToast:@"请选择至少一种通知方式" duration:2];
        return;
    }

    NSString *str = [NSString stringWithFormat:@"姓       名：%@\n投资总额：%@万元\n期       限：%@天\n预计年化：%@%%\n通知方式：%@",
        [GVUserDefaults  shareInstance].realname,
        self.tfMoney.text,
        self.tf_reservation_borrow_days.text,
        self.tf_reservation_apr.text,
        self.lbMthods.text
        ];

    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:str];
    [attstr setColor:[UIColor blackColor] string:@"姓       名："];
    [attstr setColor:[UIColor blackColor] string:@"投资总额："];
    [attstr setColor:[UIColor blackColor] string:@"期       限："];
    [attstr setColor:[UIColor blackColor] string:@"预计年化："];
    [attstr setColor:[UIColor blackColor] string:@"通知方式："];
    [attstr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 8;
    }];

    QTVIPAlertView *alert = [QTVIPAlertView viewNib];

    alert.lbTitle.attributedText = attstr;

    [alert.btnSubmit click:^(id value) {
        [self commonJson];
    }];
    [alert.btnCancel click:^(id value) {
        [self hideCustomHUB];
    }];

    [self showCustomHUD:alert];
}

#pragma mark - json
- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    NSMutableArray *methods = [NSMutableArray new];

    if (self.swcall.on) {
        [methods addObject:@"0"];
    }

    if (self.swmsg.on) {
        [methods addObject:@"1"];
    }

    if (self.swweixin.on) {
        [methods addObject:@"2"];
    }

    NSMutableString *str = [NSMutableString new];
    [str appendString:@";"];

    for (NSString *item in methods) {
        [str appendString:item];
        [str appendString:@";"];
    }

    dic[@"notification_methods"] = str;
    dic[@"reservation_account"] = self.tfMoney.text;
    dic[@"reservation_apr"] = self.tf_reservation_apr.text;
    dic[@"reservation_borrow_days"] = self.tf_reservation_borrow_days.text;

    [service post:@"vipcustom_apply" data:dic complete:^(id value) {
        [self showToast:@"恭喜预约成功，我们将尽快审核您的需求" done:^{
            [self toVipOrderList];
        }];
    }];
}

@end
