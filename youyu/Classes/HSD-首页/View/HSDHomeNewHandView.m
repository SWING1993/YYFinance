//
//  HSDHomeNewHandView.m
//  hsd
//
//  Created by 杨旭冉 on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDHomeNewHandView.h"
#import "VWWWaterView.h"
#import "HSDInvestmentModel.h"
#import "ZJLabel.h"

@interface HSDHomeNewHandView()

@property (nonatomic, strong) VWWWaterView *waterView;
@property (nonatomic, strong) ZJLabel *waterLabel;

@end

@implementation HSDHomeNewHandView

+ (instancetype) creatNewHandView {
    return  [[NSBundle mainBundle] loadNibNamed:@"HSDHomeNewHandView" owner:nil options:nil].firstObject;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    [self.layer masksToBounds];
    
    [self initWaterView];
}

-(void)initWaterView{
//    self.waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(0, 0, 125, 125)];
////    self.waterView.backgroundColor = [UIColor colorHex:@"FB656E"];//页面背景颜色改背景
//    self.waterView.currentWaterColor = [MainColor colorWithAlphaComponent:0.5];//水波颜色
//    self.waterView.percentum = 0.32;//百分比
    
    [self.circleView addSubview:self.waterLabel];
}

-(ZJLabel *)waterLabel{
    if (!_waterLabel) {
        _waterLabel = [[ZJLabel alloc] initWithFrame:CGRectMake(5, 5, 115, 115)];
        _waterLabel.layer.cornerRadius = 57.5;
        _waterLabel.layer.masksToBounds = YES;
        _waterLabel.decimalsCount = NO;
    }
    return _waterLabel;
}

-(void)setModel:(HSDInvestmentModel *)model{
    _model = model;
    CGFloat percent = model.invent_percent / 100.0;
    self.waterLabel.present = percent;
    
    NSString *rata = [NSString stringWithFormat:@"%@",model.apr];
    NSString *rataStr = rata.add(@"%").add(@"\n预期年化");
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:rataStr];
    [attr addAttribute:NSForegroundColorAttributeName value:[Theme mainOrangeColor] range:NSMakeRange(0, rataStr.length - 6)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(rataStr.length - 6, 6)];
    self.rateLabel.attributedText = attr;
    
    
    NSString *allday = [NSString stringWithFormat:@"%@",model.borrow_rest_time];
    NSString *dayStr = allday.add(@"天").add(@"\n项目周期");
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:dayStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[Theme mainOrangeColor] range:NSMakeRange(0, dayStr.length - 6)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(dayStr.length - 6, 6)];
    self.timeLimitLabel.attributedText = attributedStr;
    
    NSString *allMoneyStr = [NSString stringWithFormat:@"%@",model.invest_balance];
    NSString *showAllMoneyStr = allMoneyStr.add(@"元").add(@"\n项目金额");
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:showAllMoneyStr];
    [attribute addAttribute:NSForegroundColorAttributeName value:[Theme mainOrangeColor] range:NSMakeRange(0, showAllMoneyStr.length - 6)];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(showAllMoneyStr.length - 6, 6)];
    self.overageLabel.attributedText = attribute;
    self.titleLabel.text = model.title;
    self.titleRightLabel.text = [NSString stringWithFormat:@"%@      ",model.title_content];

    
}












@end
