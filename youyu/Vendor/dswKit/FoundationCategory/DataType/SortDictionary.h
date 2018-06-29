//
//  SortDictionary.h
//  qtyd
//
//  Created by stephendsw on 15/7/27.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortDictionary<NSObject>

- (NSString *)sortDictionaryKeyFilter:(NSString *)value;

@end

@interface SortDictionary : NSDictionary

@property (nonatomic, weak) id<SortDictionary> delegate;

@property (nonatomic , assign ) BOOL ascending;


- (void)setDataWithKey:(NSString *)key array:(NSArray *)array;

- (NSInteger)sectionCount;

- (NSInteger)RowCountInSection:(NSInteger)index;

- (NSDictionary *)dataRow:(NSIndexPath *)indexPath;

- (NSString *)sectionTitle:(NSInteger)scetion;
@end
