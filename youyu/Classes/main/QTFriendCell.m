//
//  QTFriendCell.m
//  qtyd
//
//  Created by stephendsw on 15/8/5.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTFriendCell.h"
#import "NSString+model.h"

@interface QTFriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbname;

@property (weak, nonatomic) IBOutlet UILabel *lbtime;

@property (weak, nonatomic) IBOutlet UILabel *lbmoney;

@end

@implementation QTFriendCell

- (void)bind:(NSDictionary *)obj {
    self.lbname.text = [obj.str(@"username") hideValue:3 end:6];
    self.lbmoney.text = [obj.str(@"invite_money") moneyFormatShow];
    self.lbtime.text = [obj.str(@"addtime") timeValue];
}

@end
