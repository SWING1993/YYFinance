//
//  QTBrandViewController.m
//  qtyd
//
//  Created by stephendsw on 16/8/2.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBrandViewController.h"

@interface QTBrandViewController ()

@end

@implementation QTBrandViewController
{
    NSString *title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = WEB_URL(@"/brand/brand.html");
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (title) {
        self.title = title;
    }
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    title = [title stringByReplacingOccurrencesOfString:@" - 有余金服,安全透明的互联网金融理财平台" withString:@""];

    self.title = title;
}

@end
