//
//  HRHomeTableViewCell.m
//  hr
//
//  Created by 赵 on 05/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRHomeTableViewCell.h"
#import "QTTheme.h"
#import "NSString+model.h"
#import "GVUserDefaults.h"
#import "HSDInvestmentModel.h"

@interface HRHomeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *rateLable; //年化
@property (weak, nonatomic) IBOutlet UILabel *startNumLable; //起投金额
@property (weak, nonatomic) IBOutlet UILabel *termLable; //收益期限
@property (weak, nonatomic) IBOutlet UILabel *surplusLable; //剩余金额
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewRightMargin; //进度条距右的间距
@property (weak, nonatomic) IBOutlet UIButton *investBtn; //投资按钮


@end

@implementation HRHomeTableViewCell{
 
    NSTimer *time;
}

/*
 *立即投资
 */
- (IBAction)investmentiBtnClick:(id)sender {
    if (self.investmentBlock) {
        self.investmentBlock();
    }
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self .contentView.width = APP_WIDTH;
    [self.contentView setTopLine:Theme.borderColor];
    self.rateLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:34];
}

-(void)setModel:(HSDInvestmentModel *)model{
    
    self.titleLable.text = model.borrow_name;
    
    NSString *invest_percent = model.apr;
    self.rateLable.text = invest_percent.add(@"%");
    
    NSString *invest_mininum =model.invest_minimum;
    self.startNumLable.text =invest_mininum.add(@"元起投");
    
    NSString *borrow_reset_time = model.loan_period[@"num"];
    self.termLable.text =@"收益期限".add(borrow_reset_time).add(@"天");
    
    NSString *invest_balance = model.invest_balance;
    self.surplusLable.text = @"剩余金额".add([invest_balance moneyFormatDataWithIntegerValue]).add(@"元");
    
    CGFloat margin = 1 - model.invent_percent / 100.0;
    self.progressViewRightMargin.constant = margin * (APP_WIDTH - 34);
    
    [self investBtnStast:model.real_state];
}

- (void)bind:(NSDictionary *)obj{

    if (time) {
        [time invalidate];
    }
    self.enable = YES;
    
//    NSString *new_hand = obj.str(@"new_hand");
//    if ([new_hand isEqualToString:@"0"]) {
//        self.projectTypeLB.text = @"精品推荐";
//    }else if ([new_hand isEqualToString:@"1"]){
//        self.projectTypeLB.text = @"Vip专享";
//    }else if ([new_hand isEqualToString:@"2"]){
//        self.projectTypeLB.text = @"新手专享";
//    }else{
//        self.projectTypeLB.text = @"福利推荐";
//    }
    
    self.titleLable.text = obj.str(@"borrow_name");
    
    NSString *invest_percent = obj.str(@"apr");
    self.rateLable.text = invest_percent.add(@"%");
    
    NSString *invest_mininum =obj.str(@"invest_minimum");
    self.startNumLable.text =invest_mininum.add(@"元起投");
    
    NSString *borrow_reset_time = obj.str(@"borrow_rest_time");
    self.termLable.text =@"收益期限".add(borrow_reset_time).add(@"天");
    
    NSString *invest_balance = obj.str(@"invest_balance");
    self.surplusLable.text = @"剩余金额".add([invest_balance moneyFormatDataWithIntegerValue]).add(@"元");
    ///TODO:已投资百分占比
    CGFloat margin = 1 - obj.str(@"invent_percent").intValue / 100.0;
    self.progressViewRightMargin.constant = margin * (APP_WIDTH - 34);
    [self investBtnStast:obj.str(@"real_state")];
}

/**
   立即投资按钮状态
 */
- (void) investBtnStast:(NSString *) typeStr {
    // 0等待审核、1审核失败、2投资中、3投资已结束、4已流标、5还款中、6已回款
    switch (typeStr.integerValue) {
        case 0:{
            [self availableBtn:@"等待审核"];
            break;
        }
        case 1:{
            [self disAvailableBtn:@"审核失败"];
            break;
        }
        case 2:{
            [self availableBtn:@"立即投资"];
            break;
        }
        case 3:{
            [self disAvailableBtn:@"已满标"];
            break;
        }
        case 4:{
            [self disAvailableBtn:@"已流标"];
            break;
        }
        case 5:{
            [self disAvailableBtn:@"还款中"];
            break;
        }
        case 6:{
            [self disAvailableBtn:@"已回款"];
            break;
        }
    }
}

- (void) availableBtn: (NSString *) title {
    self.investBtn.layer.borderColor = [Theme mainOrangeColor].CGColor;
    [self.investBtn setTitle:title forState:UIControlStateNormal];
    [self.investBtn setTitleColor:[Theme mainOrangeColor] forState:UIControlStateNormal];
}

- (void) disAvailableBtn: (NSString *) title {
    self.investBtn.layer.borderColor = [Theme grayColor].CGColor;
    [self.investBtn setTitle:title forState:UIControlStateNormal];
    [self.investBtn setTitleColor:[Theme grayColor] forState:UIControlStateNormal];
}


@end
