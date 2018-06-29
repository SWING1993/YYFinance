//
//  QTAccuntHomeViewController.m
//  qtyd
//
//  Created by stephendsw on 16/8/28.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTAccuntHomeViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTSafeCell.h"
#import "QTRankView.h"
#import "QTBankViewController.h"

@interface QTAccuntHomeViewController ()
@property (strong, nonatomic) IBOutlet UIView       *headview;
@property (weak, nonatomic) IBOutlet UIImageView    *imgUser;
@property (weak, nonatomic) IBOutlet UILabel        *lbNAME;

@end

@implementation QTAccuntHomeViewController
{}

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTSafeCell, @"QTSafeCell");
    
    self.titleView.title = @"个人中心";
    self.navigationItem.rightBarButtonItem = nil;
    self.tableDataArray = @[
                            @{@"title":@"修改手机号",@"image":@"icon_login_name"},
//                            @{@"title":@"成长特权", @"image":@"icon_chengzhangzhi_zhanghu"},
                            @{@"title":@"我的订单", @"image":@"icon_wodedingdan"},
                            @{@"title":@"银行卡", @"image":@"icon_roleset_card"},
                            @{@"title":@"安全中心", @"image":@"icon_roleset_anquan"},
                            @{@"title":@"任务大礼包", @"image":@"icon_account_gift"}
//                            @{@"title":@"消息管理", @"image":@"icon_roleset_message"}
                           
                            ];
}

- (void)initUI {
    self.canRefresh = NO;
    
    [self initTable];
    self.tableView.tableHeaderView = self.headview;
}

- (void)initData {
    self.isLockPage = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lbNAME.text = [[GVUserDefaults shareInstance] getNickName];
    [self.imgUser sd_setImageWithURL:[NSURL URLWithString:[GVUserDefaults  shareInstance].app_litpic] placeholderImage:[UIImage imageNamed:@"icon_account_user"]];
    [self.headview addTapGesture:^{
        [self toMyInfo];
    }];
} 

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTSafeCell";
    QTSafeCell      *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    NSDictionary *dic = self.tableDataArray[indexPath.row];
    
    NSString    *name = dic.str(@"title");
    NSString    *imageName = dic.str(@"image");
    cell.isFromAccount = YES;
    [cell bindName:name imageName:imageName index:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self toModifyPhone];
        
//    } else if (indexPath.row == 1) {
//        [self  toGrow];
        
    } else if (indexPath.row == 1) {
        [self toOrderList];
        
    } else if (indexPath.row == 2) {
        
        if ([GVUserDefaults shareInstance].real_status!=1) {
            
            [self toBindCard];
        } else {
            QTBankViewController *vc = [QTBankViewController controllerFromXib];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else if (indexPath.row == 3) {
        [self  toSafe];
        
    } else if (indexPath.row == 4) {
        if ([GVUserDefaults shareInstance].real_status!=1) {
            
            [self toBindCard];
        } else {
            [self  toGift];
        }
        
       
    }else if (indexPath.row == 5){
         [self  toMessageSet];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

@end
