//
//  NSArray+Linq.m
//  linq
//
//  Created by stephendsw on 15/8/26.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "NSArray+Linq.h"

@implementation NSArray (Linq)

- (BOOL)any:(NSString *)condition {
    NSArray *temp = [self where:condition];
    NSLog(@"versionArray-----%@",temp);

    if (temp.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)where:(NSString *)condition {
    NSPredicate *pre = [NSPredicate predicateWithFormat:condition];
    return [self filteredArrayUsingPredicate:pre];
}

- (id)single:(NSString *)condititon {
    NSArray *list = [self where:condititon];

    if (list.count > 0) {
        return list.firstObject;
    } else {
        return nil;
    }
}

/**
 *  排序
 *
 *  @param asc       yes 升序  no 降序
 *
 */
- (id)sort:(NSString *)condition ascending:(BOOL)asc {
    NSSortDescriptor    *sd1 = [NSSortDescriptor sortDescriptorWithKey:condition ascending:asc];
    NSArray             *arr1 = [self sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];

    return arr1;
}

- (id)min:(NSString *)condition {
    // 降序
    NSSortDescriptor    *sd1 = [NSSortDescriptor sortDescriptorWithKey:condition ascending:NO];
    NSArray             *arr1 = [self sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];

    return arr1.firstObject;
}

- (id)max:(NSString *)condition {
    // 降序
    NSSortDescriptor    *sd1 = [NSSortDescriptor sortDescriptorWithKey:condition ascending:NO];
    NSArray             *arr1 = [self sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];

    return arr1.lastObject;
}

- (NSArray *)map:(mapBlock)block {
    NSMutableArray *array = [NSMutableArray array];

    for (int i = 0; i < self.count; i++) {
        if (block(self[i])) {
            [array addObject:block(self[i])];
        }
    }

    return array;
}

- (NSArray *)getArrayForKey:(NSString *)keypath {
    NSMutableArray *array = [NSMutableArray new];

    if (!self) {
        return nil;
    }

    if (self.count == 0) {
        return nil;
    }

    for (NSDictionary *dic in self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [array addObject:[dic valueForKeyPath:keypath]];
        }
    }

    return array;
}

- (NSArray*)getArrayForKey:(NSString *)keypath value:(NSString*)value{
    NSMutableArray *array = [NSMutableArray new];

    if (!self) {
        return nil;
    }
    
    if (self.count == 0) {
        return nil;
    }
    
    for (NSDictionary *dic in self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if ([[dic valueForKeyPath:keypath]isEqualToString:value]) {
                 [array addObject:dic];
            }
        }
    }
    
    return array;

    
}

- (NSArray *)add:(id)item {
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self];

    [array addObject:item];

    return [NSArray arrayWithArray:array];
}

- (NSArray *)remove:(id)item {
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self];

    [array removeObject:item];

    return [NSArray arrayWithArray:array];
}

- (NSString *)joinedString {
    return [self componentsJoinedByString:@""];
}

@end
