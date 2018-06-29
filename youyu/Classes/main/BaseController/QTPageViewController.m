//
//  QTPageInvestRecordViewController.m
//  qtyd
//
//  Created by stephendsw on 15/10/14.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTPageViewController.h"
#import "UIViewController+page.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIViewController+menu.h"
#import "QTDetailsViewController.h"

@interface QTPageViewController ()

@end

@implementation QTPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

- (BOOL)navigationShouldPopOnBackButton {
    if ((self.type == 1) && [[self.navigationController getPreviousController] isKindOfClass:[QTDetailsViewController class]]) {
        self.backBefore = YES;
    }

    if (self.type == 2) {
        self.backBefore = YES;
    }

    if (self.backBefore) {
        return YES;
    } else {
        [self toAccount];
        return NO;
    }
}

@end
