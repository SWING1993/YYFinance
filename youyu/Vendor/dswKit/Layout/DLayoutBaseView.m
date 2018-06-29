//
//  SpecialBaseView.m
//  test
//
//  Created by stephen on 15/2/12.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import "DLayoutBaseView.h"
#import <objc/runtime.h>

//

//

@implementation UIView (Edge)

- (NSValue *)margin {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMargin:(NSValue *)margin {
    objc_setAssociatedObject(self, @selector(margin), margin, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSValue *)padding {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPadding:(NSValue *)padding {
    objc_setAssociatedObject(self, @selector(padding), padding, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UILabel (autoHeight)

+ (void)load {
    Method  imp = class_getInstanceMethod([self class], @selector(setText:));
    Method  myImp = class_getInstanceMethod([self class], @selector(setTextAutoHeight:));

    method_exchangeImplementations(imp, myImp);

    Method  imp2 = class_getInstanceMethod([self class], @selector(setAttributedText:));
    Method  myImp2 = class_getInstanceMethod([self class], @selector(setAttributedTextAutoHeight:));

    method_exchangeImplementations(imp2, myImp2);
}

- (void)setAttributedTextAutoHeight:(NSAttributedString *)attributedText {
    [self setAttributedTextAutoHeight:attributedText];

    if (self.constraints.count == 0) {
        if ([self isMemberOfClass:[UILabel class]] && (self.width != 0)) {
            CGFloat heigth = self.height;
            [self autoHeight];

            // 当高度比原来小时，不改变高度
            if (self.height < heigth) {
                self.height = heigth;
            }
        }
    }
}

- (void)setTextAutoHeight:(NSString *)text {
    [self setTextAutoHeight:text];

    if (self.constraints.count == 0) {
        if ([self isMemberOfClass:[UILabel class]] && (self.width != 0)) {
            CGFloat heigth = self.height;
            [self autoHeight];

            // 当高度比原来小时，不改变高度
            if (self.height < heigth) {
                self.height = heigth;
            }
        }
    }
}

- (void)autoHeight {
    CGSize size = CGSizeMake(self.frame.size.width, 2000);

    if (self.attributedText.string.length > 0) {
         CGFloat heigth = self.height;
        [self sizeToFit];
        // 当高度比原来小时，不改变高度
        if (self.height < heigth) {
            self.height = heigth;
        }
        self.width = size.width;
    } else {
        CGFloat heigth = self.height;
        CGRect  labelRect = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];

        // 当高度比原来小时，不改变高度
        if (self.height < heigth) {
            self.height = heigth;
        } else {
            self.height = labelRect.size.height;
        }

        self.lineBreakMode = NSLineBreakByCharWrapping;
        self.numberOfLines = 0;
    }
}

@end

@implementation DLayoutBaseView

- (instancetype)init {
    self = [super init];

    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
    }

    return self;
}

- (instancetype)initWidth:(CGFloat)width {
    self = [self init];

    if (self) {
        self.frame = CGRectMake(0, 0, width, 0);
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
    }

    return self;
}

- (void)addView:(UIView *)view {}

- (void)updateView {}

- (void)deleteView:(UIView *)view {
    [view removeFromSuperview];
    [self updateView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateView];
}

@end
