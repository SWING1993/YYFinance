//
//  QTMessageViewController.m
//  qtyd
//
//  Created by stephendsw on 2016/11/14.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMessageViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTMessageCell.h"

@interface QTMessageViewController ()
@property (strong, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton   *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton   *readBtn;
@property (weak, nonatomic) IBOutlet UIButton   *deleteBtn;

@end

@implementation QTMessageViewController
{
    NSInteger                       *articleId;
    NSMutableArray<NSIndexPath *>   *dropList;

    NSMutableArray<CALayer *> *tipViews;

    NSMutableArray<NSIndexPath *> *selectedRows;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TABLEReg(QTMessageCell, @"QTMessageCell");
}

- (void)initUI {
    tipViews = [NSMutableArray new];

    for (int i = 0; i < 4; i++) {
        CALayer *tipView = [CALayer new];
        tipView.contents = (__bridge id)[UIImage imageNamed:@"icon_xiaoxitishi_zhanghu"].CGImage;
        [tipViews addObject:tipView];
    }

    self.canRefresh = YES;
    [self initTable];
    self.tableView.tintColor = [Theme redColor];

    [self onBtnStyle];
    [self.bottomView setTopLine:[Theme lightGrayColor]];
}

- (void)initData {
    selectedRows = [NSMutableArray new];
    dropList = [NSMutableArray new];

    [self.selectBtn setImage:[UIImage imageNamed:@"icon_login_unselect"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"icon_login_select"] forState:UIControlStateSelected];

    [self.selectBtn clickOn:^(id value) {
        for (int i = 0; i < self.tableDataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [selectedRows addObject:indexPath];
        }

        [self onBtnStyle];
    } off:^(id value) {
        for (int i = 0; i < self.tableDataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            [selectedRows removeObject:indexPath];
        }

        [self offBtnStyle];
    }];

    [self.deleteBtn click:^(id value) {
        if ([self.tableView indexPathsForSelectedRows].count > 0) {
            DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"" message:@"确认删除?"];

            [alert addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];

            [alert addActionWithTitle:@"确认" handler:^(CKAlertAction *action) {
                [self commonJsonDelete];
            }];

            [alert show];
        }
    }];

    [self.readBtn click:^(id value) {
        if ([self.tableView indexPathsForSelectedRows].count > 0) {
            [self commonJsonRead];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editing)];
    self.navigationController.navigationItem.rightBarButtonItem = item;
    self.tableView.editing = NO;
    [self.bottomView removeFromSuperview];

    [self showHUD];
    [self  commonJson];
}

- (void)editing {
    if (!self.tableView.editing) {
        self.tableView.editing = YES;
        self.navigationController.navigationItem.rightBarButtonItem.title = @"完成";
        [self addBottomView:self.bottomView];
        [self offBtnStyle];
    } else {
        self.tableView.editing = NO;
        self.navigationController.navigationItem.rightBarButtonItem.title = @"编辑";
        [self removeBottomView];
    }
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTMessageCell";
    QTMessageCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    NSMutableDictionary *dicNew = [[NSMutableDictionary alloc]initWithDictionary:dic];

    if (![dropList containsObject:indexPath]) {
        cell.shortContent = YES;
    } else {
        cell.shortContent = NO;
    }

    [cell bind:dicNew];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"QTMessageCell" cacheByIndexPath:indexPath configuration:^(QTMessageCell* cell) {
            NSDictionary *dic = self.tableDataArray[indexPath.row];

            if (![dropList containsObject:indexPath]) {
                ((QTMessageCell *)cell).shortContent = YES;
            } else {
                ((QTMessageCell *)cell).shortContent = NO;
            }

            [cell bind:dic];
        }];

    if ([dropList containsObject:indexPath]) {
        return height;
    } else {
        if (height < 100) {
            return height;
        }

        return 100;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//选中操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing) {
        if ([dropList containsObject:indexPath]) {
            [dropList removeObject:indexPath];
        } else {
            [dropList addObject:indexPath];
        }

        NSMutableDictionary *dic = self.tableDataArray[indexPath.row];

        if (dic.i(@"read_state") == 0) {
            [self commonJsonRead];
        } else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        [selectedRows addObject:indexPath];

        if ([tableView indexPathsForSelectedRows] == 0) {
            [self offBtnStyle];
        } else {
            [self onBtnStyle];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        [selectedRows removeObject:indexPath];

        if ([tableView indexPathsForSelectedRows] == 0) {
            [self offBtnStyle];
        } else {
            [self onBtnStyle];
        }
    }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"\n\n您暂无新消息!!!";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - style

- (void)onBtnStyle {
    NSArray *indexs = [self.tableView indexPathsForSelectedRows];

    bool allRead = YES;

    for (NSIndexPath *index in indexs) {
        NSDictionary *dic = self.tableDataArray[index.row];

        if (dic.i(@"read_state") == 0) {
            allRead = NO;
        }
    }

    [QTTheme btnRedStyle:self.deleteBtn];
    self.deleteBtn.cornerRadius = 0;

    if (allRead) {
        [QTTheme btnGrayStyle:self.readBtn];
        self.readBtn.cornerRadius = 0;
    } else {
        [QTTheme btnRedStyle:self.readBtn];
        self.readBtn.cornerRadius = 0;
    }
}

- (void)offBtnStyle {
    [QTTheme btnGrayStyle:self.deleteBtn];
    self.deleteBtn.cornerRadius = 0;
    [QTTheme btnGrayStyle:self.readBtn];
    self.readBtn.cornerRadius = 0;
    self.selectBtn.selected = NO;
}

#pragma  mark - json

- (NSString *)listKey {
    return @"message_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"begin_time"] = @"915123661";
    dic[@"end_time"] = @"4070883661";
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"type_id"] = self.type;

    [service post:@"webMessage_list" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];

        for (int i = 0; i < selectedRows.count; i++) {
            NSIndexPath *indexPath = selectedRows[i];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }

        [self commonJsonNewNum];
    }];
}

