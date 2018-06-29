//
//  HRRecastWebViewController.m
//  hr
//
//  Created by 赵 on 06/07/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRRecastWebViewController.h"
@interface HRRecastWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIButton *investBt;

@end

@implementation HRRecastWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _investBt = [[UIButton alloc]initWithFrame:CGRectMake(0, APP_HEIGHT-44, APP_WIDTH, 44)];
    [_investBt setTitle:@"立即复投领现金" forState:UIControlStateNormal];
    _investBt.titleLabel.textColor = [UIColor whiteColor];
    [_investBt click:^(id value) {
        [self toInvest];
    }];
    _investBt.backgroundColor = [UIColor colorHex:@"ff6600" alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:_investBt];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [_investBt removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -delegate

- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    self.webview.scalesPageToFit = self.isScale;
    if (!self.navigationItem.title) {
        self.navigationItem.title = @"复投奖励规则";
    }

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
