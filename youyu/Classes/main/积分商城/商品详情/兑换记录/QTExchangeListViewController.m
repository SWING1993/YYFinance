//
//  QTExchangeListViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/18.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTExchangeListViewController.h"
#import "QTExchangeListCell.h"
#import "QTBaseViewController+Table.h"

@interface QTExchangeListViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewHead;
@end

@implementation QTExchangeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTExchangeListCell, @"QTExchangeListCell");
}

- (void)initUI {
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    [self addHeadView:self.viewHead];
}

- (void)initData {
    [self firstGetData];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString     *Identifier = @"QTExchangeListCell";
    QTExchangeListCell  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor colorHex:@"F1F2F4"];
    }

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"exchange_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma  mark - json

- (NSString *)listKey {
    return @"exchange_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"good_id"] = self.goodId;
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = @(20);
    [service post:@"pgoods_exchangelist" data:dic complete:^(id value) {
        [self tableHandleValue:value];
    }];
}

@end
