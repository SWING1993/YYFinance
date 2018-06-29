//
//  HRMoreProjectViewController.m
//  hr
//
//  Created by 赵 on 07/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRMoreProjectViewController.h"
#import "DOPDropDownMenu.h"
#import "QTBaseViewController+Table.h"
#import "QTInvestDetailViewController.h"
#import "HRInvestCell.h"


@interface HRMoreProjectViewController ()

@end

@implementation HRMoreProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(HRInvestCell, @"HRInvestCell");
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.title = self.NAVtitle;
    
}

- (void)initUI {
    [self initTable];
}

- (void)initData {
    [self tableRrefresh];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HRInvestCell";
    HRInvestCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier ];
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"borrow_info"];
    [cell bind:dic];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 127;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [NSDictionary new];
    dic = self.tableDataArray[indexPath.row][@"borrow_info"];

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
    dic1[@"borrow_type"] = @"0";
//    dic1[@"order_column"] = order;
//    dic1[@"order_value"] = sort_type;
    dic1[@"borrow_status"] = self.borrow_status;
    
    [service post:@"borrow_list" data:dic1 complete:^(NSDictionary *value) {
        [self tableHandleValue:value];
    }];
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
