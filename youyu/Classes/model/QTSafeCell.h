//
//  QTSafeCell.h
//  qtyd
//
//  Created by stephendsw on 15/8/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTSafeCell : UITableViewCell


- (void)bindName:(NSString *)str imageName:(NSString *)imgurl index:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UISwitch *GestureSW;

@property (readwrite, nonatomic) BOOL isFromAccount;

@end