- (void)commonJsonDelete {
    [self showHUD];
    NSMutableString *idsStr = [NSMutableString new];

    for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
        NSMutableDictionary *dic = self.tableDataArray[indexPath.row];
        [idsStr appendString:[NSString stringWithFormat:@"%@_%@,", dic.str(@"id"), dic.str(@"type_id")]];
    }

    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"values"] = idsStr;
    [service post:@"webMessage_delete" data:dic complete:^(id value) {
        [self hideHUD];

        for (int i = 0; i < selectedRows.count; i++) {
            [((NSMutableArray *)self.tableDataArray) removeObjectAtIndex:selectedRows[i].row];
            [selectedRows removeObjectAtIndex:i];
        }

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];

        [self commonJsonNewNum];
    }];
}

- (void)commonJsonRead {
    [self showHUD];
    NSMutableString *idsStr = [NSMutableString new];

    NSArray<NSIndexPath *> *indexlist = [self.tableView indexPathsForSelectedRows];

    for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
        NSMutableDictionary *dic = self.tableDataArray[indexPath.row];
        [idsStr appendString:[NSString stringWithFormat:@"%@_%@,", dic.str(@"id"), dic.str(@"type_id")]];
    }

    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"values"] = idsStr;
    [service post:@"webMessage_readMark" data:dic complete:^(id value) {
        for (NSIndexPath *index in indexlist) {
            NSMutableDictionary *tempdic = self.tableDataArray[index.row];
            tempdic[@"read_state"] = @"1";
        }

        [self.tableView reloadData];
        [self hideHUD];

        [self commonJsonNewNum];
    }];
}

- (void)commonJsonNewNum {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"begin_time"] = @"915123661";
    dic[@"end_time"] = @"4070883661";
    dic[@"cur_page"] = @"1";
    dic[@"page_size"] = @"1";
    dic[@"type_id"] = self.type;

    [service post:@"webMessage_list" data:dic complete:^(NSDictionary *value) {
        WMPageController *controller = (WMPageController *)self.parentViewController;

        if ([controller isKindOfClass:[WMPageController class]]) {
            for (CALayer *layer in controller.menuView.layer.sublayers) {
                if (layer.bounds.size.width == 16) {
                    layer.opacity = 0;
                }
            }
        }

        if (value.i(@"unread_activity_notice") + value.i(@"unread_info") + value.i(@"unread_system_notice") > 0) {
            tipViews[0].frame = CGRectMake(APP_WIDTH / 4 * (0 + 1) - 20, 5, 16, 16);

            tipViews[0].opacity = 1;
            [controller.menuView.layer addSublayer:tipViews[0]];
        } else {
            [tipViews[0] removeFromSuperlayer];
        }

        if (value.i(@"unread_system_notice") > 0) {
            tipViews[1].frame = CGRectMake(APP_WIDTH / 4 * (1 + 1) - 20, 5, 16, 16);
            tipViews[1].opacity = 1;
            [controller.menuView.layer addSublayer:tipViews[1]];
        } else {
            [tipViews[1] removeFromSuperlayer];
        }

        if (value.i(@"unread_info") > 0) {
            tipViews[2].frame = CGRectMake(APP_WIDTH / 4 * (2 + 1) - 20, 5, 16, 16);
            tipViews[2].opacity = 1;
            [controller.menuView.layer addSublayer:tipViews[2]];
        } else {
            [tipViews[2] removeFromSuperlayer];
        }

        if (value.i(@"unread_activity_notice") > 0) {
            tipViews[3].frame = CGRectMake(APP_WIDTH / 4 * (3 + 1) - 20, 5, 16, 16);
            tipViews[3].opacity = 1;
            [controller.menuView.layer addSublayer:tipViews[3]];
        } else {
            [tipViews[3] removeFromSuperlayer];
        }
    }];
}

@end
