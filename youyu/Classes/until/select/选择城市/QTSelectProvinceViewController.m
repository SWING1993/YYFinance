//
//
//
//
//  Created by stephen on 14-6-9.
//  Copyright (c) 2014年 qtyd. All rights reserved.
//

#import "QTSelectProvinceViewController.h"
#import "QTBaseViewController+Table.h"

@interface QTSelectProvinceViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>{
    NSArray *provinces;
    NSArray *cities;
    NSArray *areas;

    NSArray *temp;

    NSArray *searchResults;

    NSDictionary *data;
}

@end

@implementation QTSelectProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    switch (self.type) {
        case SelectProvice:
            self.titleView.title = @"请选择所在省份";
            break;

        case SelectCity:
            self.titleView.title = @"请选择所在城市";
            break;

        case SelectArea:
            self.titleView.title = @"请选择所在区域";
            break;

        default:
            break;
    }

    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initTable];
}

- (void)initData {
    NSDictionary *tempdata = [NSDictionary dictionaryWithContentsOfFile:CITY_FILE_PATH];

    if (!tempdata) {
        [self  firstGetData];
    } else {
        [self handle:tempdata];
    }
}

#pragma  mark - searchcontroller
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:@""];
    return YES;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSMutableArray *dataarray = [NSMutableArray new];

    if (self.type == SelectCity) {
        for (NSDictionary *item in temp) {
            NSDictionary *dic = item[@"city_info"];

            if ([dic.str(@"area_name") rangeOfString:searchText].location != NSNotFound) {
                [dataarray addObject:item];
            }
        }
    } else if (self.type == SelectProvice) {
        for (NSDictionary *item in temp) {
            NSDictionary *dic = (NSDictionary *)((NSArray *)item[@"province_info"]).firstObject;

            if ([dic.str(@"area_full_name") rangeOfString:searchText].location != NSNotFound) {
                [dataarray addObject:item];
            }
        }
    } else {
        NSString *sql = [NSString stringWithFormat:@"self.zone_info.area_full_name  CONTAIN[cd] '%@'", searchText];
        dataarray = [[NSMutableArray alloc]initWithArray:[temp where:sql]];
    }

    searchResults = dataarray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return searchResults.count;
    } else {
        return [temp count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *dic;

    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        dic = searchResults[indexPath.row];
    } else {
        dic = temp[indexPath.row];
    }

    if (self.type == SelectCity) {
        dic = dic[@"city_info"];
        cell.textLabel.text = dic[@"area_name"];
    } else if (self.type == SelectProvice) {
        dic = (NSDictionary *)(dic.arr(@"province_info").firstObject);
        cell.textLabel.text = dic[@"area_full_name"];
    } else {
        cell.textLabel.text = dic[@"zone_info"][@"area_name"];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSDictionary *dic;

    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        dic = searchResults[indexPath.row];
    } else {
        dic = temp[indexPath.row];
    }

    if (self.type == SelectCity) {
        dic = dic[@"city_info"];
        [_delegate selectedCity:dic];
    } else if (self.type == SelectProvice) {
        dic = (NSDictionary *)(dic.arr(@"province_info").firstObject);
        [self.delegate selectedProvice:dic];
    } else {
        dic = dic[@"zone_info"];
        [self.delegate selectedArea:dic];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - json
- (void)commonJson {
    [service post:@"syscfg_area" data:nil complete:^(NSDictionary *value) {
        [self handle:value];
    }];
}

- (void)handle:(NSDictionary *)value {
    // 输入写入
    [value writeToFile:CITY_FILE_PATH atomically:YES];
    data = value;

    if (self.type == SelectCity) {
        temp = [self getCityForProvice:self.ProviceName];
    } else if (self.type == SelectProvice) {
        temp = [self getProvice];
    } else {
        temp = [self getAreaForCity:self.CityName provice:self.ProviceName];
    }

    [self tableHandle];
    [self.view endEditing:YES];
    [self hideHUD];
}

#pragma  mark - data
- (NSArray *)getProvice {
    return data[@"area_info"];
}

- (NSArray *)getCityForProvice:(NSString *)provice {
    NSArray *proviceList = [self getProvice];

    for (int i = 0; i < proviceList.count; i++) {
        NSDictionary *dic = proviceList[i];

        dic = (NSDictionary *)(dic.arr(@"province_info").firstObject);

        if ([dic[@"area_full_name"] isEqualToString:provice]) {
            return dic[@"city_list"];

            break;
        }
    }

    return nil;
}

- (NSArray *)getAreaForCity:(NSString *)city provice:(NSString *)provice {
    NSArray *cityList = [self getCityForProvice:provice];

    NSString        *sql = [NSString stringWithFormat:@"self.city_info.area_name == '%@'", city];
    NSDictionary    *cityDic = [cityList single:sql];

    return cityDic[@"city_info"][@"zone_list"];
}

@end
