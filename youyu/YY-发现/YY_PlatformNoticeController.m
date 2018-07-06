//
//  YY_PlatformNoticeController.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YY_PlatformNoticeController.h"
#import "YY_PlatformNoticeCell.h"
#import "QTBaseViewController+Table.h"
#import "QTWebViewController.h"
#import "NSString+Size.h"

@interface YY_PlatformNoticeController ()

@end

@implementation YY_PlatformNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TABLEReg(YY_PlatformNoticeCell, @"YY_ActivityNoticeCell");
    
    [self initTable];
    [self initData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YY_PlatformNoticeCell *cell = [YY_PlatformNoticeCell cellWithTableView:tableView];
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    CGFloat height = [dic.str(@"abstract") sizeWithFont:FONT(14.0) maxSize:CGSizeMake(APP_WIDTH - 20, 70)].height + 90;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
    QTWebViewController *webVC = [QTWebViewController controllerFromXib];
    NSString *url = WEB_URL(@"/article/article_detail_app/notice/").add(dic.str(@"id"));
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - commonJson
- (void)initData {
    [self tableRrefresh];
}

- (NSString *)listKey {
    return @"article_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"nid"] = @"notice";
    dic[@"notice_type"] = @1;
    [service post:@"article_list" data:dic complete:^(id value) {
       
        NSString *content = [value convertToJSONData];
        
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, content.length)];
        
        value = [NSDictionary dictionaryWithJsonString:content];
        
        [self tableHandleValueNotHub:value ];
    }];
}

@end
