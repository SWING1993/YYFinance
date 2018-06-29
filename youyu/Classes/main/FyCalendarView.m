//
//  FyCalendarView.m
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "FyCalendarView.h"

#define buleColor       [UIColor colorHex:@"6BB7CC"]

#define greenColor      [UIColor colorHex:@"4FA35D"]

#define buttonHeight    44

@interface FyCalendarView ()
@property (nonatomic, strong) UIImageView       *selectBtn;
@property (nonatomic, strong) NSMutableArray    *daysArray;
@end

@implementation FyCalendarView
{
    UIColor *oldColor;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];

    if (self) {
        [self setupDate];
        [self setupNextAndLastMonthView];
    }

    return self;
}

- (void)setupDate {
    self.daysArray = [NSMutableArray arrayWithCapacity:42];

    for (int i = 0; i < 42; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [_daysArray addObject:button];
    }

    self.selectBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 7 / 2 - 15, buttonHeight / 2 - 15, 30, 30)];
    self.selectBtn.layer.cornerRadius = self.selectBtn.frame.size.height / 2;
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.backgroundColor = [Theme darkOrangeColor];
    self.selectBtn.image = self.partDaysImage;
    self.selectBtn.alpha = 0.5;
}

- (void)setupNextAndLastMonthView {
    [self addGesture:self];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [leftBtn setImage:[UIImage imageNamed:@"brn_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    leftBtn.tag = 1;
    leftBtn.frame = CGRectMake(10, 10, 40, 30);

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    rightBtn.frame = CGRectMake(self.frame.size.width - 50, 10, 40, 30);
}

- (void)nextAndLastMonth:(UIButton *)button {
    if (button.tag == 1) {
        if (self.lastMonthBlock) {
            self.lastMonthBlock();
        }
    } else {
        if (self.nextMonthBlock) {
            self.nextMonthBlock();
        }
    }
}

- (void)nextMonthClick {
    if (self.nextMonthBlock) {
        self.nextMonthBlock();
    }
}

- (void)lastMonthClick {
    if (self.lastMonthBlock) {
        self.lastMonthBlock();
    }
}

#pragma mark - create View
- (void)setDate:(NSDate *)date {
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date {
    CGFloat itemW = self.frame.size.width / 7;
    CGFloat itemH = buttonHeight;

    // 1.year month
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text = [NSString stringWithFormat:@"%li年%li月", (long)[self year:date], (long)[self month:date]];
    NSLog(@"%@", self.headlabel.text);
    self.headlabel.font = [UIFont systemFontOfSize:14];
    self.headlabel.frame = CGRectMake(0, 0, self.frame.size.width, itemH);
    self.headlabel.textAlignment = NSTextAlignmentCenter;
    self.headlabel.textColor = self.headColor;
    [self addSubview:self.headlabel];

    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.backgroundColor = [UIColor clearColor];
    headBtn.frame = self.headlabel.frame;
    [self addSubview:self.headlabel];

    // 2.weekday
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    self.weekBg = [[UIView alloc] init];
    //    weekBg.backgroundColor = [UIColor orangeColor];
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame), self.frame.size.width, 35);
    [self addSubview:self.weekBg];
    [self.weekBg setBottomLine:[Theme borderColor]];
    [self.weekBg setTopLine:[Theme borderColor]];

    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text = array[i];
        week.font = [UIFont systemFontOfSize:14];
        week.frame = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];

        if ((i == 6) || (i == 0)) {
            week.textColor = greenColor;
        } else {
            week.textColor = buleColor;
        }

        [self.weekBg addSubview:week];
    }

    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        int x = (i % 7) * itemW;
        int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame);

        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.backgroundColor = [UIColor whiteColor];
        NSInteger   daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger   daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger   firstWeekday = [self firstWeekdayInThisMonth:date];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];

        NSInteger day = 0;

        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
        } else if (i > firstWeekday + daysInThisMonth - 1) {
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
        } else {
            day = i - firstWeekday + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_AfterToday:dayButton];

            if ((i % 7 == 6) || (i % 7 == 0)) {
                [dayButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }

        dayButton.tag = day;
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14];

        // this month
        if ([self month:date] == [self month:[NSDate systemDate]]) {
            NSInteger todayIndex = [self day:[NSDate systemDate]] + firstWeekday - 1;

            if ((i < todayIndex) && (i >= firstWeekday)) {} else if (i == todayIndex) {
                [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
                [self logDate:dayButton];
                [dayButton setTitle:@"今" forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - output date

- (void)addGesture:(UIView *)view;
{
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastMonthClick)];

    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMonthClick)];

    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:leftSwipeGestureRecognizer];
    [view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)logDate:(UIButton *)dayBtn {
    if (self.selectBtn.superview) {
        [(UIButton *)self.selectBtn.superview setTitleColor:oldColor forState:UIControlStateNormal];
    }

    [self.selectBtn removeFromSuperview];
    [dayBtn addSubview:self.selectBtn];
    [dayBtn insertSubview:self.selectBtn atIndex:0];

    oldColor = [dayBtn titleColorForState:UIControlStateNormal];

    [dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    NSInteger day = dayBtn.tag;

    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];

    NSString *time = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)[comp year], (long)[comp month], (long)day];

    if (self.calendarBlock) {
        self.calendarBlock(time.dateTypeValue);
    }
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn {
    btn.enabled = NO;

    if (self.isShowOnlyMonthDays) {
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)setStyle_AfterToday:(UIButton *)btn {
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    // 大圈
    for (NSString *str in self.partDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 7 / 2 - 15, buttonHeight / 2 - 15, 30, 30)];
            stateView.layer.cornerRadius = stateView.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = self.partDaysColor;
            stateView.layer.borderWidth = 2;
            stateView.layer.borderColor = buleColor.CGColor;
            stateView.image = self.partDaysImage;
            stateView.alpha = 0.5;

            [btn addSubview:stateView];
            [btn sendSubviewToBack:stateView];
        }
    }

    // 还款
    for (NSString *str in self.partCircleDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_ca_return"]];
            image.frame = CGRectMake(28, 3, 15, 15);

            [btn addSubview:image];
        }
    }
}

#pragma mark - Lazy loading
- (NSArray *)partDaysArr {
    if (!_partDaysArr) {
        _partDaysArr = [NSArray array];
    }

    return _partDaysArr;
}

- (UIColor *)headColor {
    if (!_headColor) {
        _headColor = [UIColor blackColor];
    }

    return _headColor;
}

- (UIColor *)dateColor {
    if (!_dateColor) {
        _dateColor = [UIColor orangeColor];
    }

    return _dateColor;
}

- (UIColor *)partDaysColor {
    if (!_partDaysColor) {
        _partDaysColor = [UIColor whiteColor];
    }

    return _partDaysColor;
}

- (UIColor *)weekDaysColor {
    if (!_weekDaysColor) {
        _weekDaysColor = [UIColor lightGrayColor];
    }

    return _weekDaysColor;
}

// 一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar setFirstWeekday:1];// 1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate      *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger  firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

// 总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];

    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];

    return [components day];
}

- (NSInteger)month:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];

    return [components month];
}

- (NSInteger)year:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];

    return [components year];
}

@end
