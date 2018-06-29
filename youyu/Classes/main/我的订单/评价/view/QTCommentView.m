//
//  QTCommentView.m
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTCommentView.h"
#import "QTStartView.h"

@interface QTCommentView ()

@end

@implementation QTCommentView
{
    UILabel                         *label;
    NSMutableArray<QTStartView *>   *itemList;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    DWrapView *warp = [[DWrapView alloc]initWidth:APP_WIDTH columns:4];

    warp.subHeight = self.height;

    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, self.height)];
    label.textColor = [Theme grayColor];
    [warp addView:label];

    NSArray<NSString *> *titleList = @[@"满意", @"一般", @"不满意"];

    itemList = [NSMutableArray new];

    for (int i = 0; i < 3; i++) {
        QTStartView *item = [QTStartView viewNib];
        item.title = titleList[i];
        item.selected = NO;
        [itemList addObject:item];
        [warp addView:item];
    }

    for (QTStartView *item in itemList) {
        [item clickOn:^(id value) {
            for (QTStartView *item2 in itemList) {
                if (![item isEqual:item2]) {
                    item2.selected = NO;
                }
            }
        } off:^(id value) {
            item.selected = YES;
        }];
    }

    warp.left = 8;
    [self addSubview:warp];

    itemList.firstObject.selected = YES;
}

- (void)setTitle:(NSString *)title {
    label.height = self.height;
    label.text = title;
}

- (NSString *)value {
    for (int i = 0; i < itemList.count; i++) {
        if (itemList[i].selected) {
            return @(3 - i).stringValue;
        }
    }

    return @"0";
}

@end
