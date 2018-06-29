//
//  QTMoreTableViewController.m
//  qtyd
//
//  Created by stephendsw on 15/8/21.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTMoreTableViewController.h"
#import "GVUserDefaults.h"
#import "QTAnnouncementViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTAnnouncementViewController.h"
#import "QTAboutTableViewController.h"
#import "QTFeedbackViewController.h"
#import "SystemConfigDefaults.h"
#import "QTWebViewController.h"
#import "QTVipView.h"

@interface QTMoreTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel        *lbversion;
@property (strong, nonatomic) IBOutlet UIView       *headView;
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@end

@implementation QTMoreTableViewController
{
    NSArray<NSString *> *titlelist;
    NSArray<NSString *> *imageList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"更多";

#ifdef DEBUG
        NSString *currentVersion = [NSString stringWithFormat:@"有余金服 v%@ (测试版)", [AppUtil getAPPVersion]];
#else
        NSString *currentVersion = [NSString stringWithFormat:@"有余金服 v%@", [AppUtil getAPPVersion]];
#endif

    self.lbversion.text = currentVersion;

    self.image.layer.cornerRadius = 10;
    self.image.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];
    self.headView.backgroundColor = [Theme backgroundColor];

    NSArray *iconText = @[@"官方公告", @"媒体报道", @"理财指导"];
    NSArray *iconImg = @[@"icon_notice", @"icon_meitibaodao", @"icon_licai"];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 100)];
    view.backgroundColor = [Theme backgroundColor];
    DWrapView *wrap = [[DWrapView alloc]initWidth:APP_WIDTH columns:3];
    wrap.backgroundColor = [Theme backgroundColor];
    wrap.subHeight = 100;

    for (int i = 0; i < 3; i++) {
        QTVipView *item = [QTVipView viewNib];
        item.backgroundColor = [Theme backgroundColor];
        item.lbName.textColor = [Theme redColor];
        item.lbName.font = [UIFont systemFontOfSize:11];
        [item setText:iconText[i] img:iconImg[i]];

        [item addTapGesture:^(id value) {
            if (i == 0) {
                [self toNoticePage];
            }

            if (i == 1) {
                QTAnnouncementViewController *controller = [QTAnnouncementViewController controllerFromXib];
                controller.type = QTAnnouncementMedia;
                [self.navigationController pushViewController:controller animated:YES];
            }

            if (i == 2) {
                QTAnnouncementViewController *controller = [QTAnnouncementViewController controllerFromXib];
                controller.type = QTAnnouncementNews;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
        [wrap addView:item margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    }

    [view addSubview:wrap];

    self.tableView.tableHeaderView = view;
    [self addBottomView:self.headView];
}

- (void)initData {
    titlelist = @[@"公司简介", @"联系我们", @"意见反馈", @"有余金服问答"];
    imageList = @[@"icon_us_07", @"icon_tel", @"icon_fankui_06", @"icon_question"];

    [self  commonJson];
}

#pragma  mark json

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"morecell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:imageList[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = titlelist[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        QTWebViewController *controller = [QTWebViewController controllerFromXib];
        controller.url = WEB_URL(@"/welcome/about");
        [self.navigationController pushViewController:controller animated:YES];
    }

    if (indexPath.row == 1) {
        QTAboutTableViewController *controller = [QTAboutTableViewController controllerFromXib];
        [self.navigationController pushViewController:controller animated:YES];
    }

    if (indexPath.row == 2) {
        [self loginedAction:^{
            QTFeedbackViewController *controller = [QTFeedbackViewController controllerFromXib];
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }

    if (indexPath.row == 3) {
        QTWebViewController *controller = [QTWebViewController controllerFromXib];
        controller.url = WEB_URL(@"/article/article_faq");
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
