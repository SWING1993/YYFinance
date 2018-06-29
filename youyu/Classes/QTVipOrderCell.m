//
//  QTVipOrderCell.m
//  qtyd
//
//  Created by stephendsw on 16/5/31.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTVipOrderCell.h"

@interface QTVipOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel    *money;
@property (weak, nonatomic) IBOutlet UILabel    *lbTime;

@property (weak, nonatomic) IBOutlet UILabel *lbarp;

@property (weak, nonatomic) IBOutlet UILabel    *lbState;
@property (weak, nonatomic) IBOutlet UIButton   *btn;

@end

@implementation QTVipOrderCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bind:(NSDictionary *)obj {
    self.money.text = [NSString stringWithFormat:@"%@万", obj.str(@"reservation_account")];
    self.lbTime.text = [NSString stringWithFormat:@"%@天", obj.str(@"reservation_borrow_days")];
    self.lbarp.text = [NSString stringWithFormat:@"%@％", obj.str(@"reservation_apr")];

    NSInteger state = obj.i(@"check_status");

    if (state == 0) {
        self.lbState.text = @"审核中";
        self.btn.hidden = NO;
        [QTTheme btnWhiteStyle:self.btn];
        [self.btn setTitle:@"取消" forState:UIControlStateNormal];
        [self.btn click:^(id value) {
            if (self.delegate) {
                [self.delegate vipOrderCancel:obj];
            }
        }];
    } else if (state == 1) {
        self.lbState.text = @"审核中";
        self.btn.hidden = NO;
        [QTTheme btnWhiteStyle:self.btn];
        [self.btn setTitle:@"取消" forState:UIControlStateNormal];
        [self.btn click:^(id value) {
            if (self.delegate) {
                [self.delegate vipOrderCancel:obj];
            }
        }];
    } else if (state == 2) {
        self.lbState.text = @"审核中";
        self.btn.hidden = NO;
        [QTTheme btnWhiteStyle:self.btn];
        [self.btn setTitle:@"取消" forState:UIControlStateNormal];
        [self.btn click:^(id value) {
            if (self.delegate) {
                [self.delegate vipOrderCancel:obj];
            }
        }];
    } else if (state == 3) {
        self.lbState.text = @"配对成功";
        self.btn.hidden = NO;
        [QTTheme btnRedStyle:self.btn];
        [self.btn setTitle:@"查看" forState:UIControlStateNormal];
        [self.btn click:^(id value) {
            if (self.delegate) {
                [self.delegate vipOrderDidSelect:obj];
            }
        }];
    } else if (state == 4) {
        self.lbState.text = @"审核失败";
        self.btn.hidden = YES;
    } else if (state == 5) {
        self.lbState.text = @"主动取消";
        self.btn.hidden = YES;
    }
}

@end
