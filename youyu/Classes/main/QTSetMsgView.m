//
//  QTSetMsgView.m
//  qtyd
//
//  Created by stephendsw on 16/4/13.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSetMsgView.h"

#import "QTcheckBox.h"
#import "QTSelectedBtn.h"

@implementation QTSetMsgView
{
    NSMutableArray<QTcheckBox *> *boxlist;

    QTSelectedBtn *box;

    BOOL canClear;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, self.width, 30)];

    label.font = [UIFont systemFontOfSize:14];

    label.text = self.title;

    boxlist = [NSMutableArray new];

    box = [QTSelectedBtn viewNib];
    box.left = self.width - box.width - 16;
    box.top = 0;

    [self addSubview:label];
    [self addSubview:box];

    DWrapView *warp = [[DWrapView alloc]initWidth:self.width - 20];
    warp.left = 10;
    warp.top = label.bottom;

    for (NSString *key in self.item.allKeys) {
        QTcheckBox *boxitem = [QTcheckBox viewNib];

        boxitem.height = 25;
        boxitem.title = self.item[key];
        boxitem.contentID = key;
        boxitem.width = warp.width / 2 - 1;
        [warp addView:boxitem];
        boxitem.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [boxlist addObject:boxitem];

        [self bindKeyPath:@"selected" object:boxitem block:^(id newobj) {
            [self.delegate setMsgView:self];

            for (QTcheckBox *item in boxlist) {
                if (!item.selected) {
                    canClear = NO;
                    box.selected = NO;
                    return;
                }
            }

            box.selected = YES;
            canClear = YES;
        }];
    }

    [self addSubview:warp];

    [self setBottomLine:[UIColor whiteColor]];

    [box clickOn:^(id value) {
        self.isSelectdAll = YES;
    } off:^(id value) {
        if (canClear) {
            self.isSelectdAll = NO;
        }
    }];
}

- (void)setIsSelectdAll:(BOOL)isSelectdAll {
    _isSelectdAll = isSelectdAll;

    if (_isSelectdAll) {
        box.selected = YES;

        for (QTcheckBox *item in  boxlist) {
            item.selected = YES;
        }
    } else {
        box.selected = NO;

        for (QTcheckBox *item in  boxlist) {
            item.selected = NO;
        }
    }
}

@end
