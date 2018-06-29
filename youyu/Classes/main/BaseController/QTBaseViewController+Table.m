//
//  QTBaseViewController+Table.m
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTBaseViewController+Table.h"
#import <objc/runtime.h>

#define START_PAGE @"1"

@implementation QTBaseViewController (Table)

static char *total_countkey;
static char *total_pagekey;
static char *current_pagekey;
static char *TableDataArraykey;
static char *allDataArraykey;
static char *fullProjectDataArraykey;
static char *RapaidProjectDataArraykey;
static char *investingProjectDataArraykey;


#pragma mark - set get

- (void)setTableDataArray:(NSArray *)tableDataArray {
    objc_setAssociatedObject(self, &TableDataArraykey, tableDataArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)tableDataArray  {
    return objc_getAssociatedObject(self, &TableDataArraykey);
}

- (void)setAllDataArray:(NSMutableArray *)allDataArray{
    objc_setAssociatedObject(self, &allDataArraykey, allDataArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray*)allDataArray{
   return  objc_getAssociatedObject(self, &allDataArraykey);
}

- (void)setFullProjectDataArray:(NSArray *)fullProjectDataArray{
    objc_setAssociatedObject(self, &fullProjectDataArraykey, fullProjectDataArray, OBJC_ASSOCIATION_RETAIN);
}
- (NSArray*)fullProjectDataArray{

    return objc_getAssociatedObject(self, &fullProjectDataArraykey);
}

- (void)setInvestingProjectDataArray:(NSArray *)investingProjectDataArray{

    objc_setAssociatedObject(self, &investingProjectDataArraykey, investingProjectDataArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray*)investingProjectDataArray{

    return objc_getAssociatedObject(self, &investingProjectDataArraykey);
}

- (void)setTotal_count:(NSString *)total_count {
    objc_setAssociatedObject(self, &total_countkey, total_count, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)total_count {
    return objc_getAssociatedObject(self, &total_countkey);
}

- (void)setTotal_page:(NSString *)total_page {
    objc_setAssociatedObject(self, &total_pagekey, total_page, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)total_page {
    return objc_getAssociatedObject(self, &total_pagekey);
}

- (void)setCurrent_page:(NSString *)current_page {
    objc_setAssociatedObject(self, &current_pagekey, current_page, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)current_page {
    return objc_getAssociatedObject(self, &current_pagekey);
}

#pragma mark -

- (void)initTable {
    if (!self.tableView) {
        self.tableView = [UITableView new];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.backgroundColor = Theme.backgroundColor;
    [self.view addSubview:self.tableView];

    [self addCenterView:self.tableView];

    self.tableView.tableFooterView = [UIView new];

    if (self.canRefresh) {
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self dataRefresh];
            }];
        mj_header.arrowView.image = [UIImage imageNamed:@"icon_common_arrow_down"];

        self.tableView.mj_header = mj_header;
    }

    self.current_page = START_PAGE;
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma  mark - data format

- (NSString *)listKey {
    return @"";
}

- (void)dataFormat
{}

#pragma  mark - data

- (void)dataRefresh {
    self.current_page = START_PAGE;

    [self.tableView.mj_footer resetNoMoreData];
    [self commonJson];
}

- (void)dataLoad {
    self.current_page = @([self.current_page integerValue] + 1).stringValue;

    if ([self.current_page integerValue] > [self.total_page integerValue]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }

    [self commonJson];
}

- (void)tableRrefresh {
    self.tableView.mj_footer = nil;
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableHandleNotHub {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)tableHandle {
    [self tableHandleNotHub];
    [self hideHUD];
}

- (void)tableHandleValue:(NSDictionary *)dic {
    [self tableHandleValueNotHub:dic];
    [self hideHUD];
}

- (void)tableHandleValueNotHub:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        self.total_page = 0;
        self.total_count = 0;
    } else {
        self.total_page = dic.str(@"page_info.total_page");
        self.total_count = dic.str(@"page_info.total_count");
    }

    if ([self.total_count isEqualToString:@"0"]) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    } else {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }

    NSString *key = [self listKey];

    if ([self.current_page intValue] > 1) {
        NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.tableDataArray];
        [temp addObjectsFromArray:dic[key]];
        self.tableDataArray = temp;
    } else {
        self.tableDataArray = dic[key];
        
    }
    
    if (!self.tableDataArray || [self.tableDataArray isMemberOfClass:[NSNull class]]) {
        self.tableDataArray=[NSMutableArray new];
    }

    if ([self.current_page intValue] < [self.total_page intValue]) {
        if (!self.tableView.mj_footer) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [self dataLoad];
                }];
            footer.triggerAutomaticallyRefreshPercent = 0.01;
            self.tableView.mj_footer = footer;
        }
    } else {
        self.tableView.mj_footer = nil;
    }

    [self dataFormat];

    if (self.current_page.integerValue > 1) {
        [UIView transitionWithView:self.tableView duration:0.35f  options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^(void) {
            [self.tableView reloadData];
        } completion:^(BOOL isFinished) {}];
    } else {
        [self.tableView reloadData];
    }

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)tableHandleFull:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        self.total_page = 0;
        self.total_count = 0;
    } else {
        self.total_page = dic.str(@"page_info.total_page");
        self.total_count = dic.str(@"page_info.total_count");
    }
    
    if ([self.total_count isEqualToString:@"0"]) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    } else {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    
    NSString *key = [self listKey];
    
    self.fullProjectDataArray = dic[key];
    
    
    if (!self.fullProjectDataArray || [self.fullProjectDataArray isMemberOfClass:[NSNull class]]) {
        self.fullProjectDataArray=[NSMutableArray new];
    }
    
    self.tableView.mj_footer = nil;
    
    [self dataFormat];
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    

}

