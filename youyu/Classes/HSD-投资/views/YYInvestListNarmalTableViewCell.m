//
//  YYInvestListNarmalTableViewCell.m
//  hsd
//
//  Created by LimboDemon on 2017/11/14.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "YYInvestListNarmalTableViewCell.h"

@implementation YYInvestListNarmalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.normalView];
        self.backgroundColor = [Theme backgroundColor];
    }
    return self;
}

-(YYInvestListNormalView *)normalView{
    if (!_normalView) {
        _normalView = [[YYInvestListNormalView alloc] initWithFrame:CGRectMake(RSS(10), RSS(5), APP_WIDTH-RSS(20), RSS(125))];
    }
    return _normalView;
}

@end
