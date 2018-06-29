//
//  QTAnnouncementViewController.m
//  qtyd
//
//  Created by yl on 15/11/2.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTAnnouncementViewController.h"
#import "QTAnnouncementCell.h"
#import "QTBaseViewController+Table.h"
#import "UIViewController+page.h"
#import "QTWebViewController.h"

@interface QTAnnouncementViewController ()

@end

@implementation QTAnnouncementViewController
{
    NSInteger   *articleId;

    NSString *serviceTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.type == QTAnnouncementMedia) {
        self.titleView.title = @"媒体报道";
    } else if (self.type == QTAnnouncementNotice) {
        self.titleView.title = @"官方公告";
    } else if (self.type == QTAnnouncementNews) {
        self.titleView.title = @"理财指导";
    }

    TABLEReg(QTAnnouncementCell, @"announcementcell");

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"发现";
//    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)initUI {
    self.canRefresh = YES;
    [self initTable];

    self.tableView.separatorStyle = NO;
}

- (void)initData {
    [self tableRrefresh]; // 刷新表数据
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_card_address"]];

    imageview.contentMode = UIViewContentModeScaleAspectFit;
    return imageview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString     *Identifier = @"announcementcell";
    QTAnnouncementCell  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];

    NSMutableDictionary *dicNew = [[NSMutableDictionary alloc]initWithDictionary:dic];

    dicNew[@"serviceTime"] = serviceTime;

    [cell bind:dicNew];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"announcementcell" cacheByIndexPath:indexPath configuration:^(QTAnnouncementCell* cell) {
               NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];

               [cell bind:dic];
           }];
}

//选中操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary        *dic = self.tableDataArray[indexPath.row][@"article_info"];
    QTWebViewController *controller = [QTWebViewController new];
    controller.showShareBtn = YES;
    controller.isScale = YES;
    controller.titleView.title = @"详细内容";
//    controller.shareTitle = dic.str(@"name");

    NSString *url;

    if (self.type == QTAnnouncementMedia) {
        url = WEB_URL(@"/article/article_detail_app/media/").add(dic.str(@"id"));
    } else if (self.type == QTAnnouncementNotice) {
        url = WEB_URL(@"/article/article_detail_app/notice/").add(dic.str(@"id"));
    } else if (self.type == QTAnnouncementNews) {
        url = WEB_URL(@"/article/article_detail_app/news/").add(dic.str(@"id"));
    }

    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无数据";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma  mark - json

- (NSString *)listKey {
    return @"article_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;

    if (self.type == QTAnnouncementMedia) {
        dic[@"nid"] = @"notice";
    } else if (self.type == QTAnnouncementNotice) {
        dic[@"nid"] = @"notice";
        dic[@"notice_type"] = self.sort;
    } else if (self.type == QTAnnouncementNews) {
        dic[@"nid"] = @"news";
    }

    [service post:@"article_list" data:dic complete:^(NSDictionary *value) {
        serviceTime = value.str(@"server_time");

        NSString *content = [value convertToJSONData];

        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, content.length)];

        value = [NSDictionary dictionaryWithJsonString:content];

        [self tableHandleValue:value];
    }];
}

@end
