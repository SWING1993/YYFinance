//
//  QTOpenSinaViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTOpenSinaViewController.h"
#import "QTWebViewController.h"
#import "UIViewController+page.h"

#import "DFormAdd.h"

@interface QTOpenSinaViewController ()

@property (strong, nonatomic) IBOutlet UILabel *tip2;

@property (weak, nonatomic)  WTReTextField *tfName;

@property (weak, nonatomic)  WTReTextField *tfCard;

@end

@implementation QTOpenSinaViewController

- (void)viewDidLoad {
    self.titleView.title = @"实名认证";

    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    if (self.isGoBack) {
        return YES;
    } else {
        [self toAccount];
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"IDCardView"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"IDCardView"];
}

- (void)initUI {
    DStackView *stack = [[DStackView  alloc]initWidth:APP_WIDTH];

    [stack addView:self.tip2 margin:UIEdgeInsetsMake(16, 20, 16, 20)];

    DGridView *grid = [[DGridView alloc]initWidth:stack.width];
    grid.backgroundColor = [UIColor whiteColor];
    [grid setColumn:16 height:44];
    self.tfName = [grid addRowInput:@"真实姓名" placeholder:@"请输入真实姓名"];
    self.tfCard = [grid addRowInput:@"身份证号" placeholder:@"请输入身份证号"];
    [stack addView:grid];

    [stack addRowButtonTitle:@"实名认证" click:^(id value) {
        [self clickSubmit];
    }];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];

#ifdef DEBUG
        self.tfName.text = @"施云";
        self.tfCard.text = @"340101198208012390";
#endif
}

- (void)initData {
    [self.tfName setRealName];
    self.tfName.group = 0;

    [self.tfCard setIDCard];
    self.tfCard.group = 0;
}

#pragma  mark - event
- (void)clickSubmit {
    [self.view endEditing:YES];

    if (![self.view validation:0]) {
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"real_name"] = self.tfName.text;
    dic[@"card_id"] = [self.tfCard.text enValue];
    dic[@"type"] = @"1";
    [self commonJson:dic];
}

#pragma  mark - json
- (void)commonJson:(NSMutableDictionary *)dic {
    [self showHUD];
    [service post:@"user_realname" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        [GVUserDefaults  shareInstance].real_status = 1;
        [GVUserDefaults  shareInstance].realname = self.tfName.text;
        [GVUserDefaults  shareInstance].card_id = self.tfCard.text;
        NSString *status = value.str(@"status");
        if ([status isEqualToString:@"2"]) {
            [self showToast:@"实名认证失败"];
            return ;
        }
        [self showToast:@"实名认证成功" done:^{
            [MobClick event:@"IDCardBt"];
            [self toGift];
        }];
    }];
}

@end
