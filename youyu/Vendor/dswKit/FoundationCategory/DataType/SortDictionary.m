//
//  SortDictionary.m
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "SortDictionary.h"
#import  <UIKit/UIKit.h>
#import "NSArray+Linq.h"

@implementation SortDictionary
{
    NSMutableDictionary *_dataDic;
    NSArray             *keys;
}

- (void)setDataWithKey:(NSString *)key array:(NSArray *)array {
    //
    NSMutableDictionary *dic = [NSMutableDictionary new];

    for (NSDictionary *item in array) {
        NSString *_key = [NSString stringWithFormat:@"%@",[item valueForKeyPath:key]]  ;

        if (self.delegate) {
            _key = [self.delegate sortDictionaryKeyFilter:_key];
        }

        if (!dic[_key]) {
            NSMutableArray *temp = [NSMutableArray new];
            [temp addObject:item];
            dic[_key] = temp;
        } else {
            NSMutableArray *temp = dic[_key];
            [temp addObject:item];
        }
    }

    _dataDic = dic;

    keys = [dic.allKeys sort:@"self" ascending:self.ascending];
    
}

- (NSInteger)sectionCount {
    return _dataDic.allKeys.count;
}

- (NSInteger)RowCountInSection:(NSInteger)index {
    if (_dataDic.allKeys.count == 0) {
        return 0;
    }

    NSArray *list = _dataDic[keys[index]];
    return list.count;
}

- (NSDictionary *)dataRow:(NSIndexPath *)indexPath {
    NSArray *list = _dataDic[keys[indexPath.section]];

    NSInteger t = indexPath.row;

    if (t >= list.count) {
        return nil;
    }

    return list[indexPath.row];
}

- (NSString *)sectionTitle:(NSInteger)scetion {
    return keys[scetion];
}

@end
