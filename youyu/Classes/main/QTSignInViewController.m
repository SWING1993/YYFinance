//
//  QTSignInViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSignInViewController.h"

#import "FyCalendarView.h"
#import "CAShapeLayer+qtlayer.h"

#import "QTRepaymentRowView.h"

#import "QTActivityView.h"

#import "QTRepaymentDetailViewController.h"

#import "QTWebViewController.h"

@interface QTSignInViewController ()<CAAnimationDelegate>

@property (strong, nonatomic) IBOutlet UIView   *viewState1;
@property (strong, nonatomic) IBOutlet UIView   *viewTitle;
@property (weak, nonatomic) IBOutlet UILabel    *lbReturn;
@property (weak, nonatomic) IBOutlet UILabel    *lbAllMoney;
@property (weak, nonatomic) IBOutlet UIButton   *btnSignIN;

@property (weak, nonatomic) IBOutlet UILabel *lbCurrentDate;

@end

@implementation QTSignInViewController
{
    FyCalendarView  *calendarView;
    UIView          *calendarContentView;

    NSTimeInterval  stime;
    NSTimeInterval  etime;

    NSDate *currentDate;

    NSDictionary *jsonData;

    DStackView *stack;

    BOOL        isNext;
    NSInteger   lodNum;

    UILabel *lballMoney;
    UILabel *lbearnMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"还款日历";

    [self setRightNavItemImage:[[UIImage imageNamed:@"icon_richeng"] imageWithColor:[UIColor whiteColor]]];
}

- (void)rightClick {
    [self toRepaymentSchedule];
}

- (void)initUI {
    [self initScrollView];

    DStackView *stackhome = [[DStackView alloc]initWidth:APP_WIDTH];
    calendarContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 350)];
    [stackhome addView:calendarContentView];

    [stackhome addLineForHeight:10 color:[Theme backgroundColor]];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    [grid setColumn:16 height:25];
    grid.isShowLine=NO;
    lballMoney = [grid addRowLabel:@"本月还款总额" text:@""];
    lbearnMoney = [grid addRowLabel:@"本月已获收益" text:@""];

    [stackhome addView:grid];

    [stackhome addView:self.viewState1];
    self.viewState1.backgroundColor = [Theme backgroundColor];
    stack = [[DStackView alloc]initWidth:APP_WIDTH];
    [stackhome addView:stack];

    [self.scrollview addSubview:stackhome];

    self.viewTitle.backgroundColor = [Theme backgroundColor];
    [self.scrollview autoContentSize];
    [self addBottomView:self.viewTitle];
}

- (void)initData {
    self.isLockPage = YES;
    currentDate = [NSDate systemDate];
    [self getMonth];
    [self commonJson];
}

- (void)getMonth {
    NSString *sTime = [NSString stringWithFormat:@"%@ 00:00:00", currentDate.firstDayOfCurrentMonth.shortTimeString];
    stime = sTime.timeIntervalValue;
    NSString *eTime = [NSString stringWithFormat:@"%@ 23:59:59", currentDate.lastDayOfCurrentMonth.shortTimeString];
    etime = eTime.timeIntervalValue;
}