- (void)tableHandleInvesting:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        self.total_page = 0;
        self.total_count = 0;
    } else {
        self.total_page = dic.str(@"page_info.total_page");
        self.total_count = dic.str(@"page_info.total_count");
    }
    
    if ([self.total_count isEqualToString:@"0"]) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    } else {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    
    NSString *key = [self listKey];
    
    self.investingProjectDataArray = dic[key];
    
    
    if (!self.investingProjectDataArray || [self.investingProjectDataArray isMemberOfClass:[NSNull class]]) {
        self.investingProjectDataArray=[NSMutableArray new];
    }

    
    self.tableView.mj_footer = nil;
    [self dataFormat];
    
    [self.tableView reloadData];

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


}

- (void)tableHandleRapid:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        self.total_page = 0;
        self.total_count = 0;
    } else {
        self.total_page = dic.str(@"page_info.total_page");
        self.total_count = dic.str(@"page_info.total_count");
    }
    
    if ([self.total_count isEqualToString:@"0"]) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    } else {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    
    NSString *key = [self listKey];
    

    self.RapaidProjectDataArray = dic[key];
    
  
    
    if (!self.RapaidProjectDataArray || [self.RapaidProjectDataArray isMemberOfClass:[NSNull class]]) {
        self.RapaidProjectDataArray=[NSMutableArray new];
    }

    self.tableView.mj_footer = nil;
   
    
    [self dataFormat];
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)tableHandleNewProject:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        self.total_page = 0;
        self.total_count = 0;
    } else {
        self.total_page = dic.str(@"page_info.total_page");
        self.total_count = dic.str(@"page_info.total_count");
    }
    
    if ([self.total_count isEqualToString:@"0"]) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    } else {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    
    NSString *key = [self listKey];
    
    
    self.newUserProjectArray = dic[key];
    
    
    
    if (!self.newUserProjectArray || [self.newUserProjectArray isMemberOfClass:[NSNull class]]) {
        self.newUserProjectArray=[NSMutableArray new];
    }
    
    self.tableView.mj_footer = nil;
    
    
    [self dataFormat];
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


}

- (void)tableHandleVip:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        self.total_page = 0;
        self.total_count = 0;
    } else {
        self.total_page = dic.str(@"page_info.total_page");
        self.total_count = dic.str(@"page_info.total_count");
    }
    
    if ([self.total_count isEqualToString:@"0"]) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    } else {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    
    NSString *key = [self listKey];
    
    
    self.VipProjectArray = dic[key];
    
    
    
    if (!self.VipProjectArray || [self.VipProjectArray isMemberOfClass:[NSNull class]]) {
        self.VipProjectArray=[NSMutableArray new];
    }
    
    self.tableView.mj_footer = nil;
    
    
    [self dataFormat];
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


    
}

#pragma  mark - emptydelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"\n\n暂无数据!!!";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
