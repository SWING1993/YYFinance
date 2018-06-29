//
//  MenuViewController.h
//  SlideMenu
//
//  Created by dsw on 4/24/13.
//  Copyright (c) 2013 dsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTBaseViewController.h"
#import "QTBaseViewController+Table.h"

@interface KxMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage    *image;
@property (readwrite, nonatomic, strong) NSString   *title;
@property (readwrite, nonatomic, weak) id           target;
@property (readwrite, nonatomic) SEL                action;
@property (readwrite, nonatomic, strong) UIColor    *foreColor;
@property (readwrite, nonatomic) NSTextAlignment    alignment;

+ (instancetype)menuItem:(NSString *)title
                image   :(UIImage *)image
                target  :(id)target
                action  :(SEL)action;

@end

@interface MenuViewController : QTBaseViewController<UITableViewDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic, readonly) UIView *maskView;

@end
