//
//  DAlertViewController+attributeString.h
//  hr
//
//  Created by 慧融 on 26/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "DAlertViewController.h"

@interface DAlertViewController (attributeString)

+ (instancetype)alertControllerWithAttributeTitle:(NSMutableAttributedString *)title message:(NSMutableAttributedString *)message;

- (void)addHideGesture;

- (void)setButtonTitleColor;


@end
