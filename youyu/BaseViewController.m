//
//  BaseViewController.m
//  qtyd
//
//  Created by stephendsw on 15/8/17.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "BaseViewController.h"
#import "AppUtil.h"

@interface BaseViewController ()
@end

@implementation BaseViewController {
    UIView *topview;
    UIView *bottomView;
    UIEdgeInsets bottomEdge;
    UIView *centerView;
    barBlock titleBlock;
    barBlock imageBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setRightBarTitle:(NSString *)title block:(barBlock)block_ {
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightBarTitleClick)];
    self.navigationItem.rightBarButtonItem = itembar;
    titleBlock = block_;
}

- (void)setRightBarImage:(UIImage *)image block:(barBlock)block_ {
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightBarImageClick)];
    self.navigationItem.rightBarButtonItem = itembar;
    imageBlock = block_;
}

- (void)rightBarTitleClick {
    titleBlock();
}

- (void)rightBarImageClick {
    imageBlock();
}

#pragma  mark - layout
- (void)addHeadView:(UIView *)view {
    topview = view;
    [self.view addSubview:topview];
}
- (void)removeTopView{
    [topview removeFromSuperview];
    topview = nil;
    
}

- (void)addBottomView:(UIView *)view {
    bottomView = view;
    [self.view addSubview:bottomView];
}

- (void)addBottomView:(UIView *)view padding:(UIEdgeInsets)edge {
    [self addBottomView:view];
    bottomEdge = edge;
}

- (void)removeBottomView {
    [bottomView removeFromSuperview];
    bottomView = nil;
}

- (void)addCenterView:(UIView *)view {
    centerView = view;
    [self.view addSubview:centerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // ================= has other

    float   top = 0;
    float   cH = 0;

    // top
    if (topview) {
        topview.frame = CGRectMake(0, 0, self.view.width, topview.height);
    }

    // center
    if (centerView) {
        if (topview) {
            top = topview.bottom;
        } else {
            top = 0;
        }

        cH = self.view.height - top - bottomView.height;

        centerView.frame = CGRectMake(0, top, self.view.width, cH);
    }

    // bottom
    if (bottomView) {
        bottomView.width = self.view.width - bottomEdge.left - bottomEdge.right;
        bottomView.height = bottomView.height;
        bottomView.left = bottomEdge.left;
        bottomView.bottom = self.view.height - bottomEdge.bottom;
    }
}

@end
