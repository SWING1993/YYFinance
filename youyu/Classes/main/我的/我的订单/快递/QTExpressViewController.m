//
//  QTExpressViewController.m
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTExpressViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTExpressCell.h"
#import "QTExpressModel.h"

@interface QTExpressViewController ()
@property (strong, nonatomic) IBOutlet UIView   *viewhead;
@property (weak, nonatomic) IBOutlet UILabel    *lbtitile;

@end

@implementation QTExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"物流信息";
    self.navigationItem.rightBarButtonItem = nil;

    TABLEReg(QTExpressCell, @"QTExpressCell");
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];

    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];

    [self addHeadView:self.viewhead];
}

- (void)initData {
    self.isLockPage = YES;
    [self firstGetData];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTExpressCell";
    QTExpressCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    if (indexPath.row == 0) {
        cell.type = ExpressCellTypeFirst;
    } else if (indexPath.row == self.tableDataArray.count - 1) {
        cell.type = ExpressCellTypeLast;
    } else {
        cell.type = ExpressCellTypeList;
    }

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"QTExpressCell" cacheByIndexPath:indexPath configuration:^(QTExpressCell *cell) {
               NSDictionary *dic = self.tableDataArray[indexPath.row];

               if (indexPath.row == 0) {
                   cell.type = ExpressCellTypeFirst;
               } else if (indexPath.row == self.tableDataArray.count - 1) {
                   cell.type = ExpressCellTypeLast;
               } else {
                   cell.type = ExpressCellTypeList;
               }

               [cell bind:dic];
           }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];

    title.text = @"     物流跟踪";
    title.textColor = [UIColor grayColor];
    [title sizeToFit];
    title.font = [UIFont systemFontOfSize:14];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无物流信息";

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
    return @"data";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"key"] = @"25f0c5108aaae5f125c28b394ee0d56e";
    dic[@"express_company_type"] = [QTExpressModel getType:self.express_company_type.integerValue];
    dic[@"express_no"] = self.express_no;
    [service post:@"express_details" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];

        NSString *company = [QTExpressModel getName:[self.express_company_type integerValue]];

        self.lbtitile.text = [NSString stringWithFormat:@"快递公司: %@\n快递单号: %@", company, value.str(@"nu")];
    }];
}

@end
