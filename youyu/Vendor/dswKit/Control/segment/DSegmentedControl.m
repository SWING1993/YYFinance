//
//  LjjUIsegumentViewController.m
//  HappyHall
//
//  Created by stephen on 15/6/30.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "DSegmentedControl.h"
#import "UIView+layout.h"
@interface DSegmentedControl ()<DSegmentedControlDelegate>
{
    CGFloat     witdFloat;
    UIView      *buttonDown;
    NSInteger   selectSeugment;
    NSInteger   count;
}
@end

@implementation DSegmentedControl
- (void)AddSegumentArray:(NSArray *)SegumentArray {
    self.ButtonArray = [NSMutableArray new];
    count = SegumentArray.count;
    NSInteger seugemtNumber = SegumentArray.count;
    witdFloat = (self.bounds.size.width) / seugemtNumber;

    for (int i = 0; i < SegumentArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * witdFloat, 0, witdFloat, self.bounds.size.height - 2)];
        [button setTitle:SegumentArray[i] forState:UIControlStateNormal];
        //        NSLog(@"这里defont%@",[button.titleLabel.font familyName]);
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];

        if (i == 0) {
            buttonDown = [[UIView alloc]initWithFrame:CGRectMake(i * witdFloat, self.bounds.size.height - 2, witdFloat, 2)];
            [buttonDown setBackgroundColor:[UIColor redColor]];
            [self addSubview:buttonDown];
        }

        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button];
        [self.ButtonArray addObject:button];
    }

    [[self.ButtonArray firstObject] setSelected:YES];
}

- (void)changeTheSegument:(UIButton *)button {
    [self selectTheSegument:button.tag];
}

- (void)selectTheSegument:(NSInteger)segument {
    if (selectSeugment != segument) {
        [self.ButtonArray[selectSeugment] setSelected:NO];
        [self.ButtonArray[segument] setSelected:YES];
        [UIView animateWithDuration:0.3 animations:^{
            [buttonDown setFrame:CGRectMake(segument * witdFloat, self.bounds.size.height - 2, witdFloat, 2)];
        }];
        selectSeugment = segument;
        [self.delegate segumentSelectionChange:selectSeugment];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self.ButtonArray = [NSMutableArray array];
    selectSeugment = 0;
    self.titleFont = [UIFont systemFontOfSize:12];
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 34)];
    self.LJBackGroundColor = [UIColor colorWithRed:253.0f / 255 green:239.0f / 255 blue:230.0f / 255 alpha:1.0f];
    self.titleColor = [UIColor colorWithRed:77.0 / 255 green:77.0 / 255 blue:77.0 / 255 alpha:1.0f];
    self.selectColor = [UIColor colorWithRed:233.0 / 255 green:97.0 / 255 blue:31.0 / 255 alpha:1.0f];
    [self setBackgroundColor:self.LJBackGroundColor];

    return self;
}

- (void)addGesture:(UIView *)view;
{
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rhandleSwipes:)];

    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lhandleSwipes:)];

    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:leftSwipeGestureRecognizer];
    [view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)rhandleSwipes:(id)value {
    NSInteger num = selectSeugment - 1 > 0 ? selectSeugment - 1 : 0;

    [self selectTheSegument:num];
}

- (void)lhandleSwipes:(id)value {
    NSInteger num = selectSeugment + 1 < count ? selectSeugment + 1 : count - 1;

    [self selectTheSegument:num];
}

@end
