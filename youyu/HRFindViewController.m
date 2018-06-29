//
//  HRFindViewController.m
//  hr
//
//  Created by 赵 on 01/06/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRFindViewController.h"
#import "HRNoticePageViewController.h"

@interface HRFindViewController ()

@end


@implementation HRFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"findView"];

    HRNoticePageViewController *controller = [HRNoticePageViewController controllerFromXib];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];

}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"findView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
