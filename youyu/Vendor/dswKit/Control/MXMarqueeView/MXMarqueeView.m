//
//  MXMarqueeView.m
//  MXMarqueeViewDemo
//
//  Created by Long on 12-9-24.
//  Copyright (c) 2012年 Long. All rights reserved.
//

#import "MXMarqueeView.h"
#import "UIViewExt.h"

@interface MXMarqueeView () {
    UIView                  *firstView, *secondView;
    NSAttributedString      *_text;
    CGSize                  _textSize;
    float                   _textSpace;
    UIFont                  *_font;
    float                   _speed, screenWidth;
    Boolean                 _stop;
    UIInterfaceOrientation  currentOrientation;
}

@end

@implementation MXMarqueeView
@synthesize textSpace = _textSpace;
@synthesize text = _text;
@synthesize font = _font;
@synthesize speed = _speed;

- (id)init {
    [self resetScreenWidth];
    self = [super initWithFrame:CGRectMake(0, 0, screenWidth, 0)];

    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.textSpace = 50;
        self.font = [UIFont fontWithName:@"Heiti SC" size:18];
        self.speed = 40;
        _stop = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, frame.origin.y, screenWidth, frame.size.height)];
    return self;
}

- (void)setBackgroundImage:(UIImage *)image {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:image];

    [bgView setFrame:self.bounds];
    [self addSubview:bgView];
    [self sendSubviewToBack:bgView];
    bgView = nil;
}

- (void)setText:(NSAttributedString *)text {
    _text = text;
    [self setTextSize];

    if (_textSize.width > 0) {
        [self resetAnimationView];
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self setTextSize];
    [self resetAnimationView];
}

- (void)setSpeed:(float)speed {
    if (speed > 0) {
        _speed = speed;
        [self resetAnimationView];
    }
}

- (void)setTextSpace:(float)textSpace {
    if (textSpace >= 0) {
        _textSpace = textSpace;
        [self resetAnimationView];
    }
}

- (void)setTextSize {
    _textSize = [[self.text string] sizeWithFont:_font constrainedToSize:CGSizeMake(10000, 100) lineBreakMode:UILineBreakModeCharacterWrap];
}

- (Boolean)resetScreenWidth {
    UIApplication *app = [UIApplication sharedApplication];

    if (currentOrientation != app.statusBarOrientation) {
        if ((app.statusBarOrientation == UIInterfaceOrientationPortrait) || (app.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
            screenWidth = [[UIScreen mainScreen] bounds].size.width;
            currentOrientation = app.statusBarOrientation;
            return YES;
        } else if ((app.statusBarOrientation == UIInterfaceOrientationLandscapeLeft) || (app.statusBarOrientation == UIInterfaceOrientationLandscapeRight)) {
            screenWidth = [[UIScreen mainScreen] bounds].size.height;
            currentOrientation = app.statusBarOrientation;
            return YES;
        }
    }

    return NO;
}

- (void)deviceOrientationDidChange {
    if ([self resetScreenWidth]) {
        [self resetAnimationView];
    }
}

- (void)resetAnimationView {
    [self deallocAnimationView];
    [self setFrame:CGRectMake(0, self.frame.origin.y, screenWidth, self.height)];
    firstView = [self animationView];
    secondView = [self animationView];
    [self addSubview:firstView];
    [self addSubview:secondView];
}

- (void)startAnimation {
    [self viewAnimation1:firstView finish:@selector(viewAnimation2)];
}

- (void)stopAnimation {
    _stop = YES;
}

- (UIView *)animationView {
    UIView  *tempView = [[UIView alloc] init];
    float   viewWidth = 0;

    while (viewWidth < screenWidth) {
        CGRect labelFrame = self.bounds;
        labelFrame.origin.x = viewWidth;
        labelFrame.size.width = _textSize.width + _textSpace;

        UILabel *tempLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [tempLabel setBackgroundColor:[UIColor clearColor]];
        tempLabel.attributedText = _text;
        [tempLabel setFont:_font];
        [tempView addSubview:tempLabel];

        tempLabel.height = self.height;
        tempLabel.backgroundColor = self.backgroundColor;

        viewWidth += (_textSize.width + _textSpace);
    }

    CGRect viewFrame = self.bounds;
    viewFrame.origin.x = screenWidth;
    viewFrame.size.width = viewWidth;
    viewFrame.size.height = self.height;
    [tempView setFrame:viewFrame];

    return tempView;
}

- (void)viewAnimation1:(UIView *)_view finish:(SEL)_sel {
    CGRect rect = _view.frame;

    rect.origin.x = screenWidth;
    [_view setFrame:rect];
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:_view.frame.size.width / _speed];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:_sel];
    CGRect rect1 = _view.frame;
    rect1.origin.x = screenWidth - _view.frame.size.width;
    [_view setFrame:rect1];
    [UIView commitAnimations];
}

- (void)viewAnimation2 {
    if (!_stop) {
        [self viewAnimation1:secondView finish:@selector(viewAnimation2)];
        CGRect rect = firstView.frame;
        rect.origin.x = screenWidth - firstView.frame.size.width;
        [firstView setFrame:rect];
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:screenWidth / _speed];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        CGRect rect1 = firstView.frame;
        rect1.origin.x = -firstView.frame.size.width;
        [firstView setFrame:rect1];
        [UIView commitAnimations];
    }
}

- (void)deallocAnimationView {
    if (firstView != nil) {
        [firstView removeFromSuperview];

        firstView = nil;
    }

    if (secondView != nil) {
        [secondView removeFromSuperview];

        secondView = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [self deallocAnimationView];
    [self stopAnimation];

    if (_text != nil) {
        _text = nil;
    }
}

@end
