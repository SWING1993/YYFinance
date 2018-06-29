//
//  HRLoginViewController.m
//  hr
//
//  Created by 慧融 on 19/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRLoginViewController.h"
#import "HRLoginPwdViewController.h"
#import "HRRegisterViewController.h"
#import "UILabel+preview.h"
#import "HSDRegisterTwoController.h"

static NSString *logRegTitle = @"登录/注册";

@interface HRLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) WTReTextField *tfPhone;
@property (strong, nonatomic) IBOutlet UILabel *NewUserRewardLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvestTotalUsersLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation HRLoginViewController{

    UILabel *label;
    NSString *preText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"填写手机号";
    self.navigationItem.rightBarButtonItem = nil;
    self.tfPhone.delegate = self;
    [self.tfPhone addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    label = [UILabel labelContentPreView:self.tfPhone ];
    
    // Do any additional setup after loading the view from its nib.
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head-logo"]];
    }
    return _imageView;
}

- (void)initUI{
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    [grid addView:self.imageView margin:UIEdgeInsetsMake(50, (APP_WIDTH - 250)/2.0, 30, (APP_WIDTH - 250)/2.0)];
    
//    NSInteger register_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"register_total"];
//    NSString *investTotalStr = [NSString stringWithFormat:@"现在已有%ld人与您一起放心理财",register_total];
//    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:investTotalStr];
//    for (int i = 0; i<= investTotalStr.length; i++) {
//        NSString *a = [investTotalStr substringWithRange:NSMakeRange(i, 1)];
//        if ([NSString isPureInt:a]) {
//            [strAttr setAttributes:@{NSForegroundColorAttributeName:MainColor} range:NSMakeRange(i, 1)];
//        }
//    }
//    self.InvestTotalUsersLabel.attributedText = strAttr;
//    [grid addView:self.InvestTotalUsersLabel margin:UIEdgeInsetsMake(0, 0, 58, 0)];
    

    self.tfPhone = [grid addRowInputWithplaceholder:@"请输入手机号"];
    [self.tfPhone setLeftImage:@"icon_login_name"];
    
    [grid addLineForHeight:60];
    
    [grid addSubmitButtonTitle:@"登录/注册" click:^(id value) {
//                NSString *type = @"1" ;
//                if ([type isEqualToString:@"0"]) {
//                    HRLoginPwdViewController *controller = [HRLoginPwdViewController controllerFromXib];
//                    controller.phone = self.tfPhone.text;
//                    controller.isBackToSecondPage = YES;
//                    [self.navigationController pushViewController:controller animated:YES];
//        
//                }else{
//        
//                    HRRegisterViewController *controller = [HRRegisterViewController controllerFromXib];
//                    controller.phone = self.tfPhone.text;
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
        [self clickSubmit];
    }];
    [grid addLineForHeight:7.5];
    [grid addView:self.NewUserRewardLabel margin:UIEdgeInsetsZero];
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
    
}

- (void)initData{

    [self.tfPhone setPhone];
    self.tfPhone.group = 0;
}

- (void)textFieldEditingChanged:(UITextField*)textField{
    label.text = [NSString phoneFormat:textField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    label.text = [NSString phoneFormat:textField.text];
    [self.scrollview addSubview:label];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [label removeFromSuperview];
}

#pragma  mark - event
- (void)clickSubmit {
    [self.view endEditing:YES];
    
    if (![self.view validation:0]) {
        return;
    }
    
    [self commonJson];
}

#pragma  mark - json

- (void)commonJson {
    [self showHUD];
//    [GVUserDefaults shareInstance].isLogin = NO;
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = self.tfPhone.text;
    [service post:@"user_exists" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        NSString *type = value.str(@"exists_value") ;
        if ([type isEqualToString:@"1"]) {
            HRLoginPwdViewController *controller = [HRLoginPwdViewController controllerFromXib];
            controller.phone = self.tfPhone.text;
            controller.isBackToSecondPage = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
//            HRRegisterViewController *controller = [HRRegisterViewController controllerFromXib];
//            controller.phone = self.tfPhone.text;
            HSDRegisterTwoController *controller = [HSDRegisterTwoController controllerFromXib];
            controller.phone = self.tfPhone.text;
            [self.navigationController pushViewController:controller animated:YES];
        }

    }];
    

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
