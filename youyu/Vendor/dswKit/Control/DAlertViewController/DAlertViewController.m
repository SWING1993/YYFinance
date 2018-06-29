//
//  DAlertViewController.m
//  自定义警告框
//
//  Created by DSW on 16/8/24.
//  Copyright © 2016年 DSW. All rights reserved.
//

#import "DAlertViewController.h"

static UIWindow *alertWindow;

@interface SFHighLightButton : UIButton

@property (strong, nonatomic) UIColor *highlightedColor;

@end

@implementation SFHighLightButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (highlighted) {
        self.backgroundColor = self.highlightedColor;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundColor = nil;
        });
    }
}

@end

#define kThemeColor [UIColor colorWithRed:94 / 255.0 green:96 / 255.0 blue:102 / 255.0 alpha:1]

@interface CKAlertAction ()

@property (copy, nonatomic) void (^actionHandler)(CKAlertAction *action);

@end

@implementation CKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler {
    CKAlertAction *instance = [CKAlertAction new];

    instance->_title = title;
    instance.actionHandler = handler;
    return instance;
}

@end

@interface DAlertViewController ()
{
    UIView  *_shadowView;
    UIView  *_contentView;

    UIEdgeInsets                _contentMargin;
    CGFloat                     _contentViewWidth;
    CGFloat                     _buttonHeight;
    NSMutableArray<UIButton *>  *btns;

    BOOL _firstDisplay;
}

@property (strong, nonatomic) NSMutableArray<CKAlertAction *> *mutableActions;

@end

@implementation DAlertViewController

- (instancetype)init {
    if (self = [super init]) {
        _contentMargin = UIEdgeInsetsMake(20, 20, 20, 20);
        _contentViewWidth = 285;
        _buttonHeight = 45;
        _firstDisplay = YES;

        self.modalPresentationStyle = UIModalPresentationCustom;

        btns = [NSMutableArray new];
        self.mutableActions = [NSMutableArray new];

        [self creatShadowView];
        [self creatContentView];

        self.titleLabel = [self creatLabelWithFontSize:16];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];

        self.messageLabel = [self creatLabelWithFontSize:12];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_messageLabel];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    DAlertViewController *instance = [DAlertViewController new];

    instance.titleLabel.text = title;
    instance.messageLabel.text = message;
    return instance;
}

#pragma mark 页面

// 阴影层
- (void)creatShadowView {
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentViewWidth, 175)];
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    _shadowView.layer.shadowRadius = 20;
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 10);
    [self.view addSubview:_shadowView];
}

// 内容层
- (void)creatContentView {
    _contentView = [[UIView alloc] initWithFrame:_shadowView.bounds];
    _contentView.backgroundColor = [UIColor colorWithRed:250 green:251 blue:252 alpha:1];
    _contentView.layer.cornerRadius = 13;
    _contentView.clipsToBounds = YES;
    [_shadowView addSubview:_contentView];
}

