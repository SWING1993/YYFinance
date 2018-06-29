//
//  QTBookViewController.m
//  qtyd
//
//  Created by stephendsw on 16/2/20.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBookViewController.h"


@interface QTBookViewController ()

@end

@implementation QTBookViewController
{
    UIWebView *webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"协议书";
    self.navigationItem.rightBarButtonItem=nil;
    
}


- (void)initUI {
    webview = [[UIWebView alloc]initWithFrame:APP_FRAEM];
    [self addCenterView:webview];
    webview.scalesPageToFit = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [webview loadData:_data MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:[NSURL new]];
}

@end
