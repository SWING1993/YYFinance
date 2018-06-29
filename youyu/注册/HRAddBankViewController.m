//
//  HRAddBankViewController.m
//  hr
//
//  Created by 慧融 on 30/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "HRAddBankViewController.h"

@interface HRAddBankViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *tintLabel;

@property (strong, nonatomic) WTReTextField *tfBankCard;

@end

@implementation HRAddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.title = @"添加银行卡";
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI{
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];
    [grid addView:self.headImage margin:UIEdgeInsetsMake(0, -20, 30, -20)];
    
    UILabel *title = [UILabel new];
    title.origin =CGPointMake(20, self.headImage.origin.y);
    title.size = CGSizeMake(APP_WIDTH/2, self.headImage.frame.size.height);
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.numberOfLines = 0;
    NSInteger register_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"register_total"];
    NSString *investTotalStr = [NSString stringWithFormat:@"在有余金服\n%ld人\n与您一起放心理财",register_total];
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:investTotalStr];
    for (int i = 0; i<= investTotalStr.length; i++) {
        NSString *a = [investTotalStr substringWithRange:NSMakeRange(i, 1)];
        if ([NSString isPureInt:a]) {
            [strAttr setAttributes:@{NSForegroundColorAttributeName:MainColor,NSFontAttributeName: [UIFont systemFontOfSize:30]} range:NSMakeRange(i, 1)];
        }
    }
    title.attributedText = strAttr;
    [self.headImage addSubview:title];
    
    self.tfBankCard = [grid addRowInputWithplaceholderRoundRect:@"请输入银行卡号"];
    
    [grid addLineForHeight:92.5];
    [grid addSubmitButtonTitle:@"提交" click:^(id value) {
        NSLog(@"认证---");
        [self nextClick];

    }];
    [grid addView:self.tintLabel margin:UIEdgeInsetsMake(4.5, 0, 0, 0)];
    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];
    
}

- (void)initData{
    
    [self.tfBankCard setBankCard];
    self.tfBankCard.group = 0;
}

#pragma  mark - event
- (void)nextClick {
    
    
    if (![self.view validation:0]) {
        return;
    }
    
    [self commonJson];
}

#pragma  mark - json
- (void)commonJson {
    [self showHUD:@"正在提交..."];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"real_name"] = [GVUserDefaults shareInstance].realname;
    dic[@"card_id"] = [[GVUserDefaults shareInstance].card_id enValue];
    dic[@"bank_account"] = self.tfBankCard.text;
    
    dic[@"type"] = @"1";
    [service post:@"bank_binding" data:dic complete:^(NSDictionary *value) {
        NSString *msg = value.str(@"message");
        NSString *status = value.str(@"status");
        [self hideHUD];
        if ([status isEqualToString:@"2"]) {
            
            [self showToast:msg duration:2];
        }else{
            [MobClick event:@"BindBankCardBt"];
            NOTICE_POST(NOTICEBANK);
            [self.navigationController popViewControllerAnimated:YES];
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
