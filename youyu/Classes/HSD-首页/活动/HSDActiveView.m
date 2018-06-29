//
//  HSDActiveView.m
//  hsd
//
//  Created by 杨旭冉 on 2017/11/2.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDActiveView.h"

@interface HSDActiveView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPadding;

@end

@implementation HSDActiveView

+ (instancetype) creatActiveView{
    return  [[NSBundle mainBundle] loadNibNamed:@"HSDActiveView" owner:nil options:nil].firstObject;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.frame = APP_FRAEM;
    if (IPHONEX) {
        
        self.topPadding.constant = 110;
    } else {
        self.topPadding.constant = 80;
    }
}

@end
