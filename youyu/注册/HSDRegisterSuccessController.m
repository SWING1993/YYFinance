//
//  HSDRegisterSuccessController.m
//  hsd
//
//  Created by bfd on 2017/11/9.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HSDRegisterSuccessController.h"
#import "YYTimer.h"
#import "HRBindBankViewController.h"

@interface HSDRegisterSuccessController () {
    BOOL isTapped;//标记moreBtn是否被点击
}

@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;

@property (nonatomic,strong) YYTimer *timer;
@property (nonatomic,assign) NSInteger count;
@end

@implementation HSDRegisterSuccessController

- (BOOL)navigationShouldPopOnBackButton {
    [self toHome];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleView.title = @"注册成功";
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    isTapped = NO;
}

- (void)initUI {
    [self initScrollView];
    self.showView.frame = CGRectMake(0, 10, APP_WIDTH, 200);
    self.moreView.frame = CGRectMake(0, CGRectGetMaxY(self.showView.frame) + 50, APP_WIDTH, 44);
    [self.scrollview addSubview:self.showView];
    [self.scrollview addSubview:self.moreView];
    [self.scrollview autoContentSize];
    
    //控件样式设置
    self.showView.backgroundColor = [UIColor clearColor];
    self.restLabel.backgroundColor = [UIColor clearColor];
    self.moreBtn.backgroundColor = [Theme mainOrangeColor];
    
    //响应事件处理
    WEAKSELF;
    [self.moreBtn click:^(id value) {
        NSLog(@"more");
        isTapped = YES;
        [self.timer invalidate];
        HRBindBankViewController *bankVC = [HRBindBankViewController controllerFromXib];
        bankVC.from = @"注册成功";
        [weakSelf.navigationController pushViewController:bankVC animated:YES];
//        [self toHome];// 跳转逻辑更改
    }];
    
    //启动定时器
    self.timer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(handleTimer) repeats:YES];
    self.count = 3;
}

- (void)handleTimer {
    self.restLabel.text = [NSString stringWithFormat:@"%zd秒后自动返回",self.count];
    self.restLabel.textAlignment = NSTextAlignmentCenter;
    self.restLabel.font = [UIFont systemFontOfSize:15];
    self.restLabel.textColor = [UIColor lightGrayColor];
    
    self.count--;
    if (self.count == 0 && isTapped == NO) {
        [self.timer invalidate];
        //如果没有点击moreBtn,则跳转至首页
//        HRBindBankViewController *bankVC = [HRBindBankViewController controllerFromXib];
//        bankVC.from = @"注册成功";
//        [self.navigationController pushViewController:bankVC animated:YES];
        
        [self toHome];// 跳转逻辑更改
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
