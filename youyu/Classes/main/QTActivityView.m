//
//  QTActivity.m
//  qtyd
//
//  Created by stephendsw on 16/5/10.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTActivityView.h"
#import "QTWebViewController.h"

@interface QTActivityView ()
@property (weak, nonatomic) IBOutlet UILabel        *lbName;
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UIButton       *btnAD;

@end

@implementation QTActivityView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTopLine:[Theme borderColor]];
    [self.btnAD setTitle:@" 立即参与 " forState:UIControlStateNormal];
}

- (void)bind:(NSDictionary *)dic {
    self.lbName.text = dic.str(@"title");

    self.image.image = [[UIImage imageNamed:@"icon_gift"] imageWithColor:[Theme darkOrangeColor]];

    NSString    *st = dic.str(@"start_time").dateValue;
    NSString    *et = dic.str(@"end_time").dateValue;
    NSString    *ntime = [NSDate systemDate].shortTimeString;

    if ([ntime compareExpressionWithFormat:@"self >= '%@'  AND  self <= '%@'", st, et]) {
        [QTTheme btnRedStyle:self.btnAD];

        [self.btnAD click:^(id value) {
            QTWebViewController *controller = [QTWebViewController controllerFromXib];
            controller.isNeedLogin = YES;
            controller.url = dic.str(@"url");
            [self.viewController.navigationController pushViewController:controller animated:YES];
        }];
    } else {
        if ([ntime compareExpressionWithFormat:@"self < '%@'", st]) {
            [self.btnAD setTitle:@" 尚未开启 " forState:UIControlStateDisabled];
            [QTTheme btnGrayStyle:self.btnAD];
        } else {
            [self.btnAD setTitle:@" 已结束 " forState:UIControlStateDisabled];
            [QTTheme btnGrayStyle:self.btnAD];
        }
    }
}

@end
