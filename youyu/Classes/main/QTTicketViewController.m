//
//  QTTicketViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTTicketViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTTicketCell.h"
#import "QTAddItemView.h"

@interface QTTicketViewController ()

@end

@implementation QTTicketViewController
{}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleView.title = @"加息券";

    TABLEReg(QTTicketCell, @"ticketcell");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commonJson) name:@"reward" object:nil];
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
}

- (void)initData {
    self.isLockPage = YES;
    [self tableRrefresh];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"ticketcell";
    QTTicketCell    *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"coupon_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂时没有加息券";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
    [str appendImage:[UIImage imageNamed:@"icon_tanghao"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
    [str setFont:[UIFont systemFontOfSize:12] string:text];
    return str;
}

#pragma  mark - json

- (NSString *)listKey {
    return @"coupon_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"coupon_type"] = @"";
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    [service post:@"user_coupon" data:dic complete:^(id value) {
        [self tableHandleValue:value];
    }];
}

@end
