//
//  DStackView+Theme.m
//  qtyd
//
//  Created by stephendsw on 16/2/23.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "DStackView+Theme.h"
#import "QTTheme.h"

@implementation DStackView (Theme)

#pragma  mark - 样式

- (void)setCodeButtonStyle:(UIButton *)item {
    [QTTheme btnWhiteStyle:item];
}

- (void)setTfviewStyle:(UITextField *)item {
    [QTTheme tbStyle1:item];

    item.font = [UIFont systemFontOfSize:12];
}

- (void)setLabelStyle:(UILabel *)item {
    item.font = [UIFont systemFontOfSize:12];
    [item sizeToFit];
    item.textColor = [Theme grayColor];
}

- (void)setSubmitButtonStyle:(UIButton *)item {
    [QTTheme btnRedStyle:item];
}

- (void)setRightButtonStyle:(UIButton *)item {
    [QTTheme btnWhiteStyle:item];
}

//*****************************************************
- (void)setNewSubmitButtonStyle:(UIButton *)item {
    [QTTheme btnRedGradientStyle:item];
}


@end
