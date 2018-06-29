//
//  MyListView.m
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "MyListView.h"
#import "UIControl+Property.h"

@interface MyListView ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIImageView *imageTip;

@property (weak, nonatomic) IBOutlet UILabel *lbText;

@end

@implementation MyListView

-(void)awakeFromNib
{

    [super awakeFromNib];
    self.backgroundColor=[UIColor whiteColor];
    self.showBackgroundColorHighlighted=YES;
    self.imageTip.hidden=YES;
}

-(void)setText:(NSString *)text img:(NSString *)imageName
{
    self.lbText.text=text;
    self.image.image=[[UIImage imageNamed:imageName] imageWithColor:[Theme grayColor]];
}

-(void)setShowTip:(BOOL)showTip
{
    _showTip=showTip;
    self .imageTip.hidden= !showTip;
}

@end
