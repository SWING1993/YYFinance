//
//  DAlertViewController+attributeString.m
//  hr
//
//  Created by 慧融 on 26/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "DAlertViewController+attributeString.h"

@implementation DAlertViewController (attributeString)


+ (instancetype)alertControllerWithAttributeTitle:(NSMutableAttributedString *)title message:(NSMutableAttributedString *)message {
    DAlertViewController *instance = [DAlertViewController new];
    
    instance.titleLabel.attributedText = title;
    instance.messageLabel.attributedText = message;
    return instance;
}


- (void)addHideGesture{
    UITapGestureRecognizer *gap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDisappearAnimation)];
    [self.view addGestureRecognizer:gap];

}

- (void)setButtonTitleColor{
    
    NSArray *subViewArray = [self.view allSubviews];
    
    for (UIButton *item in subViewArray) {
        if ([item isKindOfClass:[UIButton class]]&&[item.titleLabel.text isEqualToString:@"继续认证"]) {
            [item setTitleColor:[UIColor colorHex:@"ff5a07"] forState:UIControlStateNormal];
            
        }
    }

}


@end
