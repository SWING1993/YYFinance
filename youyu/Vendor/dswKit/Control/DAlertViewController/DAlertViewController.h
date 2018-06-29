//
//  DAlertViewController.h
//  自定义警告框
//
//  Created by DSW on 16/8/24.
//  Copyright © 2016年 DSW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;

@end

@interface DAlertViewController : UIViewController

@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UILabel   *messageLabel;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;

- (void)addActionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler;

- (UIButton *)buttonForIndex:(NSInteger)index;

- (void)setHeadImage:(UIImage *)image;

- (void)show;

- (void)showDisappearAnimation;

@end
