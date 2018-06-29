//
//  YYInvestListTopTableViewCell.m
//  hsd
//
//  Created by LimboDemon on 2017/11/14.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YYInvestListTopTableViewCell.h"
#import "YYInvestListTopView.h"

@interface YYInvestListTopTableViewCell()

@property (nonatomic, strong) YYInvestListTopView *topview;

@end

@implementation YYInvestListTopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.topview];
        self.backgroundColor = [Theme backgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(YYInvestListTopView *)topview{
    if (!_topview) {
        _topview = [[YYInvestListTopView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH-RSS(20), RSS(203))];
        _topview.backgroundColor = [UIColor clearColor];
    }
    return _topview;
}

-(void)setModel:(HSDInvestmentModel *)model{
    if (model) {
        self.topview.model = model;
    }
    
}

@end
