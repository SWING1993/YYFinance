//
//  QTInvestViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestViewController.h"
#import "QTInvestCell.h"
#import "DOPDropDownMenu.h"
#import "QTBaseViewController+Table.h"
#import "QTInvestDetailViewController.h"
#import "HRInvestCell.h"
#import "DGridView.h"
#import "HRMoreProjectViewController.h"

@interface QTInvestViewController ()

@property (strong, nonatomic) IBOutlet UIView   *viewHead;
@property (weak, nonatomic) IBOutlet UIButton   *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton   *btn3;
@property (strong, nonatomic) IBOutlet UIView   *vipTip;


@property (strong, nonatomic )NSArray *fullProjectDataArray;
@property (strong, nonatomic )NSArray *RapaidProjectDataArray;
@property (strong, nonatomic )NSArray *investingProjectDataArray;

@end

@implementation QTInvestViewController
{
    NSArray *menuData;
    NSArray *menuKey;
    //
    NSString *order;

    NSString *sort_type;
    // 预告标
    NSInteger server_time;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    TABLEReg(QTInvestCell, @"QTInvestCell");
    TABLEReg(HRInvestCell, @"HRInvestCell");
}

- (NSString *)type {
    if ([NSString isEmpty:_type]) {
        return @"0";
    } else {
        return _type;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"investView"];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.title = @"投资";
    

}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"investView"];
}

