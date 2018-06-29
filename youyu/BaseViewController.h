//
//  BaseViewController.h
//  qtyd
//
//  Created by stephendsw on 15/8/17.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFormAdd.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIImageView+WebCache.h"

typedef void (^ barBlock) ();

@interface BaseViewController : YYBaseViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (void)setRightBarTitle:(NSString *)title block:(barBlock)block_;
- (void)setRightBarImage:(UIImage *)image block:(barBlock)block_;

#pragma mark - layout
- (void)addHeadView:(UIView *)view;
- (void)addBottomView:(UIView *)view;
- (void)addBottomView:(UIView *)view padding:(UIEdgeInsets)edge;
- (void)removeBottomView;
- (void)removeTopView;
- (void)addCenterView:(UIView *)view;

@end
