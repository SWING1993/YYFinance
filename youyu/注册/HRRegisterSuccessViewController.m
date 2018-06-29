//
//  HRRegisterSuccessViewController.m
//  hr
//
//  Created by 慧融 on 21/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRRegisterSuccessViewController.h"
#import "QTMyTicketViewController.h"
#import "HRBindBankViewController.h"
#import "DAlertViewController+attributeString.h"

@interface HRRegisterSuccessViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *rewardTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UIButton *investBt;
@property (weak, nonatomic) IBOutlet UIButton *myRewardBt;

@end

@implementation HRRegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString *messageStrAttr = [[NSMutableAttributedString alloc] initWithString:@"是否一分钟完成个人信息?\n(未完善个人信息无法进行投资)"];
    [messageStrAttr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorHex:@"222222"]} range:NSMakeRange(0, 13)];
    [messageStrAttr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorHex:@"999999"]} range:NSMakeRange(13, 15)];
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc]initWithString:@" "];
    DAlertViewController *alertVC = [DAlertViewController alertControllerWithAttributeTitle:titleAttr message:messageStrAttr];
    [alertVC addActionWithTitle:@"去首页" handler:^(CKAlertAction *action) {
        [self toHome];
    }];
    
    [alertVC addActionWithTitle:@"继续认证" handler:^(CKAlertAction *action) {
        // 跳转到实名认证
        HRBindBankViewController *controller =[HRBindBankViewController controllerFromXib];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [alertVC show];
    [alertVC addHideGesture];
    [alertVC setButtonTitleColor];
    

    // Do any additional setup after loading the view from its nib.
}
- (void)initUI{
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(gotoHome)];
    self.navigationItem.rightBarButtonItem = rightBar;
    NSMutableAttributedString *strAtr = [[NSMutableAttributedString alloc]initWithString:self.rewardTitleLabel.text];
    [strAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(5, 4)];
    [strAtr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 4)];
    self.rewardTitleLabel.attributedText = strAtr;
    self.investBt.layer.cornerRadius = 7.0f;
    self.myRewardBt.layer.cornerRadius = 7.0f;
    [self.myRewardBt addTapGesture:^{
        [self toMyTicket:1];
    }];
    
}

- (void)gotoHome{

    [self toHome];
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
