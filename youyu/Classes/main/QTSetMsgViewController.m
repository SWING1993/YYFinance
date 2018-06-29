//
//  QTSetMsgViewController.m
//  qtyd
//
//  Created by stephendsw on 16/4/12.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSetMsgViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTSetMsgDetailViewController.h"
#import "GVUserDefaults.h"
#import "QTAlertWeiXinView.h"

@interface QTSetMsgViewController ()
{
    NSArray *titleList;
     NSArray *typeList;
    NSArray *imageList;

    BOOL isWeiXin;
}

@end

@implementation QTSetMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];
    self.navigationItem.rightBarButtonItem = nil;
    self.titleView.title = @"消息提醒设置";
}

- (void)initData {
    self.isLockPage = YES;
    titleList = @[@"我的消息",@"短信通知", @"邮件通知", @"微信推送", @"App推送"];
    typeList = @[ @"536",@"537", @"538", @"561", @"562"];
    imageList = @[ @"icon_set_message",@"icon_xiaoxi_xiaoxishezhi", @"icon_duanxin_xiaoxishezhi", @"icon_weixin_xiaoxishezhi", @"icon_app_xiaoxishezhi"];

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self commonJson];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTMsgSetCell";

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];

    cell.imageView.image = [UIImage imageNamed:imageList[indexPath.section]];
    cell.textLabel.text = titleList[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        // 邮件通知
        if (![[GVUserDefaults shareInstance].email_status isEqualToString:@"1"]) {
            [self showToast:@"您尚未绑定并激活邮箱，请先绑定激活" duration:2 done:^{
                [self toBandEmail];
            }];

            return;
        }
    }

    if (indexPath.section == 3) {
        // 微信通知
        if (!isWeiXin) {
            [self showToast:@"您尚未绑定微信，请先绑定" duration:2 done:^{
            }];

            return;
        }
    }

    QTSetMsgDetailViewController *controller = [QTSetMsgDetailViewController controllerFromXib];

    controller.type = typeList[indexPath.section];
    controller.name= titleList[indexPath.section];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 10)];

    view.backgroundColor = [Theme backgroundColor];
    return view;
}

- (void)commonJson {
    [self showHUD];
    [service post:@"user_novicetask" data:nil complete:^(NSDictionary *value) {
        isWeiXin = value.i(@"weixin_binding"); // 微信账号绑定状态

        [self hideHUD];
    }];
}

@end
