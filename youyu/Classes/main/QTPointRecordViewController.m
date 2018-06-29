//
//  QTPointRecordViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/1.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTPointRecordViewController.h"
#import "DropButton.h"
#import "DOPDropDownMenu.h"
#import "RMCalendarController.h"
#import "SortDictionary.h"
#import "NSDate+RMCalendarLogic.h"
#import "QTBaseViewController+Table.h"
#import "QTPointRecordCell.h"
#import "QTSelectTime.h"
#import "QTWebViewController.h"
@interface QTPointRecordViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, SortDictionary, QTSelectTimeDelegate>

@property (weak, nonatomic) IBOutlet UILabel    *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel    *lbOutdate;

@property (strong, nonatomic) IBOutlet UIView   *headView;
@property (weak, nonatomic) IBOutlet UIView     *itemView;

@end

@implementation QTPointRecordViewController
{
    NSArray *menuData;
    NSArray *menuTypeKey;

    NSString *accountType;

    NSInteger selectType;

    DropButton      *btn;
    SortDictionary  *sortDic;
    QTSelectTime    *selectTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TABLEReg(QTPointRecordCell, @"QTPointRecordCell");
}

- (void)initUI {
    [self addHeadView:self.headView];
    [self initTable];

    selectTime = [QTSelectTime viewNib];
    [selectTime setTimeInView:self.tableView];
    selectTime.delegate = self;
    selectTime.width = APP_WIDTH;
    selectTime.height = 44;
    [self.itemView addSubview:selectTime];

}

// 子类重写
- (void)setupNavigationItems {
    [super setupNavigationItems];
    menuData = @[@"全部明细", @"收入明细", @"支出明细"];
    menuTypeKey = @[@"", @"1", @"2"];
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 0)];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    btn = [DropButton viewNib];
    btn.lbtitle.text = menuData.firstObject;
    btn.lbtitle.textColor = NavBarTintColor;
    [btn clickDown:^(id value) {
        [menu selectColumn:0];
    }];
    btn.width = 150;

    if (@available(iOS 11,*)) {
        btn.intrinsicContentSize = CGSizeMake(APP_WIDTH / 375 * 221, 44);
    }
    self.navigationItem.titleView = btn;
}

- (void)initData {
    self.isLockPage = YES;
    selectType = 0;
    sortDic = [SortDictionary new];
    sortDic.delegate = self;

    [self firstGetData];
}

#pragma mark - event
- (void)questClick {
    QTWebViewController *controller = [QTWebViewController new];
    controller.titleView.title = @"常见问题";
    NSString *url = WEB_URL(@"/article/article_detail_app/notice/1011");
    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - select time
- (void)selectTimeStart:(NSDate *)s end:(NSDate *)e {
    [self firstGetData];
}

#pragma mark - menu
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return menuData.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return menuData[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSString *title = [menu titleForRowAtIndexPath:indexPath];
    btn.lbtitle.text = title;
    selectType = indexPath.row;
    [btn hide];
    [self firstGetData];
}

#pragma mark -table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortDic RowCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTPointRecordCell";

    QTPointRecordCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithDictionary:[sortDic dataRow:indexPath] [@"log_info"]];

    [cell bind:obj];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"QTPointRecordCell" cacheByIndexPath:indexPath configuration:^(QTPointRecordCell* cell) {
               NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithDictionary:[sortDic dataRow:indexPath] [@"log_info"]];

               [cell bind:obj];
           }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sortDic sectionCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];

    title.text = @" ".add([sortDic sectionTitle:section]).add(@"月");
    [title sizeToFit];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma  mark - json
- (NSString *)sortDictionaryKeyFilter:(NSString *)value {
    return [value stringWithDateFormat:@"yyyy-MM"];
}

- (NSString *)listKey {
    return @"log_list";
}

- (void)dataFormat {
    [sortDic setDataWithKey:@"log_info.addtime" array:self.tableDataArray];
}

- (void)commonJson {
    [service post:@"mall_point" data:nil complete:^(NSDictionary *value) {
        NSString *point = [NSString stringWithFormat:@"%@\n当前可用积分", value.str(@"available_point")];
        NSMutableAttributedString *pointStr = [[NSMutableAttributedString alloc]initWithString:point];
        [pointStr setColor:Theme.darkOrangeColor string:value.str(@"available_point")];
        [pointStr setFont:[UIFont systemFontOfSize:20] string:value.str(@"available_point")];
        [pointStr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
            Paragraph.lineSpacing = 10;
        }];
        self.lbPoint.attributedText = pointStr;
        self.lbPoint.textAlignment = NSTextAlignmentCenter;

        NSString *outdate = [NSString stringWithFormat:@"%@\n%@天后即将过期的积分", value.str(@"expire_point"), value.str(@"expire_day")];
        NSMutableAttributedString *outdateStr = [[NSMutableAttributedString alloc]initWithString:outdate];
        [outdateStr setColor:Theme.darkOrangeColor string:value.str(@"expire_point")];
        [outdateStr setFont:[UIFont systemFontOfSize:20] string:value.str(@"expire_point")];
        [outdateStr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
            Paragraph.lineSpacing = 10;
        }];
        self.lbOutdate.attributedText = outdateStr;
        self.lbOutdate.textAlignment = NSTextAlignmentCenter;
    }];

    // 交易记录
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"point_type"] = menuTypeKey[selectType];
    dic[@"source_type"] = @"";
    dic[@"add_start_time"] = selectTime.sDateStr;
    dic[@"add_end_time"] = selectTime.eDateStr;

    [service post:@"mall_pointlog" data:dic complete:^(id value) {
        [self tableHandleValue:value];
    }];
}

@end
