//
//  UIViewController+buttonUsed.h
//  hr
//
//  Created by 慧融 on 24/08/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,UIButtonUsedStatus){
    UIButtonUnused = 0,
    UIButtonUsed = 1,
    
};
@interface UIViewController (buttonUsed)
- (void)setButtonStatus:(UIButtonUsedStatus)status buttonTitle:(NSString*)title;
@end
