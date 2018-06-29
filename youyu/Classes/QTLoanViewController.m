//
//  QTLoanViewController.m
//  qtyd
//
//  Created by stephendsw on 16/6/14.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTLoanViewController.h"

@interface QTLoanViewController ()
@property (strong, nonatomic) IBOutlet UIView   *viewRowSecond;
@property (strong, nonatomic)  WTReTextField    *twPeople;
@property (strong, nonatomic)  WTReTextField    *twNet;
@property (strong, nonatomic)  WTReTextField    *twMoney;
@property (strong, nonatomic)  WTReTextField    *twName;
@property (strong, nonatomic)  WTReTextField    *twPhone;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton   *btn2;
@property (weak, nonatomic) IBOutlet UIButton   *btn3;

@property (weak, nonatomic) IBOutlet WTReTextField *tbOther;

@end

@implementation QTLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"借款申请";
    self.navigationItem.rightBarButtonItem=nil;
}

- (void)initUI {
    [self initScrollView];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

    [grid setColumn:16 height:44];

    self.twPeople = [grid addRowInput:@"借款人" placeholder:@"请选择"];
    [self.twPeople setInputDropList:@[@"中小企业户", @"个体户", @"个人"]];
    self.twPeople.textAlignment = NSTextAlignmentRight;
    [grid addLineForHeight:10];

    [grid addRowView:self.viewRowSecond];
    self.twNet = [grid addRowInput:@"就近网点" placeholder:@"请选择"];
    [self.twNet setInputDropList:@[@"天津", @"杭州", @"唐山", @"昆明"]];
    self.twNet.textAlignment = NSTextAlignmentRight;

    [grid addLineForHeight:10];
    self.twMoney = [grid addRowInput:@"借款金额" placeholder:@"请输入您的借款金额" tagText:@"万"];
    self.twName = [grid addRowInput:@"姓名" placeholder:@"请输入您的姓名"];
    self.twPhone = [grid addRowInput:@"联系电话" placeholder:@"请输入您的电话号码"];

    [grid addLineForHeight:40];
    [grid addRowButtonTitle:@"申请贷款" click:^(id value) {
        [self submitClick];
    }];

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
}

- (void)initData {
    [self.twPhone setPhone];
    self.twPhone.isNeed = YES;
    self.twPhone.nilTip = @"请输入您的联系电话";

    [self.twName setNickName];
    self.twName.isNeed = YES;
    self.twName.nilTip = @"请输入您的姓名";

    [self.twMoney setPositiveInteger:5];
    self.twMoney.isNeed = YES;
    self.twMoney.nilTip = @"请输入您的借款金额";

    self.twPeople.isNeed = YES;
    self.twPeople.nilTip = @"请选择借款人";

    self.twNet.isNeed = YES;
    self.twNet.nilTip = @"请选择就近网点";

    self.tbOther.isNeed = YES;
    self.tbOther.nilTip = @"请填写抵押物说明";

    NSArray *btnlist = @[self.btn1, self.btn2, self.btn3];

    for (UIButton *item in btnlist) {
        [item setImage:[[UIImage imageNamed:@"icon_zhengpingbaozheng"] imageWithColor:[Theme darkOrangeColor]] forState:UIControlStateSelected];
        [item setImage:[[UIImage imageNamed:@"icon_zhengpingbaozheng"] imageWithColor:[Theme darkGrayColor]]  forState:UIControlStateNormal];

        [item setTitleColor:[Theme darkOrangeColor] forState:UIControlStateSelected];
        [item setTitleColor:[Theme darkGrayColor] forState:UIControlStateNormal];

        [item clickOn:^(id value) {} off:^(id value) {}];
    }
}

- (void)submitClick {
    if (![self.view validation:0]) {
        return;
    }

    if (!self.btn1.selected && !self.btn2.selected && !self.btn3.selected) {
        [self showToast:@"请勾选抵押物类型"];
        return;
    }

    [self commonJson];
}

#pragma mark json
- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    NSInteger user_type = 1;

    if ([self.twPeople.text isEqualToString:@"中小企业主"]) {
        user_type = 1;
    } else if ([self.twPeople.text isEqualToString:@"个体户"]) {
        user_type = 2;
    } else if ([self.twPeople.text isEqualToString:@"个人"]) {
        user_type = 3;
    }

    NSMutableString *mortgage_type = [NSMutableString new];

    if (self.btn1.selected) {
        [mortgage_type appendString:@"1;"];
    }

    if (self.btn2.selected) {
        [mortgage_type appendString:@"2;"];
    }

    if (self.btn3.selected) {
        [mortgage_type appendString:@"3"];
    }

    NSInteger area_type = 1;

    if ([self.twPeople.text isEqualToString:@"天津"]) {
        area_type = 1;
    } else if ([self.twPeople.text isEqualToString:@"杭州"]) {
        area_type = 2;
    } else if ([self.twPeople.text isEqualToString:@"唐山"]) {
        area_type = 3;
    } else if ([self.twPeople.text isEqualToString:@"昆明"]) {
        area_type = 4;
    }

    dic[@"user_type"] = @(user_type);
    dic[@"mortgage_type"] = mortgage_type;
    dic[@"mortgage_other"] = self.tbOther.text;
    dic[@"area_type"] = @(area_type);
    dic[@"money"] = self.twMoney.text;
    dic[@"real_name"] = self.twName.text;
    dic[@"user_address"] = @"hz";
    dic[@"phone"] = self.twPhone.text;
    dic[@"plat"] = @"3";

    [service post:@"userLoan_loan" data:dic complete:^(id value) {
        [self showToast:@"申请成功，请保持通讯畅通!" duration:3 done:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
