//
//  QTAboutTableViewController.m
//  qtyd
//
//  Created by stephendsw on 15/9/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTAboutTableViewController.h"
#import "QTAboutCell.h"
#import "IMYWebView.h"
#import "QTBaseViewController+Table.h"

@interface QTAboutTableViewController ()<UIWebViewDelegate>

@end

@implementation QTAboutTableViewController
{
    NSArray *dataSection1;
    NSArray *dataSection2;
    NSArray *dataSection3;

    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"联系我们";
    TABLEReg(QTAboutCell, @"QTAboutCell");
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];
}

- (void)initData {
    self.tableView.backgroundColor = [Theme backgroundColor];

    NSMutableAttributedString *str;

    str = [[NSMutableAttributedString alloc]initWithString:@"400-888-1673"];

    [str addAttribute:NSLinkAttributeName value:@"" range:NSMakeRange(0, str.length)];

    dataSection1 = @[
        @{@"image":@"icon_contact_07", @"title":@"服务热线", @"content":str},

        @{@"image":@"icon_wechat_03", @"title":@"微信公众号", @"content":@"hrcfucom"}
    ];

    NSMutableAttributedString *strQQ = [[NSMutableAttributedString alloc]initWithString:@"点击进入，即问即答"];

    [strQQ addAttribute:NSLinkAttributeName value:@"" range:NSMakeRange(0, strQQ.length)];

    dataSection2 = @[ @{@"image":@"icon_qq_03", @"title":@"在线客服", @"content":strQQ},
        @{@"image":@"icon_email_03", @"title":@"客服邮箱", @"content":@"kefu@hrcfu.com"}
    ];

    NSMutableAttributedString *strweb = [[NSMutableAttributedString alloc]initWithString:@"www.hrcfu.com"];

    [strweb addAttribute:NSLinkAttributeName value:@"" range:NSMakeRange(0, strweb.length)];

    dataSection3 = @[
        @{@"image":@"icon_net_03", @"title":@"公司网址", @"content":strweb},

        @{@"image":@"icon_address_03", @"title":@"公司地址", @"content":@"杭州市西湖区三墩街1号世创国际大厦16F"}

    ];

    IMYWebView      *webview = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, APP_HEIGHT - 44 * 6 - 44 - 20 * 3)];
    NSString        *path = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    NSURL           *url = [NSURL fileURLWithPath:path];
    NSURLRequest    *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];

    self.tableView.tableFooterView = webview;

    [self.tableView reloadData];
}

#pragma mark - webview
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
}

#pragma  mark - table

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        [AppUtil dial:@"400-888-1673"];
    }

    if ((indexPath.section == 1) && (indexPath.row == 0)) {
//        [self toFAQ];
    }
    
    if ((indexPath.section == 2) && (indexPath.row == 0)) {
        [AppUtil safari:@"http://www.uyujf.com/"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return dataSection1.count;
    } else if (section == 1) {
        return dataSection2.count;
    } else {
        return dataSection3.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTAboutCell";

    QTAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic;

    if (indexPath.section == 0) {
        dic = dataSection1[indexPath.row];
    } else if (indexPath.section == 1) {
        dic = dataSection2[indexPath.row];
    } else {
        dic = dataSection3[indexPath.row];
    }

    [cell bind:dic];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 2) && (indexPath.row == 2)) {
        return APP_HEIGHT - 44 * 6 - 44 - 20 * 3;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1)];

    return view;
}

@end
