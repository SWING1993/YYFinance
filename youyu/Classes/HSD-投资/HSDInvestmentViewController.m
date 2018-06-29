//
//  HSDInvestmentViewController.m
//  hsd
//
//  Created by 杨旭冉 on 2017/10/24.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDInvestmentViewController.h"
#import "QTBaseViewController+Table.h"
#import "HRHomeTableViewCell.h"
#import "HSDInvestmentModel.h"
#import "MJExtension.h"
#import "HRBindBankViewController.h"
#import "HRSetPayPwdViewController.h"
#import "QTInvestDetailViewController.h"

@interface HSDInvestmentViewController ()

@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, strong) HSDInvestmentModel *headerNewhandModel;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *bidBtn;

@end

@implementation HSDInvestmentViewController

-(NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TABLEReg(HRHomeTableViewCell, @"HRHomeTableViewCell");
    
    [self commonJson];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title  = @"投资";
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
- (void) initHeaderView:(HSDInvestmentModel *) model{
    
    float headerViewHeight = RSS(210);
    self.headerView.width = APP_WIDTH;    self.headerView.height = headerViewHeight;
    self.tableView.tableHeaderView = self.headerView;
    
    //赋值
    NSString *valueStr = model.apr.add(@"%");
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@新手标收益",valueStr]];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(36.0)] range:NSMakeRange(0, valueStr.length)];
    self.titleLable.attributedText = attributedStr;
    
    WEAKSELF;
    [self.bidBtn addTapGesture:^{
        QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
        controller.borrow_id = model.typeID;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

- (NSString *)listKey {
    return @"borrow_list";
}

#pragma mark -tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 0 : 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (section == 4) ? 10 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"HRHomeTableViewCell";
    HRHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.model = self.dataAry[indexPath.section];
    cell.investmentBlock = ^{
        [self investBtnClick:indexPath];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self investBtnClick:indexPath];
}


/**
 cell及投资按钮点击事件
 */
- (void) investBtnClick : (NSIndexPath *) indexPath {
    QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
    
    HSDInvestmentModel *model = self.dataAry[indexPath.section];
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
        [self.dataAry removeAllObjects];
        for (NSDictionary *dic in value[@"borrow_list"]) {
            if ([dic[@"borrow_info"][@"new_hand"] isEqualToString:@"2"] && [dic[@"borrow_info"][@"real_state"] isEqualToString:@"2"]) {   //新手标
                self.headerNewhandModel = [HSDInvestmentModel mj_objectWithKeyValues:dic[@"borrow_info"]];
                [self initHeaderView:self.headerNewhandModel];
            }else{
                HSDInvestmentModel *model = [HSDInvestmentModel mj_objectWithKeyValues:dic[@"borrow_info"]];
                [self.dataAry addObject:model];
            }
        }
        [self.tableView reloadData];
    }];
}

@end

