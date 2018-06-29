//
//  QTUserListViewController.h
//  qtyd
//
//  Created by stephendsw on 2016/11/3.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTBaseViewController.h"


@class QTUserListViewController;

@protocol QTUserListDelegate<NSObject>

-(void) UserList:(QTUserListViewController *) controller didSelect:(NSDictionary *)dic;

@end

@interface QTUserListViewController : QTBaseViewController

@property (nonatomic, weak) id<QTUserListDelegate>  delegate;

@end
