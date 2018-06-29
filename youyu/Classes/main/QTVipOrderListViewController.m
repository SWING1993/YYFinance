//
//  QTVipOrderListViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/17.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVipOrderListViewController.h"
#import "QTBaseViewController+Table.h"
#import "SortDictionary.h"
#import "QTVipOrderCell.h"
#import "QTMyVipListViewController.h"

@interface QTVipOrderListViewController ()<SortDictionary, QTVipOrderDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewHead;

@end

@implementation QTVipOrderListViewController
{
    SortDictionary *sortDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"我的预约状态";

    TABLEReg(QTVipOrderCell, @"QTVipOrderCell");
}

- (void)initUI {
    [self initTable];
    [self addHeadView:self.viewHead];
}

- (void)initData {
    self.isLockPage = YES;

    sortDic = [SortDictionary new];
    sortDic.delegate = self;

    [self firstGetData];
}

- (BOOL)navigationShouldPopOnBackButton {
    [self toVipHome];
    return NO;
}

#pragma mark -table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortDic RowCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTVipOrderCell";

    QTVipOrderCell      *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithDictionary:[sortDic dataRow:indexPath] [@"reservation_info"]];

    cell.delegate = self;
    [cell bind:obj];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sortDic sectionCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];

    title.font = [UIFont systemFontOfSize:12];
    title.text = [NSString stringWithFormat:@" %@", [sortDic sectionTitle:section]];
    [title sizeToFit];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)vipOrderDidSelect:(NSDictionary *)item {
    QTMyVipListViewController *controller = [QTMyVipListViewController controllerFromXib];

    controller.customization_id = item.str(@"customization_id");
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)vipOrderCancel:(NSDictionary *)item {
    DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"提示" message:@"您要取消预约吗？"];

    [alert addActionWithTitle:@"返回" handler:^(CKAlertAction *action) {}];

    [alert addActionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        [self commonJsonCancel:item.str(@"customization_id")];
    }];

    [alert show];
}

#pragma  mark - json
- (NSString *)sortDictionaryKeyFilter:(NSString *)value {
    return [value stringWithDateFormat:@"yyyy-MM-dd"];
}

- (NSString *)listKey {
    return @"reservation_list";
}

- (void)dataFormat {
    [sortDic setDataWithKey:@"reservation_info.apply_time" array:self.tableDataArray];
}

- (void)commonJson {
    // 交易记录
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"check_status"] = @"";

    [service post:@"vipcustom_list" data:dic complete:^(id value) {
        [self tableHandleValue:value];
    }];
}

- (void)commonJsonCancel:(NSString *)orderID {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"customization_id"] = orderID;

    [service post:@"vipcustom_cancel" data:dic complete:^(id value) {
        [self showToast:@"预约已取消"];
        [self commonJson];
    }];
}

@end
