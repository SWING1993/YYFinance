//
//  HSDTrendViewController.m
//  hsd
//
//  Created by 杨旭冉 on 2017/10/24.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDTrendViewController.h"
#import "QTBaseViewController+Table.h"
#import "HSDTrendTableViewCell.h"

#import "UIViewController+page.h"

@interface HSDTrendViewController ()

@property (strong, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLable;

@end

@implementation HSDTrendViewController

//取消广告
- (IBAction)cancelBtnClick:(id)sender {
    self.tableView.tableHeaderView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initUI {
    
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.adView;
}

#pragma mark -tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 192;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSDTrendTableViewCell *cell = [HSDTrendTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showToast:[NSString stringWithFormat:@"点击了第%ld个cell",(long)indexPath.section]];
}


@end