- (void)setCalendarView:(NSDictionary *)data {
    WEAKSELF;
    [calendarView removeFromSuperview];
    calendarView = [[FyCalendarView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, calendarContentView.height)];

    calendarView.backgroundColor = [UIColor whiteColor];
    calendarView.partCircleDaysColor = [Theme purpleColor];

    calendarView.nextMonthBlock = ^() {
        isNext = YES;
        currentDate = [currentDate dayInTheFollowingMonth];
        [weakSelf getMonth];
        [weakSelf commonJson];
    };
    calendarView.lastMonthBlock = ^() {
        isNext = NO;
        currentDate = [currentDate dayInThePreviousMonth];
        [weakSelf getMonth];
        [weakSelf commonJson];
    };

    {
        NSArray<NSNumber *> *insign_list = [data.arr(@"insign_list") getArrayForKey:@"insign_info.addtime"];
        NSMutableArray      *datelist = [NSMutableArray new];

        for (NSNumber *time in insign_list) {
            [datelist addObject:[time stringValue].dayValue];
        }

        calendarView.partDaysArr = datelist;
    }

    {
        NSArray<NSNumber *> *repayment_list = [data.arr(@"repayment_list") getArrayForKey:@"repayment_info.repay_time"];

        NSMutableArray *datelist = [NSMutableArray new];

        for (NSNumber *time in repayment_list) {
            [datelist addObject:[time stringValue].dayValue];
        }

        calendarView.partCircleDaysArr = datelist;
    }

    calendarView.calendarBlock = ^(NSDate *date)
    {
        NSString *time = date.shortTimeString;

        NSArray<NSNumber *> *insign_list = data.arr(@"insign_list");
        NSArray<NSNumber *> *repayment_list = data.arr(@"repayment_list");

        [stack clearSubviews];
        // **********************************签到********************************************
        [self.btnSignIN setTitle:@" 已错过当日签到 " forState:UIControlStateNormal];
        
        [QTTheme btnGrayStyle:self.btnSignIN];

        if ([[NSDate systemDate].shortTimeString compareExpression:[NSString stringWithFormat:@"self < '%@'", time]]) {
            [self.btnSignIN setTitle:@" 未开始 " forState:UIControlStateNormal];
             [QTTheme btnGrayStyle:self.btnSignIN];
        } else if ([[NSDate systemDate].shortTimeString compareExpression:[NSString stringWithFormat:@"self = '%@'", time]]) {
            [self.btnSignIN setTitle:@" 签到 " forState:UIControlStateNormal];
             [QTTheme btnRedStyle:self.btnSignIN];
            [self.btnSignIN click:^(id value) {
                [self puser_insign];
            }];
        }

        for (NSDictionary *item in insign_list) {
            if ([item.str(@"insign_info.addtime").dateValue isEqualToString:time]) {
                [self.btnSignIN setTitle:@" 已签到 " forState:UIControlStateNormal];
                [QTTheme btnGrayStyle:self.btnSignIN];
            }
        }

        // **********************************当日还款********************************************
        NSMutableArray *countRepayment = [NSMutableArray new];

        for (NSDictionary *item in repayment_list) {
            if ([item.str(@"repayment_info.repay_time").dateValue isEqualToString:time]) {
                [countRepayment addObject:item];
            }
        }

        CGFloat allmoney = 0;

        for (NSDictionary *item in countRepayment) {
            QTRepaymentRowView *view = [QTRepaymentRowView viewNib];

            NSString *name = [item.str(@"repayment_info.borrow_name") firstBorrowName];

            NSString *num = [NSString stringWithFormat:@"%@/%@", item.str(@"repayment_info.current_stage"), item.str(@"repayment_info.total_stage")];

            NSString *money = [@(item.fl(@"repayment_info.capital") + item.fl(@"repayment_info.interest")).stringValue moneyFormatShow];

            allmoney += (item.fl(@"repayment_info.capital") + item.fl(@"repayment_info.interest"));

            [view bindName:name num:num money:money];

            [view addTapGesture:^{
                QTRepaymentDetailViewController *controller = [QTRepaymentDetailViewController controllerFromXib];
                controller.borrowDic = item.dic(@"repayment_info");
                [self.navigationController pushViewController:controller animated:YES];
            }];

            [stack addView:view];
        }
        
        if (countRepayment.count==0) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 40)];
            label.text=@"   当前没有还款项目，去看看投资项目?";
            label.backgroundColor=[UIColor whiteColor];
            label.font=[UIFont systemFontOfSize:12];
            [label addTapGesture:^{
                [self toInvest];
            }];
            [stack addView:label];
        }
        

        self.lbReturn.text = [NSString stringWithFormat:@"(%lu笔)", (unsigned long)countRepayment.count];
        self.lbAllMoney.text = [NSString stringWithFormat:@"还款金额:%@", [@(allmoney).stringValue moneyFormatShow]];

        self.lbCurrentDate.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)date.components.year, (long)date.components.month, (long)date.components.day];
    };

    calendarView.date = currentDate;

    [calendarContentView addSubview:calendarView];

    if (lodNum != 0) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.7;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"pageCurl";

        if (isNext) {
            animation.subtype = kCATransitionFromRight;
        } else {
            animation.subtype = kCATransitionFromLeft;
        }

        [[calendarContentView layer] addAnimation:animation forKey:@"animation"];
    }

    lodNum++;
}

#pragma mark json
- (void)commonJson {
    [self showHUD];

    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"start_time"] = @(stime);
    dic[@"end_time"] = @(etime);
    [service post:@"repayment_calendar" data:dic complete:^(NSDictionary *value) {
        jsonData = value;
        [self setCalendarView:value];
        [self hideHUD];
    }];

    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    dic2[@"year"] = @(currentDate.components.year);
    dic2[@"month"] = @(currentDate.components.month);
    [service post:@"repayment_yearMonthSummary" data:dic2 complete:^(NSDictionary *value) {
        lballMoney.text = value.str(@"total_repayment").add(@"(元)");
        lbearnMoney.text = value.str(@"revenue").add(@"(元)");
    }];
}

- (void)puser_insign {
    [self showHUD];
    [service post:@"puser_insign" data:nil complete:^(NSDictionary *value) {
        [self hideHUD];
        [GVUserDefaults  shareInstance].insign_flg = @"1";
        [self.btnSignIN setTitle:@" 已签到 " forState:UIControlStateNormal];
        [QTTheme btnGrayStyle:self.btnSignIN];
        NSString *tip = @"签到成功";
        [self showToast:tip duration:3];

        lodNum = 0;
//        [self commonJson];
    }];
}

@end
