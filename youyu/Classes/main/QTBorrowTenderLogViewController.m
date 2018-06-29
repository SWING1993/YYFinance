//
//  QTBorrowTenderLog.m
//  qtyd
//
//  Created by stephendsw on 15/9/23.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTBorrowTenderLogViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTBorrowTenderLogCell.h"

#import "QTBorrowTenderLogTableHeadView.h"
#import "QTVipTipView.h"

@interface QTBorrowTenderLogViewController ()

@end

@implementation QTBorrowTenderLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTBorrowTenderLogCell, @"QTBorrowTenderLogCell");
}

- (void)initData {
    [self commonJson];
}

- (void)initUI {
    [self initTable];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString         *Identifier = @"QTBorrowTenderLogCell";
    QTBorrowTenderLogCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSDictionary            *dic = self.tableDataArray[indexPath.row][@"tender_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [QTBorrowTenderLogTableHeadView viewNib];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark json

- (NSString *)listKey {
    return @"tender_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"borrow_id"] = self.borrow_id;
    [service post:@"borrow_detail" data:dic complete:^(NSDictionary *value1) {
        if ([value1.str(@"new_hand") isEqualToString:@"1"]
        &&
        ![value1.str(@"invest_user_ids") containsString:[GVUserDefaults shareInstance].user_id]
        ) {
            [self tableHandleValueNotHub:nil];

            [self showCustomHUD:[QTVipTipView viewNib]];
        } else {
            [service post:@"borrow_tenderlog" data:dic complete:^(NSDictionary *value) {
                [self tableHandleValueNotHub:value];

                if ([value1.str(@"operate") isEqualToString:@"已流标"] && (value.arr(@"tender_list").count > 0)) {
                    UILabel *label = [[UILabel alloc]init];
                    label.font = [UIFont systemFontOfSize:12];
                    label.backgroundColor = [UIColor whiteColor];
                    label.textColor = [Theme grayColor];
                    label.numberOfLines = 0;
                    label.text = @"由于该标在指定时间内未能满标，以下投资均已失效，投资金额已全部解冻在个人账户。";
                    label.height = 40;
                    label.width = APP_WIDTH;

                    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];
                    stack.backgroundColor = [UIColor whiteColor];
                    [stack addView:label margin:UIEdgeInsetsMake(10, 10, 10, 10)];

                    self.tableView.tableHeaderView = stack;
                }
            }];
        }
    }];
}

@end
