//
//  QTMallListViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/16.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMallListViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTMallListCell.h"

@interface QTMallListViewController ()
@property (strong, nonatomic) IBOutlet UIView   *viewHead;
@property (weak, nonatomic) IBOutlet UIButton   *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@end

@implementation QTMallListViewController
{
    NSString *sort_type;

    NSArray<UIButton *> *btnList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TABLEReg(QTMallListCell, @"QTMallListCell");
    self.navigationItem.title = @"商品列表";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    sort_type = @"1";
    [self initTable];

    [self addHeadView:self.viewHead];
    self.viewHead.width = APP_WIDTH;
    [self.viewHead setBottomLine:[Theme borderColor]];

    btnList = @[self.btn1, self.btn2, self.btn3];
    int i = 1;

    for (UIButton *item in btnList) {
        [self setButton:item Status:0];

        [item clickOn:^(id value) {
            sort_type = @(i).stringValue;
            [self setButton:item Status:1];
            [self firstGetData];

            for (UIButton *item2 in btnList) {
                if (![item2 isEqual:item]) {
                    [self setButton:item2 Status:0];
                }
            }
        } off:^(id value) {
            sort_type = @(i + 1).stringValue;
            [self setButton:item Status:2];
            [self firstGetData];

            for (UIButton *item2 in btnList) {
                if (![item2 isEqual:item]) {
                    [self setButton:item2 Status:0];
                }
            }
        }];

        i += 2;
    }
}

- (BOOL)navigationShouldPopOnBackButton {
    [self toMallHome];
    return NO;
}

- (void)setButton:(UIButton *)btn Status:(NSInteger)s {
    btn.backgroundColor = [UIColor whiteColor];

    if (s == 0) {
        [btn setImage:[UIImage imageNamed:@"icon_btn_normal"] forState:UIControlStateNormal];
        btn.selected = NO;
    }

    if (s == 1) {
        [btn setImage:[UIImage imageNamed:@"icon_btn_down"] forState:UIControlStateSelected];
    }

    if (s == 2) {
        [btn setImage:[UIImage imageNamed:@"icon_btn_up"] forState:UIControlStateNormal];
    }
}

- (void)initData {
    [self firstGetData];
}

#pragma  mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTMallListCell";

    QTMallListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"goods_info"];

    [cell bind:dic];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"goods_info"];

    [self toMallDetail:dic.str(@"id")];
}

- (NSString *)listKey {
    return @"goods_list";
}

#pragma  mark - json

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = pageSize;
    dic[@"sort_type"] = sort_type;
    dic[@"sort_column"] = @"1";

    [service post:@"pgoods_list" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];
    }];
}

@end
