//
//  HRInvestCell.m
//  hr
//
//  Created by 赵 on 06/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRInvestCell.h"
#import "QTTheme.h"
#import "NSString+model.h"
#import "GVUserDefaults.h"

@interface HRInvestCell()
@property (weak, nonatomic) IBOutlet UILabel *projectNameLB;
@property (weak, nonatomic) IBOutlet UILabel *projectInvestRateLB;
@property (weak, nonatomic) IBOutlet UILabel *projectInvestTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *projectLeftMonenyLB;
@property (weak, nonatomic) IBOutlet UIProgressView *projectPercentProgressLB;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectleftLB;

@end

@implementation HRInvestCell
{
    NSTimer *time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self hideLine];
    self.contentView.width = APP_WIDTH;
    [self.contentView setTopLine:Theme.borderColor];

}

- (void)bind:(NSDictionary *)obj {
    if (time) {
        [time invalidate];
    }
    
    self.enable = YES;
    
    // ================状态 ========================================
    
    // 0等待审核、1审核失败、2投资中、3投资已结束、4已流标、5还款中、6已回款
    NSInteger state = ([obj containsKey:@"borrow_state"] ? obj.str(@"borrow_state") : obj.str(@"real_state")).integerValue;
    
    if (state == 3) {
        self.projectImageView.image = [UIImage imageNamed:@"fullProject"];
    } else if (state == 6) {
        self.projectImageView.image = [UIImage imageNamed:@"repaid"];
    }

        self.projectPercentProgressLB.progress = obj.fl(@"invent_percent") / 100.0f;
        NSString    *hasMoney = @(obj.fl(@"account") - obj.fl(@"account_yes")).stringValue;
        NSString    *invest_balance = [obj containsKey:@"invest_balance"] ? obj.str(@"invest_balance") : hasMoney;
    NSMutableAttributedString *invest_balance_str = [[NSMutableAttributedString alloc]initWithString:invest_balance.add(@"元")];
    [invest_balance_str setFont:[UIFont systemFontOfSize:10] string:@"元"];
    self.projectLeftMonenyLB.attributedText = invest_balance_str;
    self.projectLeftMonenyLB.hidden = NO;
    self.projectleftLB.hidden = NO;
    self.projectPercentProgressLB.hidden = NO;
    self.projectImageView.hidden = YES;
    
    self.projectNameLB.textColor = [UIColor colorHex:@"222222"];
    self.projectInvestRateLB.textColor = [UIColor colorHex:@"ff021f"];
    self.projectInvestTimeLB.textColor = [UIColor colorHex:@"222222"];
    
    if (!invest_balance||[invest_balance isEqualToString:@"0"]) {
        self.projectNameLB.textColor = [UIColor colorHex:@"d8d8d8"];
        self.projectInvestRateLB.textColor = [UIColor colorHex:@"d8d8d8"];
        self.projectInvestTimeLB.textColor = [UIColor colorHex:@"d8d8d8"];
        
        self.projectLeftMonenyLB.hidden = YES;
        self.projectleftLB.hidden = YES;
        self.projectPercentProgressLB.hidden = YES;
        self.projectImageView.hidden = NO;
    }

    
    if (obj.fl(@"apr_add") > 0) {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%% +%@%%", obj.str(@"apr"), obj.str(@"apr_add")]];
        
        [attstr setFont:[UIFont systemFontOfSize:14] string:[NSString stringWithFormat:@"%% +%@%%", obj.str(@"apr_add")]];
        self.projectInvestRateLB.attributedText = attstr;
    } else {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%%", obj.str(@"apr")]];
        
        [attstr setFont:[UIFont systemFontOfSize:14] string:@"%"];
        self.projectInvestRateLB.attributedText = attstr;
    }
    
    
    if ([obj.str(@"borrow_type") isEqualToString:@"840"] || [obj.str(@"borrow_type") isEqualToString:@"900"]) {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@"≤".add(obj[@"loan_period"][@"num"]).add(@" 天")];
        
        [attstr setFont:[UIFont systemFontOfSize:10] string:@"天"];
        
        self.projectInvestTimeLB.attributedText = attstr;
    } else {
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:obj.str(@"loan_period.num").add(@" 天")];
        
        [attstr setFont:[UIFont systemFontOfSize:10] string:@"天"];
        
        self.projectInvestTimeLB.attributedText = attstr;
    }
    
    NSString *borrow_name = obj.str(@"borrow_name");
    self.projectNameLB.text = [borrow_name firstBorrowName];
    
//    if ([NSString tenderType:obj]) {
//        self.image.image = [UIImage imageNamed:[NSString tenderType:obj]];
//    } else {
//        self.image.image = nil;
//    }
    
    // ================倒计时========================================================
//    if (obj[@"server_time"]) {
//        __block NSTimeInterval offtime = obj.i(@"publish_time") - obj.i(@"server_time");
//        
//        [time invalidate];
//        
//        if (offtime > 0) {
//            self.enable = NO;
//            time = [NSTimer timerExecuteCountPerSecond:offtime done:^(NSInteger vlaue) {
//                if (vlaue == 0) {
////                    self.state.text = obj[@"operate"];
//                    self.enable = YES;
////                    self.image.image = nil;
//                    [time invalidate];
//                } else {
//                    self.state.text = [[@(vlaue)stringValue] secondToTimeFormat];
//                }
//            }];
//        }
//    }
}
@end
