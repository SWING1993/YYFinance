//
//  WMPageController.h
//  WMPageController
//
//  Created by dsw on 15/6/11.
//  Copyright (c) 2015年 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMenuView.h"
#import "YYBaseViewController.h"

@class WMPageController;
@protocol WMPageControllerDelegate<NSObject>

- (UIView *)WMPageControllerAddBottomView:(WMPageController *)pagec;

@end

@interface WMPageController : YYBaseViewController

@property (nonatomic, assign) BOOL isMenuInTop;

@property (nonatomic, weak) WMMenuView *menuView;

@property (nonatomic, weak) id<WMPageControllerDelegate> delegate;

@property (nonatomic, assign) CGFloat bottomHeight;

@property (nonatomic, copy) NSArray<UIViewController *> *viewControllerClasses;

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, strong, readonly) UIViewController *currentViewController;

@property (nonatomic, assign) int selectIndex;

@property (nonatomic, assign) CGFloat titleSizeSelected;

@property (nonatomic, assign) CGFloat titleSizeNormal;

@property (nonatomic, strong) UIColor *titleColorSelected;

@property (nonatomic, strong) UIColor *titleColorNormal;

@property (nonatomic, copy) NSString *titleFontName;

@property (nonatomic, assign) CGFloat menuHeight;

@property (nonatomic, assign) CGFloat cutHeight;

@property (nonatomic, assign) CGFloat menuItemWidth;

@property (nonatomic, copy) NSArray *itemsWidths;

@property (nonatomic, strong) UIColor *menuBGColor;

/**
 *  Menu view 的样式，默认为无下划线
 *  Menu view's style, now has two different styles, 'Line','default'
 */
@property (nonatomic, assign) WMMenuViewStyle menuViewStyle;

/**
 *  进度条的颜色，默认和选中颜色一致(如果 style 为 Default，则该属性无用)
 *  The progress's color,the default color is same with `titleColorSelected`.If you want to have a different color, set this property.
 */
@property (nonatomic, strong) UIColor *progressColor;

- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles;

- (void)loadData;

@end
