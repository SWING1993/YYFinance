//
//  QTRankView.m
//  qtyd
//
//  Created by stephendsw on 16/3/7.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRankView.h"
#import "QTTheme.h"
#import "UIImageView+WebCache.h"


#define Height              60

#define SmallCircleWidth    15

#define CircleToCircleWidth 80

#define LineHeight          10

#define OFFSETX             (APP_WIDTH / 2)

@implementation QTRankView
{
    UIView *backgroudView;

    NSMutableArray<UILabel *> *circleList;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = Theme.mainOrangeColor;
        self.width = CircleToCircleWidth * 6 + OFFSETX * 2;
        self.height = Height;

        backgroudView = [[UIView alloc]initWithFrame:CGRectMake(-100, 0, self.width + 200, LineHeight)];

        backgroudView.centerY = Height / 2;
        backgroudView.layer.borderColor = [UIColor whiteColor].CGColor;
        backgroudView.layer.borderWidth = 2;
        backgroudView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

        [self addSubview:backgroudView];

        circleList = [NSMutableArray new];

        for (int i = 0; i < 7; i++) {
            UILabel *circle = [[UILabel alloc]initWithFrame:CGRectMake(OFFSETX - SmallCircleWidth + i * CircleToCircleWidth, 0, SmallCircleWidth * 2, SmallCircleWidth * 2)];
            circle.centerY = Height / 2;
            circle.text = [NSString stringWithFormat:@"V%d", i + 1];
            circle.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
            circle.layer.borderColor = [UIColor whiteColor].CGColor;
            circle.layer.borderWidth = 2;
            circle.layer.cornerRadius = SmallCircleWidth;
            circle.textAlignment = NSTextAlignmentCenter;
            circle.layer.masksToBounds = YES;
            circle.textColor = [UIColor darkGrayColor];
            circle.font = [UIFont italicSystemFontOfSize:13];
            [circleList addObject:circle];
            [self addSubview:circle];
        }
    }

    return self;
}

- (void)setImage:(NSString *)url rank:(NSString *)rank {
    NSInteger   il = [rank stringByReplacingOccurrencesOfString:@"V" withString:@""].integerValue;
    CGFloat     offset = (il - 1) * CircleToCircleWidth + OFFSETX - Height / 2;

    // ******************************************进度条**************************************************
    CALayer *proess = [[CALayer alloc]init];

    proess.frame = CGRectMake(0, 2, OFFSETX + il * CircleToCircleWidth, LineHeight - 4);
    proess.backgroundColor = [UIColor yellowColor].CGColor;
    [backgroudView.layer addSublayer:proess];

    for (int i = 0; i < il; i++) {
        circleList[i].backgroundColor = [UIColor yellowColor];
    }

    // ********************************************************************************************
    UIImageView *view = [UIImageView new];

    view.backgroundColor = Theme.backgroundColor;
    [view setImageWithURLString:url placeholderImageString:@"iconfont_morentouxiang"];

    view.width = Height;
    view.height = Height;
    view.layer.cornerRadius = Height / 2;
    view.layer.masksToBounds = YES;

    CAGradientLayer *_gradientLayer = [CAGradientLayer layer];    // 设置渐变效果
    _gradientLayer.bounds = view.bounds;
    _gradientLayer.borderWidth = 0;

    _gradientLayer.frame = view.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
        (id)[[UIColor clearColor] CGColor],

        (id)[[UIColor colorHex:@"773131"] CGColor],
        nil];
    // _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    // _gradientLayer.endPoint = CGPointMake(0.5, 1.0);

    _gradientLayer.locations = @[@(0.4), @(1.0)];
    [view.layer insertSublayer:_gradientLayer atIndex:0];

    UILabel *label = [UILabel new];
    label.center = CGPointMake(0, view.height - 26);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = rank;
    label.textColor = [UIColor colorWithRed:1 green:238 / 255.0 blue:3 / 255.0 alpha:1];
    label.font = [UIFont italicSystemFontOfSize:18];
    [label sizeToFit];
    label.width = Height;
    [view addSubview:label];

    view.layer.borderColor = Theme.backgroundColor.CGColor;
    view.layer.borderWidth = 3;
    [self addSubview:view];

    view.left += offset;

    self.scrollOffsetX = (il - 1) * CircleToCircleWidth;
}

@end
