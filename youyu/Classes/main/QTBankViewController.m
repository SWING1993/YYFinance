//
//  QTBankViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/22.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBankViewController.h"
#import "QTBankCell.h"
#import "QTAddBankCardViewController.h"

#import "BankModel.h"

#import "UIViewController+page.h"

#import "QTWebViewController.h"

#import "QTAddItemView.h"
//#import "HRBindBankViewController.h"
#import "HRAddBankViewController.h"

@interface QTBankViewController ()<QTBankCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *bview;

@property (weak, nonatomic) IBOutlet UIButton   *btn1;
@property (weak, nonatomic) IBOutlet UIButton   *btn2;

@end

@implementation QTBankViewController
{
    NSMutableArray  *bank_list;
    NSDictionary    *selectDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"银行卡管理";
    TABLEReg(QTBankCell, @"QTBankCell");
}

- (void)addBank {
//    QTAddBankCardViewController *controller = [QTAddBankCardViewController controllerFromXib];
    HRAddBankViewController *controller = [HRAddBankViewController controllerFromXib];
//    controller.controller = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initUI {
    self.btn1.backgroundColor = Theme.redColor;
    self.btn2.backgroundColor = Theme.redColor;

    UIBarButtonItem *additem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBank)];

    self.navigationItem.rightBarButtonItem = additem;

    [self initTable];

    if (!self.isSelect) {
        [self addBottomView:self.bview];
        [self.btn1 click:^(id value) {
            [self toPay];
        }];
        [self.btn2 click:^(id value) {
            [self toWithdrew];
        }];
    }

    QTAddItemView *headview = [QTAddItemView viewNib];
    headview.title = @"添加银行卡";

    [self addHeadView:headview];
    WEAKSELF;
    [headview addTapGesture:^{
        [weakSelf addBank];
    }];
}

- (void)initData {
    self.isLockPage = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self firstGetData];
}

#pragma  mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bank_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"QTBankCell";

    QTBankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.bankdelegate = self;
    NSDictionary *dic = bank_list[indexPath.row][@"bank_info"];

    [cell bind:dic];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelect) {
        NSDictionary *dic = bank_list[indexPath.row][@"bank_info"];

        QTBankCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        if ([dic[@"is_verified"] isEqualToString:@"N"] && self.need_verified) {
            [self showToast:@"请先开通快捷支付!"];
        } else if (cell.isUpdate) {
            NSString *text = [BankModel getTipFormateForCode:dic.dic(@"bank_detail") state:QTbankStateQuick_bind];
            [self showToast:text duration:bankTipTime];
        } else {
            [self.bankDelegate bankSelect:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 如果编辑样式为删除样式
        selectDic = bank_list[indexPath.row][@"bank_info"];

        DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"提示" message:@"确认删除银行卡？"];

        [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];

        [alert addActionWithTitle:@"删除" handler:^(CKAlertAction *action) {
            [self deleteJson:selectDic[@"card_id"] index:indexPath];
        }];

        [alert show];
    }
}

#pragma  mark -
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无银行卡";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma  mark - select

- (void)BankUpdate:(NSString *)toast {
    [self showToast:toast duration:bankTipTime];
}

#pragma  mark - json

- (void)commonJson {
    [service post:@"bank_list" data:nil complete:^(NSDictionary *value) {
        bank_list = [NSMutableArray arrayWithArray:value.arr(@"bank_list")];
        [self tableHandle];
        if (bank_list.count) {
            NSDictionary *item = bank_list.firstObject;
            NSString *safe_card =item.str(@"bank_info.safe_card");
            if ([safe_card isEqualToString:@"Y"]) {
                [self removeTopView];
                self.navigationItem.rightBarButtonItem=nil;
            }
        }
    }];
}

- (void)deleteJson:(NSString *)bank_id index:(NSIndexPath *)index {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"card_id"] = bank_id;
    [service post:@"bank_unbinding" data:dic complete:^(NSDictionary *value) {
        NOTICE_POST(NOTICEBANK);
        [self hideHUD];

        [bank_list removeObjectAtIndex:index.row];
        NSArray *indexs = @[index];

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }];
}

@end
