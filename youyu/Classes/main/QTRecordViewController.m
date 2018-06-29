//
//  QTRecordViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTRecordViewController.h"
#import "DOPDropDownMenu.h"
#import "RMCalendarController.h"
#import "QtRecordCell.h"
#import "SortDictionary.h"
#import "DSegmentedControl.h"
#import "NSString+model.h"
#import "NSDate+RMCalendarLogic.h"
#import "RecordModel.h"
#import "QTRecordDetailViewController.h"
#import "QTDetailsViewController.h"

#import "DropButton.h"

@interface QTRecordViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, DSegmentedControlDelegate, SortDictionary>
{
    NSArray *menuData;
    NSArray *menuTypeKey;

    NSString *accountType;

    NSInteger selectType;

    DropButton *btn;

    int selectBtnTag;

    SortDictionary *sortDic;

    NSDate  *sDate;
    NSDate  *eDate;
}

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet DSegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet UIButton *btnEnd;

@end

@implementation QTRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TABLEReg(QtRecordCell, @"QtRecordCell");
    self.navigationItem.rightBarButtonItem=nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    if ([[self.navigationController getPreviousController] isKindOfClass:[QTDetailsViewController class]]) {
        return YES;
    } else {
        [self toAccount];
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self firstGetData];
}

- (void)initUI {
    self.segment.delegate = self;
    [QTTheme segmentStyle1:self.segment];
    [self.segment AddSegumentArray:@[@"三个月", @"一年"]];
    [self.segment addGesture:self.view];

    [QTTheme btnGreenStyle:self.btnEnd];
    [QTTheme btnGreenStyle:self.btnStart];

    //

    self.canRefresh = YES;

    [self initTable];
    [self addHeadView:self.headView];

    // 日历
    RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];

    __weak RMCalendarController *weakC = c;

    c.isEnable = YES;
    c.calendarBlock = ^(RMCalendarModel *model) {
        NSString *data = [[NSDate systemDate]stringFromDate:model.date];

        if (selectBtnTag == 0) {
            sDate = model.date;
            [self.btnStart setTitle:data forState:UIControlStateNormal];
        } else if (selectBtnTag == 1) {
            eDate = model.date;
            [self.btnEnd setTitle:data forState:UIControlStateNormal];
        }

        [weakC.collectionView removeFromSuperview];

        if ([sDate compare:eDate] == NSOrderedAscending) {
            [self firstGetData];
        } else {
            [self showToast:@"结束时间大于起始时间"];
        }
    };

    [self.btnStart clickOn:^(id value) {
        selectBtnTag = 0;

        c.view.frame = self.tableView.frame;

        c.collectionView.top = self.headView.bottom;
        c.collectionView.height = self.tableView.height;

        [self.view insertSubview:c.collectionView aboveSubview:self.tableView];
    } off:^(id value) {
        [c.collectionView removeFromSuperview];
    }];

    [self.btnEnd clickOn:^(id value) {
        selectBtnTag = 1;

        c.view.frame = self.tableView.frame;

        c.collectionView.top = self.headView.bottom;
        c.collectionView.height = self.tableView.height;

        [self.view insertSubview:c.collectionView aboveSubview:self.tableView];
    } off:^(id value) {
        [c.collectionView removeFromSuperview];
    }];

    btn = [DropButton viewNib];

    if (self.isOrder) {
        menuData = @[@"投资订单", @"待支付", @"投资成功", @"投资失败"];
        menuTypeKey = @[@"0", @"1", @"2", @"3"];
        btn.lbtitle.text = @"投资订单";
    } else {
        RecordModel *model = [RecordModel new];
        menuData = model.list;
        menuTypeKey = model.listkey;
        btn.lbtitle.text = @"交易记录";
    }
    btn.lbtitle.textColor = NavBarTintColor;
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 0)];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];

    [btn clickDown:^(id value) {
        [menu selectColumn:0];
    }];
    btn.width = 150;
    btn.tintColor = NavBarTintColor;
    if (@available(iOS 11,*)) {
        btn.intrinsicContentSize = CGSizeMake(APP_WIDTH / 375 * 221, 44);
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.titleView = btn;
}

