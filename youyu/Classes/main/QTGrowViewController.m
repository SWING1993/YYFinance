//
//  QTGrowViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTGrowViewController.h"

#import "SortDictionary.h"

#import "QTBaseViewController+Table.h"
#import "QTGrowCell.h"

#import "DFormAdd.h"

#import "QTVipView.h"

#import "QTRankView.h"

#import "QTWebViewController.h"

@interface QTGrowViewController ()<SortDictionary>

@property (strong, nonatomic) IBOutlet UIView   *headview;
@property (weak, nonatomic) IBOutlet UILabel    *lbName;

@property (weak, nonatomic) IBOutlet UILabel        *lbGrow;
@property (strong, nonatomic) IBOutlet UIView       *viewTip1;
@property (strong, nonatomic) IBOutlet UIView       *viewTip2;
@property (weak, nonatomic) IBOutlet UIScrollView   *scroller;
@property (weak, nonatomic) IBOutlet UILabel        *lbNum;

@end

@implementation QTGrowViewController
{
    SortDictionary  *sortDic;
    QTRankView      *rankview;

    DWrapView *wrap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTGrowCell, @"QTGrowCell");
    self.titleView.title = @"成长特权";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initTable];
}

- (void)initData {
    self.isLockPage = YES;
    sortDic = [SortDictionary new];
    sortDic.delegate = self;

    //
    self.lbName.text = [GVUserDefaults shareInstance].nick_name;

    //
    WEAKSELF;
    [self.viewTip1 addTapGesture:^{
       
        [weakSelf showToast:@"V3及以上会员可享此特权"];
    }];
    [self.viewTip2 addTapGesture:^{
        QTWebViewController *controller = [QTWebViewController new];

        controller.titleView.title = @"如何获得成长值";

        NSString *url = WEB_URL(@"/article/article_detail_app/notice/1012");

        controller.url = url;

        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    [self commonJsonGet];

    [self firstGetData];
}

#pragma mark -table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sortDic RowCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTGrowCell";

    QTGrowCell          *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithDictionary:[sortDic dataRow:indexPath] [@"log_info"]];

    [cell bind:obj];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sortDic sectionCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];

    title.text = @"    ".add([sortDic sectionTitle:section]).add(@"月");
    [title sizeToFit];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor darkGrayColor];
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
    [sortDic setDataWithKey:@"log_info.add_time" array:self.tableDataArray];
}

- (void)commonJsonGet {
    [service post:@"puser_home" data:nil complete:^(NSDictionary *value) {
        NSString *level = value.str(@"user_level");
        NSInteger userLevel = [level stringByReplacingOccurrencesOfString:@"V" withString:@""].integerValue;

        NSString *str = [NSString stringWithFormat:@"当前成长值: %@      到达V%@还需: %@", value.str(@"current_growth"), @(userLevel + 1), value.str(@"growth_need")];

        if (userLevel == 7) {
            str = [NSString stringWithFormat:@"当前成长值: %@      恭喜您已到达最高等级V7!", value.str(@"current_growth")];
        }

        NSMutableAttributedString *growthStr = [[NSMutableAttributedString alloc]initWithString:str];
        [growthStr setColor:[UIColor yellowColor] string:value.str(@"current_growth")];
        [growthStr setColor:[UIColor yellowColor] string:value.str(@"growth_need")];
        self.lbGrow.attributedText = growthStr;

        [service post:@"puser_privilegelist" data:nil complete:^(NSDictionary *value) {
            DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

            self.headview.width = APP_WIDTH;
            [stack addView:self.headview margin:UIEdgeInsetsZero];

            rankview = [[QTRankView alloc]initWithFrame:CGRectMake(0, 0, 600, 30)];
            [self.scroller addSubview:rankview];
            self.scroller.contentSize = CGSizeMake(rankview.width, 0);

            self.headview.backgroundColor = Theme.mainOrangeColor;
            [stack addView:self.viewTip1 margin:UIEdgeInsetsZero];

            wrap = [[DWrapView alloc]initWidth:APP_WIDTH columns:4];
            wrap.subHeight = APP_WIDTH / 4 + 0.3;
            wrap.backgroundColor = Theme.backgroundColor;

            NSInteger sumPower = 0;

            for (int i = 0; i < value.arr(@"privilege_list").count; i++) {
                QTVipView *view = [QTVipView viewNib];

                NSDictionary *item = [value.arr(@"privilege_list") objectAtIndex:i][@"privilege_info"];

                NSInteger needLevel = [item.str(@"level") stringByReplacingOccurrencesOfString:@"V" withString:@""].integerValue;

                if (userLevel >= needLevel) {
                    [view.lbImage setImageWithURLString:item.str(@"light_image_full") placeholderImageString:@"mall_default"];
                    sumPower++;
                } else {
                    [view.lbImage setImageWithURLString:item.str(@"dark_image_full") placeholderImageString:@"mall_default"];
                }

                view.text = item.str(@"privilege_name");
                view.radioWidth = 35;
                view.layer.borderWidth = 0.5;
                view.layer.borderColor = [Theme borderColor].CGColor;
                [wrap addView:view margin:UIEdgeInsetsMake(0, 0, 0, 0)];
            }

            self.lbNum.text = [NSString stringWithFormat:@"%ld项", (long)sumPower];
            [stack addView:wrap margin:UIEdgeInsetsZero];

            [stack addView:self.viewTip2 margin:UIEdgeInsetsZero];
            self.tableView.tableHeaderView = stack;

            [rankview setImage:[GVUserDefaults  shareInstance].app_litpic rank:level];
            [self.scroller setContentOffset:CGPointMake(rankview.scrollOffsetX, 0) animated:YES];
        }];
    }];
}

- (void)commonJson {
    // 成长记录
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    [service post:@"mall_growthlog" data:dic complete:^(id value) {
        [self tableHandleValue:value];
    }];
}

@end
