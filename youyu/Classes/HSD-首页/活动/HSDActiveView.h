//
//  HSDActiveView.h
//  hsd
//
//  Created by 杨旭冉 on 2017/11/2.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSDActiveView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

+ (instancetype) creatActiveView;

@end
