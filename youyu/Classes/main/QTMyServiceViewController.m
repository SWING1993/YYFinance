//
//  QTMyServiceViewController.m
//  qtyd
//
//  Created by stephendsw on 16/5/17.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTMyServiceViewController.h"
#import "QTAboutCell.h"
#import "QTBaseViewController+Table.h"
#import "GVUserDefaults.h"

@interface QTMyServiceViewController ()<UIWebViewDelegate>

@end

@implementation QTMyServiceViewController
{
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"专属客服";
    TABLEReg(QTAboutCell, @"QTAboutCell");
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initTable];
}

- (void)initData {
    self.isLockPage = YES;
    [self firstGetData];
}

#pragma mark - webview
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTAboutCell";

    QTAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row];

    [cell bind:dic];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row];

    if ((indexPath.row == 0)) {
        [AppUtil dial:[dic[@"content"] string]];
    } else if (indexPath.row == 1) {
        if (!webView) {
            webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=%@", [dic[@"content"]  string]]];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];

        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - json
- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [service post:@"vipcustom_serviceinfo" data:dic complete:^(NSDictionary *value) {
        NSMutableAttributedString *strcal = [[NSMutableAttributedString alloc]initWithString:value.str(@"service_phone")];
        [strcal setLinkString:value.str(@"service_phone")];

        NSMutableAttributedString *strQQ = [[NSMutableAttributedString alloc]initWithString:value.str(@"service_qq")];

        [strQQ setLinkString:value.str(@"service_qq")];

        NSArray *dataSection1 = @[
            @{@"image":@"icon_contact_07", @"title":@"服务热线", @"content":strcal},
            @{@"image":@"icon_qq_03", @"title":@"客服QQ", @"content":strQQ},
            @{@"image":@"icon_wechat_03", @"title":@"微信", @"content":value.str(@"service_webchat")}
        ];

        self.tableDataArray = dataSection1;

        [self tableHandle];

        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;

        NSInteger sex = [[[GVUserDefaults shareInstance].card_id substringWithRange:NSMakeRange(16, 1)] intValue];
        NSString *firstName = [[GVUserDefaults shareInstance].realname substringWithRange:NSMakeRange(0, 1)];
        NSString *nick = @"";

        if (sex % 2 == 0) {
            nick = [NSString stringWithFormat:@"%@女士", firstName];
        } else {
            nick = [NSString stringWithFormat:@"%@先生", firstName];
        }

        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"    尊敬的 %@\n我是您的专属客服%@", nick, value.str(@"service_name")]];
        [attstr setFont:[UIFont systemFontOfSize:15] string:[NSString stringWithFormat:@"尊敬的 %@\n", nick]];
        [attstr setFont:[UIFont systemFontOfSize:11] string:[NSString stringWithFormat:@"我是您的专属客服%@", value.str(@"service_name")]];

        [attstr setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
            Paragraph.lineSpacing = 3;
        }];

        label.attributedText = attstr;
        label.top = 30.0 / 136.353 * (APP_WIDTH / 521 * 222);
        label.left = 40.0 / 320.0 * APP_WIDTH;

        [label sizeToFit];

        UIImageView *imageview = [[UIImageView alloc]init];
        [imageview setImageWithURLString:value.str(@"service_img")];

        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.width = APP_WIDTH;
        imageview.height = APP_WIDTH / 521 * 222;

        [imageview addSubview:label];

        self.tableView.tableHeaderView = imageview;
    }];
}

@end
