//
//  DXibView.m
//  qtyd
//
//  Created by stephendsw on 2016/11/15.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "DXibView.h"

@implementation DXibView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self loadView];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadView];
}

- (NSString *)getXibName {
    NSString *clzzName = NSStringFromClass(self.classForCoder);

    NSArray *nameArray = [clzzName componentsSeparatedByString:@"."];

    NSString *xibName = nameArray[0];

    if (nameArray.count == 2) {
        xibName = nameArray[1];
    }

    return xibName;
}

- (void)loadView {
    if (self.contentView != nil) {
        return;
    }

    self.contentView = [self loadViewWithNibName:[self getXibName] owner:self];

    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = [UIColor clearColor];

    [self addSubview:self.contentView];
}

- (UIView *)loadViewWithNibName:(NSString *)fileName owner:(NSObject *)owner {
    return [[NSBundle mainBundle] loadNibNamed:fileName owner:owner options:nil][0];
}

@end
