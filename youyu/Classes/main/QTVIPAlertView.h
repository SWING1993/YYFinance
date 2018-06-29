//
//  QTVIPAlertView.h
//  qtyd
//
//  Created by stephendsw on 16/6/30.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTVIPAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
