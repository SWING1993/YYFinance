//
//  LjjUIsegumentViewController.h
//  HappyHall
//
//  Created by stephen on 15/6/30.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSegmentedControlDelegate<NSObject>

@optional

- (void)segumentSelectionChange:(NSInteger)selection;

@end

@interface DSegmentedControl : UIView

@property(nonatomic, strong) id<DSegmentedControlDelegate> delegate;

@property(nonatomic, strong) NSMutableArray *ButtonArray;

@property(strong, nonatomic) UIColor *LJBackGroundColor;

@property(strong, nonatomic) UIColor *titleColor;

@property(strong, nonatomic) UIColor *selectColor;

@property(strong, nonatomic) UIFont *titleFont;

- (void)AddSegumentArray:(NSArray *)SegumentArray;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)selectTheSegument:(NSInteger)segument;

- (void)addGesture:(UIView *)view;

@end
