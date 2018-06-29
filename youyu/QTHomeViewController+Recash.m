//
//  QTHomeViewController+Recash.m
//  hr
//
//  Created by 赵 on 07/08/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "QTHomeViewController+Recash.h"

@implementation QTHomeViewController (Recash)

- (void)storeRecashInfo:(NSArray*)array{
    for(NSDictionary *dic in  array){
        
        if ([dic.str(@"href")containsString:@"hr_activity" ]) {
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"hr_activity"];
        }
        if ([dic.str(@"href")containsString:@"end_activity"]){
        
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hr_activity"];
        }
    }
}
@end