- (void)initUI {
    [self initTable];

    if ([self.type isEqualToString:@"815"]) {
        self.vipTip.clipsToBounds = YES;
        self.tableView.tableHeaderView = self.vipTip;
    }

//    [self addHeadView:self.viewHead];
    self.viewHead.width = APP_WIDTH;
    [self.viewHead setBottomLine:[Theme borderColor]];

    NSArray *btnList = @[self.btn2, self.btn3];
    self.btn2.tag = 1;
    self.btn3.tag = 2;

    for (UIButton *item in btnList) {
        [self setButton:item Status:0];

        [item clickOn:^(id value) {
            [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            if (item.tag == 1) {
                order = @"loan_period";
            } else {
                order = @"apr";
            }

            sort_type = @"asc";
            [self setButton:item Status:1];
            [self tableRrefresh];

            for (UIButton *item2 in btnList) {
                if (![item2 isEqual:item]) {
                    [self setButton:item2 Status:0];
                }
            }
        } off:^(id value) {
            [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            if (item.tag == 1) {
                order = @"loan_period";
            } else {
                order = @"apr";
            }

            sort_type = @"desc";
            [self setButton:item Status:2];
            [self tableRrefresh];

            for (UIButton *item2 in btnList) {
                if (![item2 isEqual:item]) {
                    [self setButton:item2 Status:0];
                }
            }
        }];
    }

    [self.btn1 click:^(id value) {
        [self.btn1 setTitleColor:[Theme redColor] forState:UIControlStateNormal];
        order = @"";
        sort_type = @"";
        [self tableRrefresh];

        for (UIButton *item2 in btnList) {
            [self setButton:item2 Status:0];
        }
    }];
}

- (void)setButton:(UIButton *)btn Status:(NSInteger)s {
    btn.backgroundColor = [UIColor whiteColor];

    if (s == 0) {
        [btn setImage:[UIImage imageNamed:@"icon_btn_normal"] forState:UIControlStateNormal];
        btn.selected = NO;

        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    if (s == 1) {
        [btn setImage:[UIImage imageNamed:@"icon_btn_down"] forState:UIControlStateSelected];
        [btn setTitleColor:[Theme redColor] forState:UIControlStateSelected];
        [btn setTitleColor:[Theme redColor] forState:UIControlStateNormal];
    }

    if (s == 2) {
        [btn setImage:[UIImage imageNamed:@"icon_btn_up"] forState:UIControlStateNormal];
        [btn setTitleColor:[Theme redColor] forState:UIControlStateSelected];
        [btn setTitleColor:[Theme redColor] forState:UIControlStateNormal];
    }
}

- (void)initData {
    order = @"";
    [self tableRrefresh];
}

#pragma  mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.type isEqualToString:@"0"]) {
        return 3;
    }else{
        return 1;

    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.type isEqualToString:@"0"]) {
        if (section ==0) {
            
            return self.investingProjectDataArray.count ;
            
        }else if (section==1){
            
            return [self.fullProjectDataArray subarrayWithRange:NSMakeRange(0, 3)].count;
        }else{
            
            return  [self.RapaidProjectDataArray  subarrayWithRange:NSMakeRange(0, 3)].count;
        }

    }else{
       
        return self.tableDataArray.count;
        
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]initWidth:APP_WIDTH Height:40];
    sectionView.backgroundColor = [UIColor colorHex:@"eaebf0"];
    
    UILabel *sectionLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 100, 20)];
    sectionLable.textColor = [UIColor colorHex:@"666666"];
    sectionLable.font = [UIFont systemFontOfSize:12];
    [sectionView addSubview:sectionLable];
    
    UIButton *sectionButton = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH-100, 2, 100, 20)];
    [sectionButton setTitleColor:[UIColor colorHex:@"333333"] forState:UIControlStateNormal];
    [sectionButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [sectionButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [sectionView addSubview:sectionButton];
    
    if (section == 0) {
        sectionLable.text = @"精选推荐";
        [sectionButton setTitle:nil forState:UIControlStateNormal];
    }else if (section == 1){
    
        sectionLable.text = @"已满标";
        [sectionButton click:^(id value) {
            HRMoreProjectViewController *controller = [HRMoreProjectViewController controllerFromXib];
            controller.NAVtitle = @"已满标项目";
            controller.borrow_status = @"2";
            [self.navigationController pushViewController:controller animated:YES];
            NSLog(@"已满标");
            
        }];
    }else{
    
        sectionLable.text = @"已回款";
        [sectionButton click:^(id value) {
            [sectionButton click:^(id value) {
                HRMoreProjectViewController *controller = [HRMoreProjectViewController controllerFromXib];
                controller.NAVtitle = @"已回款项目";
                controller.borrow_status = @"3";
                [self.navigationController pushViewController:controller animated:YES];
                NSLog(@"已回款");
            }];

        }];
    }
    if ([self.type isEqualToString:@"0"]) {
        return  sectionView;
    }else{
    
        return nil ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HRInvestCell";
    HRInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier ];
    
    if ([self.type isEqualToString:@"0"]) {
        if (indexPath.section==0) {
            
            NSDictionary *dic = self.investingProjectDataArray[indexPath.row][@"borrow_info"];
            
            [cell bind:dic];
        }else if (indexPath.section ==1){
            
            NSDictionary *dic = self.fullProjectDataArray[indexPath.row][@"borrow_info"];
            
            [cell bind:dic];
            
        }else{
            
            NSDictionary *dic = self.RapaidProjectDataArray[indexPath.row][@"borrow_info"];
            
            [cell bind:dic];
            
        }

    }else{
    
        NSDictionary *dic = self.tableDataArray[indexPath.row][@"borrow_info"];
        
        [cell bind:dic];
        
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 127;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"projectListBt"];
    NSDictionary *dic = [NSDictionary new];
    
    if ([self.type isEqualToString:@"0"]) {
        if (indexPath.section==0) {
            
            dic = self.investingProjectDataArray[indexPath.row][@"borrow_info"];
            
        }else if (indexPath.section ==1){
            
            dic = self.fullProjectDataArray[indexPath.row][@"borrow_info"];
            
        }else{
            
            dic = self.RapaidProjectDataArray[indexPath.row][@"borrow_info"];
            
        }
        
    }else{
    
        dic = self.tableDataArray[indexPath.row][@"borrow_info"];
        
    }
    QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];

    controller.borrow_id = dic[@"id"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)listKey {
    return @"borrow_list";
}

#pragma  mark - json

- (void)commonJson {
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    dic1[@"cur_page"] = self.current_page;
    dic1[@"page_size"] = PAGES_SIZE;
    dic1[@"borrow_type"] = self.type;
    dic1[@"order_column"] = order;
    dic1[@"order_value"] = sort_type;
    dic1[@"borrow_status"] = @"1";


    
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    dic2[@"page_size"] = PAGES_SIZE;
    dic2[@"cur_page"] = self.current_page;
    dic2[@"borrow_type"] = self.type;
    dic2[@"order_column"] = order;
    dic2[@"order_value"] = sort_type;
    dic2[@"borrow_status"] = @"2";
    
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    
    dic3[@"cur_page"] = self.current_page;
    dic3[@"page_size"] = PAGES_SIZE;
    dic3[@"borrow_type"] = self.type;
    dic3[@"order_column"] = order;
    dic3[@"order_value"] = sort_type;
    dic3[@"borrow_status"] = @"3";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"borrow_type"] = self.type;
    dic[@"order_column"] = order;
    dic[@"order_value"] = sort_type;
  

    if ([self.type isEqualToString:@"0"]) {
        
        [service post:@"borrow_list" data:dic1 complete:^(NSDictionary *value) {
            [self tableHandleInvesting:value];
        }];
        [service post:@"borrow_list" data:dic2 complete:^(NSDictionary *value) {
            [self tableHandleFull:value];
        }];
        
        [service post:@"borrow_list" data:dic3 complete:^(NSDictionary *value) {
            [self tableHandleRapid:value];
        }];
    }else{
        [service post:@"borrow_list" data:dic complete:^(NSDictionary *value) {
            [self tableHandleValueNotHub:value];
        }];
    }
   }

@end
