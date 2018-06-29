//
//  YYInvestListViewController.m
//  hsd
//
//  Created by LimboDemon on 2017/11/14.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YYInvestListViewController.h"
#import "HSDInvestmentViewController.h"
#import "QTBaseViewController+Table.h"
//#import "HRHomeTableViewCell.h"
#import "HSDInvestmentModel.h"
#import "MJExtension.h"
#import "HRBindBankViewController.h"
#import "HRSetPayPwdViewController.h"
#import "QTInvestDetailViewController.h"

#import "YYInvestListTopTableViewCell.h"
#import "YYInvestListNarmalTableViewCell.h"

@interface YYInvestListViewController ()

@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, strong) HSDInvestmentModel *headerNewhandModel;

//@property (strong, nonatomic)  UIView *headerView;


@end

@implementation YYInvestListViewController

-(NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    TABLEReg(YYInvestListTopTableViewCell, @"topCell");
//    TABLEReg(YYInvestListNarmalTableViewCell, @"normalCell");
//    [self.tableView registerClass:[YYInvestListNarmalTableViewCell class] forCellReuseIdentifier:@"normalCell"];
//    [self.tableView registerClass:[YYInvestListTopTableViewCell class] forCellReuseIdentifier:@"topCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title  = @"理财";
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

-(void)initUI{
    
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) initData{
    [self tableRrefresh];
}

/**
 加载HeadreView
 */
//- (void) initHeaderView:(HSDInvestmentModel *) model{
//
//    float headerViewHeight = RSS(210);
//    self.headerView.width = APP_WIDTH;    self.headerView.height = headerViewHeight;
//    self.tableView.tableHeaderView = self.headerView;
//
//    //赋值
//    NSString *valueStr = model.apr.add(@"%");
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@新手标收益",valueStr]];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(36.0)] range:NSMakeRange(0, valueStr.length)];
////    self.titleLable.attributedText = attributedStr;
//
////    WEAKSELF;
//
////    [self.bidBtn addTapGesture:^{
////        QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
////        controller.borrow_id = model.typeID;
////        [weakSelf.navigationController pushViewController:controller animated:YES];
////    }];
//}

- (NSString *)listKey {
    return @"borrow_list";
}

#pragma mark -tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSDInvestmentModel *model = self.dataAry[indexPath.row];
    if (model.new_hand == 2 && indexPath.row == 0) {
        return RSS(203);
    }
    return RSS(135);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //新手标
    HSDInvestmentModel *model = self.dataAry[indexPath.row];
    if (model.new_hand == 2 && indexPath.row == 0) {
        static NSString *topIde = @"topCell";
        YYInvestListTopTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:topIde];
        if (!topCell) {
            topCell = [[YYInvestListTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topIde];
        }
        topCell.model = self.headerNewhandModel;
        return topCell;
    }
    
    //普通标
    static NSString *normalIde = @"normalCell";
    YYInvestListNarmalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:normalIde];
    if (!normalCell) {
        normalCell = [[YYInvestListNarmalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIde];
    }
    normalCell.normalView.model = model;
    return normalCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self investBtnClick:indexPath];
}


/**
 cell及投资按钮点击事件
 */
- (void)investBtnClick:(NSIndexPath *)indexPath {
    QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
    HSDInvestmentModel *model = self.dataAry[indexPath.row];
    controller.borrow_id = model.typeID;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - json
- (void)commonJson {
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    dic1[@"cur_page"] = self.current_page;
    dic1[@"page_size"] = PAGES_SIZE;
    dic1[@"borrow_type"] = @"0";
    dic1[@"order_column"] = @"loan_period";
    dic1[@"order_value"] = @"asc";
    //    dic1[@"borrow_status"] = @"1";
    
    [service post:@"borrow_list" data:dic1 complete:^(NSDictionary *value) {
        [self tableHandleInvesting:value];
        
        ///TODO:刷新之前先移除原有数据源数据！！！
        if ([self.current_page integerValue] > 1 ) {
            for (NSDictionary *dic in value[@"borrow_list"]) {
                HSDInvestmentModel *model = [HSDInvestmentModel mj_objectWithKeyValues:dic[@"borrow_info"]];
                [self.dataAry addObject:model];
            }
        }else{
            [self.dataAry removeAllObjects];
            for (NSDictionary *dic in value[@"borrow_list"]) {
                if ([dic[@"borrow_info"][@"new_hand"] isEqualToString:@"2"] && [dic[@"borrow_info"][@"real_state"] isEqualToString:@"2"]) {   //新手标
                    self.headerNewhandModel = [HSDInvestmentModel mj_objectWithKeyValues:dic[@"borrow_info"]];
                    [self.dataAry insertObject:self.headerNewhandModel atIndex:0];
                }else{
                    HSDInvestmentModel *model = [HSDInvestmentModel mj_objectWithKeyValues:dic[@"borrow_info"]];
                    [self.dataAry addObject:model];
                }
            }
        }
        
        [self.tableView reloadData];
        [self tableHandleValue:value];
    }];
}



@end