- (void)initData {
    self.isLockPage = YES;
    selectType = 0;
    sortDic = [SortDictionary new];
    sortDic.delegate = self;

    NSString *date = [NSString stringFromDate:[NSDate systemDate] Format:@"yyyy-MM-dd"];
    eDate = [NSDate systemDate];
    sDate = [NSDate systemDate];
    sDate = [sDate dayInTheFollowingMonth:-3];

    [self.btnEnd setTitle:date forState:UIControlStateNormal];
    [self.btnStart setTitle:[NSString stringFromDate:sDate Format:@"yyyy-MM-dd"] forState:UIControlStateNormal];
}

- (NSString *)sortDictionaryKeyFilter:(NSString *)value {
    return [value stringWithDateFormat:@"yyyy-MM"];
}

- (void)segumentSelectionChange:(NSInteger)selection {
    if (selection == 0) {
        NSString *date = [NSString stringFromDate:[NSDate systemDate] Format:@"yyyy-MM-dd"];
        eDate = [NSDate systemDate];
        sDate = [NSDate systemDate];
        sDate = [sDate dayInTheFollowingMonth:-3];

        [self.btnEnd setTitle:date forState:UIControlStateNormal];
        [self.btnStart setTitle:[NSString stringFromDate:sDate Format:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    } else {
        NSString *date = [NSString stringFromDate:[NSDate systemDate] Format:@"yyyy-MM-dd"];
        eDate = [NSDate systemDate];
        sDate = [NSDate systemDate];
        sDate = [sDate dayInTheFollowingMonth:-12];

        [self.btnEnd setTitle:date forState:UIControlStateNormal];
        [self.btnStart setTitle:[NSString stringFromDate:sDate Format:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    }

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
    static NSString *Identifier = @"QtRecordCell";

    QtRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    if (self.isOrder) {
        NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithDictionary:[sortDic dataRow:indexPath]];

        [cell bindOrder:obj];
    } else {
        NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithDictionary:[sortDic dataRow:indexPath] [@"log_info"]];

        [cell bind:obj];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isOrder) {
        QTRecordDetailViewController    *controller = [QTRecordDetailViewController controllerFromXib];
        NSDictionary                    *obj = self.tableDataArray[indexPath.row];

        controller.tender_id = obj.str(@"tender_id");
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma  mark - json
- (NSString *)listKey {
    if (self.isOrder) {
        return @"tender_list";
    } else {
        return @"log_list";
    }
}

- (void)dataFormat {
    if (self.isOrder) {
        [sortDic setDataWithKey:@"addtime" array:self.tableDataArray];
    } else {
        [sortDic setDataWithKey:@"log_info.addtime" array:self.tableDataArray];
    }
}

- (void)commonJson {
    if (self.isOrder) {
        // 订单记录
        NSMutableDictionary *dic = [NSMutableDictionary new];

        dic[@"cur_page"] = self.current_page;
        dic[@"page_size"] = PAGES_SIZE;
        dic[@"tender_status"] = menuTypeKey[selectType];
        dic[@"start_time"] = @(sDate.timeIntervalSince1970);
        dic[@"end_time"] = @(eDate.timeIntervalSince1970);

        [service post:@"corder_list_v2" data:dic complete:^(id value) {
            [self tableHandleValue:value];
        }];
    } else {
        // 交易记录
        NSMutableDictionary *dic = [NSMutableDictionary new];

        dic[@"cur_page"] = self.current_page;
        dic[@"page_size"] = PAGES_SIZE;
        dic[@"account_type"] = menuTypeKey[selectType];
        dic[@"start_time"] = [NSString stringFromDate:sDate Format:@"yyyyMMdd"];
        dic[@"end_time"] = [NSString stringFromDate:eDate Format:@"yyyyMMdd"];

        [service post:@"account_loglist" data:dic complete:^(id value) {
            [self tableHandleValue:value];
        }];
    }
}

@end