// 创建所有按钮
- (void)creatAllButtons {
    for (int i = 0; i < self.mutableActions.count; i++) {
        SFHighLightButton *btn = [SFHighLightButton new];
        btn.tag = 10 + i;
        btn.highlightedColor = [UIColor colorWithWhite:0.97 alpha:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn setTitle:self.mutableActions[i].title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
        [btns addObject:btn];
    }
}

// 创建所有的分割线
- (void)creatAllSeparatorLine {
    if (!btns.count) {
        return;
    }

    // 要创建的分割线条数
    NSInteger linesAmount = 1 + btns.count - 1;

    for (int i = 0; i < linesAmount; i++) {
        UIView *separatorLine = [UIView new];
        separatorLine.tag = 1000 + i;
        separatorLine.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        [_contentView addSubview:separatorLine];
    }
}

- (UILabel *)creatLabelWithFontSize:(CGFloat)fontSize {
    UILabel *label = [UILabel new];

    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = kThemeColor;
    return label;
}

- (void)updateFrame {
    // 更新title的frame
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    CGFloat titleHeight = 0.0;

    if (self.titleLabel.text.length) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        titleHeight = size.height;
        self.titleLabel.frame = CGRectMake(_contentMargin.left, _contentMargin.top, labelWidth, size.height);
    }

    // 更新message的frame
    CGFloat messageY = _titleLabel.bottom >0 ? _titleLabel.bottom + 10 :_contentMargin.top;

    if (self.messageLabel.text.length) {
        CGSize size = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        self.messageLabel.frame = CGRectMake(_contentMargin.left, messageY, labelWidth, size.height);
    }

    //  更新button的frame
    CGFloat firstButtonY = _messageLabel.bottom + _contentMargin.bottom;

    CGFloat buttonWidth = self.mutableActions.count > 2 ? _contentViewWidth : _contentViewWidth / self.mutableActions.count;

    for (int i = 0; i < self.mutableActions.count; i++) {
        UIButton    *btn = [_contentView viewWithTag:10 + i];
        CGFloat     buttonX = self.mutableActions.count > 2 ? 0 : buttonWidth * i;
        CGFloat     buttonY = self.mutableActions.count > 2 ? firstButtonY + _buttonHeight * i : firstButtonY;

        btn.frame = CGRectMake(buttonX, buttonY, buttonWidth, _buttonHeight);
    }

    // 分割线的条数
    NSInteger linesAmount = btns.count;

    for (int i = 0; i < linesAmount; i++) {
        // 获取到分割线
        UIView *separatorLine = [_contentView viewWithTag:1000 + i];

        // 获取到对应的按钮
        if (i == 0) {
            UIButton *btn = btns[0];
            separatorLine.frame = CGRectMake(_contentMargin.left, btn.top - 1, _contentViewWidth - _contentMargin.left - _contentMargin.right, 1);
        } else {
            UIButton *btn = btns[i - 1];

            if (btns.count > 2) {
                separatorLine.frame = CGRectMake(_contentMargin.left, btn.bottom, _contentViewWidth - _contentMargin.left - _contentMargin.right, 1);
            } else {
                separatorLine.frame = CGRectMake(btn.right, btn.top + 5, 1, btn.height - 10);
            }
        }
    }

    CGFloat allButtonHeight;

    if (!self.mutableActions.count) {
        allButtonHeight = 0;
    } else if (self.mutableActions.count < 3) {
        allButtonHeight = _buttonHeight;
    } else {
        allButtonHeight = _buttonHeight * self.mutableActions.count;
    }

    // 更新警告框的frame
    CGRect frame = _shadowView.frame;
    frame.size.height = firstButtonY + allButtonHeight;
    _shadowView.frame = frame;

    _contentView.frame = _shadowView.bounds;

    _shadowView.top = APP_HEIGHT / 2 - _shadowView.height / 2;
    _shadowView.left = APP_WIDTH / 2 - _shadowView.width / 2;
}

- (void)show {
    // 创建对话框

    [self creatAllButtons];
    [self creatAllSeparatorLine];

    [self updateFrame];

    alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    alertWindow.rootViewController = self;
    [alertWindow addSubview:self.view];
    [alertWindow makeKeyAndVisible];

    // 显示弹出动画
    [self showAppearAnimation];
}

- (void)showAppearAnimation {
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _shadowView.transform = CGAffineTransformIdentity;
            _shadowView.alpha = 1;
        } completion:nil];
    }
}

- (void)showDisappearAnimation {
    [UIView animateWithDuration:0.1 animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        alertWindow = nil;
    }];
}

#pragma mark - 其他
- (void)didClickButton:(UIButton *)sender {
    CKAlertAction *action = self.mutableActions[sender.tag - 10];

    if (action.actionHandler) {
        action.actionHandler(action);
    }

    [self showDisappearAnimation];
}

- (void)setHeadImage:(UIImage *)image {
    NSMutableAttributedString *str = [NSMutableAttributedString new];

    [str appendImage:image];
    self.titleLabel.attributedText = str;
}

- (UIButton *)buttonForIndex:(NSInteger)index {
    return btns[index];
}

- (void)addActionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler {
    CKAlertAction *action = [CKAlertAction actionWithTitle:title handler:handler];

    [self.mutableActions addObject:action];
}

@end
