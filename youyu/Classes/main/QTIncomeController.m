//
//  QTIncomeController.m
//  qtyd
//
//  Created by yl on 15/10/12.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import "QTIncomeController.h"
#import "WTReTextField.h"
#import "DFormAdd.h"
#import "QTInvestDetailViewController.h"

@interface QTIncomeController ()

/**
 *  投资总额
 */
@property(nonatomic, strong) WTReTextField *vtMoney;

/**
 *  投资期限(整数)
 */
@property(nonatomic, strong) WTReTextField *vtDay;

/**
 *  年化率(不超过36%)
 */
@property(nonatomic, strong) WTReTextField *vtApr;

/**
 *  收益
 */
@property(nonatomic, strong) WTReTextField *vtIncome;

@end

@implementation QTIncomeController
{
    DGridView   *grid;
    UIButton    *btnCalc;
}
- (void)viewDidLoad {
    self.view.width = APP_WIDTH;
//    self.view.width = APP_WIDTH - 40;
    [super viewDidLoad];
    self.title = @"收益计算器";
}

- (void)initUI {
    [self initScrollView];

    grid = [[DGridView alloc]initWidth:self.view.width];

    grid.backgroundColor = Theme.backgroundColor;
    [grid setColumn:16 height:44];

    [grid addLineForHeight:5];
//    关闭按钮
//    UIView *imgView = [UIView new];
//    imgView.width = grid.width;
//    imgView.height = 35;
//
//    UIImageView *img = [[UIImageView alloc]init];
//    img.frame = CGRectMake(grid.width - 35 - 16 - 8, 0, 35, 35);
//    [img setImage:[UIImage imageNamed:@"icon_close"]];
//    img.contentMode = UIViewContentModeScaleAspectFit;
//    img.clipsToBounds = YES;
//    [img setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    [imgView addSubview:img];
//    [imgView addTapGesture:^() {
//        [self.view endEditing:YES];
//        [self hideCustomHUB];
//    }];
//    [grid addView:imgView margin:UIEdgeInsetsMake(0, 0, 0, 0)];

    [grid addLineForHeight:5];

    self.vtApr = [grid addRowInput:@"年化利率" placeholder:@"请输入年化利率" tagText:@"%"];
    self.vtApr.textAlignment = NSTextAlignmentCenter;

    self.vtDay = [grid addRowInput:@"收益期限" placeholder:@"请输入收益期限" tagText:@"天"];
    self.vtDay.textAlignment = NSTextAlignmentCenter;

    self.vtMoney = [grid addRowInput:@"投资金额" placeholder:@"请输入投资金额" tagText:@"元"];
    self.vtMoney.textAlignment = NSTextAlignmentCenter;

    self.vtIncome = [grid addRowInput:@"到期收益" placeholder:@"" tagText:@"元"];
    self.vtIncome.enabled = NO;
    self.vtIncome.textAlignment = NSTextAlignmentCenter;
    self.vtIncome.text = @"0.00";
    self.vtIncome.textColor = Theme.redColor;

    [grid addLineForHeight:20];

    __weak QTIncomeController *weakSelf = self;
    btnCalc = [grid addRowButtonTitle:@"计 算" click:^(id value) {
        [weakSelf onCalc];
    }];

    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"*计算结果仅供参考";
    lb.textColor = Theme.darkGrayColor;
    lb.font = [UIFont systemFontOfSize:12];
    [lb sizeToFit];
    lb.textAlignment = NSTextAlignmentRight;
    [grid addView:lb margin:UIEdgeInsetsMake(10, 16, 0, 16)];

    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:lb.text];
    [astr addAttributes:@{NSForegroundColorAttributeName :Theme.redColor} range:NSMakeRange(0, 1)];

    lb.attributedText = astr;

    [self.scrollview addSubview:grid];
    [self.scrollview autoContentSize];

    for (UIView *item in  grid.allSubviews) {
        if ([item isKindOfClass:[UILabel class]]) {
            ((UILabel *)item).font = [UIFont systemFontOfSize:12];
        }

        if ([item isKindOfClass:[WTReTextField class]]) {
            ((WTReTextField *)item).font = [UIFont systemFontOfSize:12];
        }
    }
}

- (void)initData {
    [self.vtMoney setMoney];

    [self.vtDay setPositiveInteger:3];
    self.vtDay.nilTip = @"请输入收益期限";
    self.vtDay.errorTip = @"请输入有效的收益期限";

    [self.vtApr setMoney];
    self.vtApr.nilTip = @"请输入年化利率";
    self.vtApr.errorTip = @"年化利率必须为数字，小数点后不超过2位";

//    [self.vtMoney addDoneOnKeyboardWithTarget:self action:@selector(onCalc)];

    
    
//    if ([self.navigationController.childViewControllers.lastObject isKindOfClass:[QTInvestDetailViewController class]]) {
//        QTInvestDetailViewController *supercontroller = (QTInvestDetailViewController *)self.navigationController.childViewControllers.lastObject;
//        if (supercontroller.borrowInfo) {
//            self.vtApr.text = [NSString stringWithFormat:@"%.2f", supercontroller.borrowInfo.fl(@"apr_add") + supercontroller.borrowInfo.fl(@"apr")];
//            self.vtDay.text = supercontroller.borrowInfo.str(@"loan_period.num");
//            [self.vtMoney becomeFirstResponder];
//        } else {
//            [self.vtApr becomeFirstResponder];
//        }
//    } else {
//        [self.vtApr becomeFirstResponder];
//    }
}

/**
 *  计算
 */
- (void)onCalc {
    [self.vtMoney resignFirstResponder];

    if (![self.view validation:0]) {
        return;
    }

    float   apr = [self.vtApr.text floatValue];
    float   money = [self.vtMoney.text floatValue];
    float   day = [self.vtDay.text intValue];

    if (apr > 36.0) {
        [self showToast:@"年化利率不能超过36%"];
        return;
    }

    // 收益=利率/360*投资总额*收益期限
    float temp = apr / 360 / 100 * money * day;
    self.vtIncome.text = [NSString stringWithFormat:@"%.2f", temp];
}

//- (void)onClose {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/**
 *  重置
 */
- (void)onClear {
    self.vtApr.text = self.vtDay.text = self.vtMoney.text = @"";
    self.vtIncome.text = @"";
}

@end
