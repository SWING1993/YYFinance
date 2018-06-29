//
//  QTRepaymentScheduleViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/9.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRepaymentScheduleViewController.h"
#import "SortDictionary.h"
#import "QTRepaymentScheduleCell.h"
#import "QTBaseViewController+Table.h"
#import "QTRepaymentDetailViewController.h"

@interface QTRepaymentScheduleViewController ()
{
    SortDictionary *sortDic;

    NSDictionary *currentData;
}

@property (strong, nonatomic) IBOutlet UIView *viewHead;

@end

@implementation QTRepaymentScheduleViewController
{
    BOOL notScroller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"还款日程";

    TABLEReg(QTRepaymentScheduleCell, @"QTRepaymentScheduleCell");

    [self setRightNavItemImage:[[UIImage imageNamed:@"icon_detail"] imageWithColor:[UIColor whiteColor]]];
}

- (void)rightClick {
    [self toRepaymentDetail];
}

- (void)initUI {
    //
    [self initTable];
    [self addHeadView:self.viewHead];
}

- (void)initData {
    self.isLockPage = YES;
    sortDic = [SortDictionary new];
    sortDic.ascending = YES;

    [self showHUD];
    [self commonJsonNow];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortDic RowCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString         *Identifier = @"QTRepaymentScheduleCell";
    QTRepaymentScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSDictionary            *dic = [sortDic dataRow:indexPath][@"repayment_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QTRepaymentDetailViewController *controller = [QTRepaymentDetailViewController controllerFromXib];

    controller.borrowDic = [sortDic dataRow:indexPath][@"repayment_info"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sortDic sectionCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];

    NSInteger days = [NSDate numberOfDays:[sortDic sectionTitle:section].dateTypeValue reduce:[NSDate systemDate]];

    NSString *time = [sortDic sectionTitle:section];

    NSString *week = [time.dateTypeValue compareIfTodayWithDate];

    if ([week isEqualToString:@"今天"]) {
        week = @"";
    }

    NSString *strDay;

    if (days > 0) {
        strDay = [NSString stringWithFormat:@"%ld天后", (long)days];
        title.text = [NSString stringWithFormat:@"  %@ (%@ %@)", time.dateValue, strDay, week];
    } else if (days < 0) {
        title.text = [NSString stringWithFormat:@"  %@", time.dateValue];
    } else {
        strDay = @"今天";
        title.text = [NSString stringWithFormat:@"  %@ (%@ %@)", time.dateValue, strDay, week];
    }

    [title sizeToFit];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [Theme grayColor];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"\n\n暂无还款";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma  mark json
- (NSString *)listKey {
    return @"repayment_list";
}

- (NSString *)sortDictionaryKeyFilter:(NSString *)value {
    return [value stringWithDateFormat:@"yyyy-MM"];
}

- (void)dataFormat {
    [sortDic setDataWithKey:@"repayment_info.repay_time" array:self.tableDataArray];
}

- (void)commonJsonNow {
    [service post:@"repayment_schedule" data:nil complete:^(NSDictionary *value) {
        currentData = value;
        [self tableHandleValue:value];
    }];
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = @"1";
    dic[@"start_time"] = @(@"2014-08-01 00:00:00".timeIntervalValue);
    dic[@"end_time"] = @(@([NSDate systemDate].timeIntervalSince1970).integerValue);
    [service post:@"repayment_schedulehistory" data:dic complete:^(NSDictionary *value) {
        NSMutableArray *list = [NSMutableArray new];

        for (NSDictionary *item in value.arr(@"repayment_list")) {
            [list addObject:item];
        }

        SortDictionary *tempSort = [[SortDictionary alloc]init];
        [tempSort setDataWithKey:@"repayment_info.repay_time" array:list];

        if (currentData) {
            for (NSDictionary *item in currentData.arr(@"repayment_list")) {
                [list addObject:item];
            }
        }

        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:list, @"repayment_list", nil];
        [self tableHandleValue:dic];

        if (!notScroller && (currentData.arr(@"repayment_list").count > 0)) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[tempSort sectionCount]] animated:NO scrollPosition:UITableViewScrollPositionTop];
            notScroller = YES;
        }
    }];
}

@end
