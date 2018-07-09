//
//  QTUserListCell.m
//  qtyd
//
//  Created by stephendsw on 2016/11/3.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTUserListCell.h"
#import "SystemConfigDefaults.h"

@interface QTUserListCell ()
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbName;
@property (weak, nonatomic) IBOutlet UIButton       *btn;

@end

@implementation QTUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)closeClick:(id)sender {}

- (void)bind:(NSDictionary *)obj {
    [self.image setImageWithURLString:obj.str(@"imgurl") placeholderImageString:@"iconfont_morentouxiang"];
    self.lbName.text = obj.str(@"name");

    [self.btn click:^(id value) {
        NSMutableArray *userlist = [[NSMutableArray alloc]initWithArray:[SystemConfigDefaults sharedInstance].userList];

        [userlist removeObject:obj];

        [SystemConfigDefaults sharedInstance].userList = userlist;

        NOTICE_POST(@"userlistreload");
    }];
}

@end
