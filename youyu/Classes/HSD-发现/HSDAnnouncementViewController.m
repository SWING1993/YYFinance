//
//  HSDAnnouncementViewController.m
//  hsd
//
//  Created by 杨旭冉 on 2017/10/24.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDAnnouncementViewController.h"
#import "QTBaseViewController+Table.h"
#import "HSDAnnouncementTableViewCell.h"
#import "QTBaseViewController+Table.h"
#import "NSString+Size.h"

@interface HSDAnnouncementViewController ()

@end

@implementation HSDAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    self.view.backgroundColor = [Theme backgroundColor];
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self commonJson];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 136;
    NSString *content = self.tableDataArray[indexPath.row] [@"article_info"][@"abstract"];
    if (content.length > 80) {
        content = [content substringToIndex:80];
    }
//    CGFloat height = [content sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(APP_WIDTH - 20, 0)].height + 118;
//    NSLog(@"================%ld",(long)height);
    return [tableView fd_heightForCellWithIdentifier:@"HSDAnnouncementTableViewCell" cacheByIndexPath:indexPath configuration:^(HSDAnnouncementTableViewCell *cell) {
        NSDictionary *dic = self.tableDataArray[indexPath.row][@"article_info"];
        [cell bind:dic];
    }];
//    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSDAnnouncementTableViewCell *cell = [HSDAnnouncementTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.tableDataArray[indexPath.section][@"article_info"];
    [cell bind:dataDic];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showToast:[NSString stringWithFormat:@"点击了第%ld个cell",(long)indexPath.section]];
}

#pragma mark -json

- (NSString *)listKey {
    return @"article_list";
}

- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = PAGES_SIZE;
    dic[@"nid"] = @"notice";
//    dic[@"notice_type"] = @"1";
    
    [service post:@"article_list" data:dic complete:^(NSDictionary *value) {
        
        NSString *content = [value convertToJSONData];
        
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, content.length)];
        
        value = [NSDictionary dictionaryWithJsonString:content];
        
        [self tableHandleValue:value];
    }];
}

@end
