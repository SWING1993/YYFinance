//
//  QTAddressController.m
//  qtyd
//
//  Created by yl on 15/10/8.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTAddressController.h"
#import "QTAddressCell.h"
#import "QTBaseViewController+Table.h"
#import "QTAddAddressController.h"
#import "UIViewController+page.h"
#import "QTAddItemView.h"

@interface QTAddressController ()<SWTableViewCellDelegate>

@end

@implementation QTAddressController
{
    NSDictionary    *selectedDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"收货地址管理";

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    TABLEReg(QTAddressCell, @"addresscell");

    [self initRightBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self firstGetData];// 刷新表数据
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];
    QTAddItemView *headview = [QTAddItemView viewNib];
    headview.title = @"添加联系地址\n用于寄送礼品";

    [self addHeadView:headview];
    WEAKSELF;
    [headview addTapGesture:^{
        [weakSelf addAddress];
    }];
}

- (void)initRightBarButtonItem {
    UIBarButtonItem *additem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddress)];

    self.navigationItem.rightBarButtonItem = additem;
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"addresscell";
    QTAddressCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    cell.delegate = self;

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"address_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"addresscell" cacheByIndexPath:indexPath configuration:^(QTAddressCell* cell) {
            NSDictionary *dic = self.tableDataArray[indexPath.row][@"address_info"];

            [cell bind:dic];
        }];

    return height < 60 ? 60 : height;
}

//选中操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedDic = self.tableDataArray[indexPath.row][@"address_info"];

    if (self.isSelected) {
        [self.delegate AddressController:self didSelectAreaId:selectedDic];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        QTAddAddressController *controller = [QTAddAddressController controllerFromXib];
        controller.param = selectedDic;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - swipp

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

    selectedDic = self.tableDataArray[cellIndexPath.row][@"address_info"];
    switch (index) {
        case 0:
            {
                QTAddAddressController *controller = [QTAddAddressController controllerFromXib];
                controller.param = selectedDic;
                [self.navigationController pushViewController:controller animated:YES];

                break;
            }

        case 1:
            {
                DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"提示" message:@"确认删除此地址？"];

                [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
                [alert addActionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                    [self deleteAddress:selectedDic index:cellIndexPath]; //删除地址
                }];

                [alert show];

                break;
            }

        default:
            break;
    }
}

#pragma mark - empty

- (void)addAddress {
    QTAddAddressController *controller = [QTAddAddressController controllerFromXib];

    [self.navigationController pushViewController:controller animated:YES];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无地址";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma  mark - json

- (NSString *)listKey {
    return @"address_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [service post:@"user_addresslist" data:dic complete:^(id value) {
        NSUInteger addressCount = ((NSDictionary *)value[@"address_list"]).count;

        if (addressCount > 0) {
            [GVUserDefaults  shareInstance].address_exists = @"1";

            if (addressCount == 5) {
                self.navigationItem.rightBarButtonItem = nil;
            } else {
                [self initRightBarButtonItem];
            }
        } else {
            [GVUserDefaults  shareInstance].address_exists = @"2";
            [self initRightBarButtonItem];
        }

        [self tableHandleValue:value];
    }];
}

/**
 *  删除地址
 *
 *  @param addressInfo
 */
- (void)deleteAddress:(NSDictionary *)addressInfo index:(NSIndexPath *)index {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address_id"] = addressInfo[@"id"];
    [service post:@"user_addressdelete" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        NOTICE_POST(NOTICEBANK);

        self.tableDataArray = [self.tableDataArray remove:self.tableDataArray[index.row]];

        NSArray *indexs = @[index];

        if (self.tableDataArray.count == 0) {
            [GVUserDefaults  shareInstance].address_exists = 0;
            [[GVUserDefaults  shareInstance] saveLocal];
        }

        [self.tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationRight];

        [self showToast:@"删除地址成功"];
    }];
}

@end
