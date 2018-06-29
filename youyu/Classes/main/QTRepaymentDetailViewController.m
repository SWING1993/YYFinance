//
//  QTRepaymentDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/9.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRepaymentDetailViewController.h"
#import "QTRepaymentDetailCell.h"
#import "QTBaseViewController+Table.h"

@interface QTRepaymentDetailViewController ()
{
    NSMutableArray<NSIndexPath *> *dropList;
}

@end

@implementation QTRepaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"还款明细";
    self.navigationItem.rightBarButtonItem = nil;
    TABLEReg(QTRepaymentDetailCell, @"QTRepaymentDetailCell");
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initData {
    dropList = [NSMutableArray new];
    self.isLockPage = YES;
    [self firstGetData];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString         *Identifier = @"QTRepaymentDetailCell";
    QTRepaymentDetailCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"tender_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"tender_info"];

    if ((dic.arr(@"collection_list").count > 0) && ![dropList containsObject:indexPath]) {
        return 90 + 30 * (dic.arr(@"collection_list").count + 1);
    } else {
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([dropList containsObject:indexPath]) {
        [dropList removeObject:indexPath];
    } else {
        [dropList addObject:indexPath];
    }

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无还款记录";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma  mark - json

- (NSString *)listKey {
    return @"tender_list";
}

- (void)commonJson {
    if (self.borrowDic) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"borrow_id"] = self.borrowDic.str(@"borrow_id");
        dic[@"tender_id"] = self.borrowDic.str(@"tender_id");
        [service post:@"repayment_detail" data:dic complete:^(id value) {
            [self tableHandleValue:value];
        }];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary new];

        dic[@"cur_page"] = self.current_page;
        dic[@"page_size"] = @"10000";

        [service post:@"repayment_paid" data:dic complete:^(NSDictionary *value1) {
            [service post:@"repayment_waitpay" data:dic complete:^(NSDictionary *value2) {
                NSMutableArray *list = [NSMutableArray new];

                for (NSDictionary *item in value2.arr(@"tender_list")) {
                    [list addObject:item];
                }

                for (NSDictionary *item in value1.arr(@"tender_list")) {
                    [list addObject:item];
                }

                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:list, @"tender_list", nil];
                [self tableHandleValue:dic];
            }];
        }];
    }
}

@end
