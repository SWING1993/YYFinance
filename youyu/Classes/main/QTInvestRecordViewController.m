//
//  QTInvestRecordViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestRecordViewController.h"
#import "QTInvestRecordCell.h"
#import "DSegmentedControl.h"
#import "LineView.h"
#import "SortDictionary.h"
#import "NSString+model.h"
#import "QTInvestRecordDetailViewController.h"

@interface QTInvestRecordViewController ()<DSegmentedControlDelegate, SortDictionary>

@end

@implementation QTInvestRecordViewController {
    DStackView  *stack;
    NSString *type;
    NSDictionary *headDic;
    DSegmentedControl *control;
    SortDictionary *sortDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.titleName) {
        self.titleView.title = self.titleName;
    } else {
        self.titleView.title = @"投资记录";
    }

    TABLEReg(QTInvestRecordCell, @"QTInvestRecordCell");
}

- (void)initUI {
    stack = [[DStackView alloc] initWidth:APP_WIDTH];
    self.tableView.tableHeaderView = stack;
    [self initTable];
}

- (void)initData {
    self.isLockPage = YES;
    sortDic = [SortDictionary new];
    sortDic.delegate = self;
    [self tableRrefresh];
}

- (void)setSegment:(NSInteger)segment {
    _segment = segment;
    if (_segment == 0) {
        type = @"0";
    } else if (_segment == 1) {
        type = @"1";
    } else if (_segment == 2) {
        type = @"3";
    } else if (_segment == 3) {
        type = @"4";
    }
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortDic RowCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTInvestRecordCell";
    QTInvestRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSDictionary *dic = [sortDic dataRow:indexPath][@"tender_info"];
    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QTInvestRecordDetailViewController *controller = [QTInvestRecordDetailViewController controllerFromXib];
    NSDictionary *dic = [sortDic dataRow:indexPath][@"tender_info"];
    controller.tender_id = dic[@"tender_id"];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sortDic sectionCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];
    title.text = @" ".add([sortDic sectionTitle:section]).add(@"月");
    [title sizeToFit];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma  mark - json

- (void)segumentSelectionChange:(NSInteger)selection {
    [stack clearSubviews];

    [stack addView:control];

    if (selection == 0) {
        LineView    *view1 = [LineView viewNib];
        NSString    *moneytotal = [@(headDic.fl(@"repay_capital") + headDic.fl(@"wait_capital"))stringValue];

        [view1 setText:@"累计投资" money:[moneytotal moneyFormatData]];

        LineView *view2 = [LineView viewNib];
        [view2 setText:@"已收收益" money:headDic.str(@"repay_interest")];
        view2.tip = @" 总 ";
        [view2 addTapGesture:^{
            [self showToast:@"您从按月付息的投资项目中已经获得的收益+已全部还款完毕的项目中获得的收益" duration:4];
        }];

        LineView *view3 = [LineView viewNib];
        [view3 setText:@"预计收益" money:headDic.str(@"wait_interest")];

        [stack addView:view1];
        [stack addView:view2];
        [stack addView:view3];
    }

    if (selection == 1) {
        LineView *view1 = [LineView viewNib];
        [view1 setText:@"待收本金" money:headDic.str(@"wait_capital")];

        LineView *view3 = [LineView viewNib];
        [view3 setText:@"已收收益" money:headDic.str(@"in_repayment_yesinterest")];
        view3.tip = @" 履约中 ";
        [view3 addTapGesture:^{
            [self showToast:@"您从按月付息的投资项目中已经获得的收益" duration:4];
        }];

        LineView *view2 = [LineView viewNib];
        [view2 setText:@"预计收益" money:headDic.str(@"in_wait_interest")];

        [stack addView:view1];
        [stack addView:view3];
        [stack addView:view2];
    }

    if (selection == 2) {
        LineView *view1 = [LineView viewNib];
        [view1 setText:@"已收本金" money:headDic.str(@"repay_capital")];
        LineView *view2 = [LineView viewNib];
        [view2 setText:@"已收收益" money:headDic.str(@"out_repayment_yesinterest")];
        view2.tip = @" 已回款 ";
        [view2 addTapGesture:^{
            [self showToast:@"您从已全部还款完毕的项目中获得的收益" duration:4];
        }];

        [stack addView:view1];
        [stack addView:view2];
    }

    self.tableView.tableHeaderView = stack;
}

- (NSString *)listKey {
    return @"tender_list";
}

- (NSString *)sortDictionaryKeyFilter:(NSString *)value {
    return [value stringWithDateFormat:@"yyyy-MM"];
}

- (void)dataFormat {
    [sortDic setDataWithKey:@"tender_info.tender_add_time" array:self.tableDataArray];
}

- (void)commonJson {
    [service post:@"account_tenderinfo" data:nil complete:^(NSDictionary *value) {
        headDic = value;
        [self segumentSelectionChange:self.segment];
        [self hideHUD];
    }];

    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    // bidding  tender_success
    dic[@"list_type"] = type;
    [service post:@"app_tenderlist" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];
    }];
}

@end
