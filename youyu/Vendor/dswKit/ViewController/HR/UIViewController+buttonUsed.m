//
//  UIViewController+buttonUsed.m
//  hr
//
//  Created by 慧融 on 24/08/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "UIViewController+buttonUsed.h"

@implementation UIViewController (buttonUsed)

- (void)setButtonStatus:(UIButtonUsedStatus)status buttonTitle:(NSString*)title{
    
    NSArray *subViews = [NSArray arrayWithArray:self.view.allSubviews];
    for (UIButton *item in subViews) {
        
        if ([item isKindOfClass:[UIButton class]]&&[item.titleLabel.text isEqualToString:title]) {
            
            switch (status) {
                case UIButtonUnused:
                    [QTTheme btnGrayStyle:item];
                    break;
                case UIButtonUsed:
                    [QTTheme btnRedStyle:item];
                default:
                    break;
                    
            }
        }
    }
    
}


@end
