//
//  QTCommentViewController.m
//  qtyd
//
//  Created by stephendsw on 16/3/22.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTCommentViewController.h"
#import "QTCommentView.h"

@interface QTCommentViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView               *tfView;
@property (weak, nonatomic) IBOutlet PlaceholderTextView    *tfContent;
@end

@implementation QTCommentViewController
{
    QTCommentView *item1;

    QTCommentView *item2;

    QTCommentView *item3;

    UILabel *lbTip;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"商品评价";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    [self initScrollView];

    DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];

    item1 = [QTCommentView viewNib];
    item1.title = @"\n客服服务\n";
    [stack addView:item1];

    item2 = [QTCommentView viewNib];
    item2.title = @"\n礼品质量\n";
    [stack addView:item2];

    item3 = [QTCommentView viewNib];
    item3.title = @"\n物流服务\n";
    [stack addView:item3];

    self.tfContent.limitNum = 150;
    [stack addView:self.tfView];
    self.tfContent.delegate = self;
    self.tfContent.placeholder = @"对客服的服务不满意?对礼品的质量不满意?对物流不满意?都可以使劲吐槽,小祺都会认真的记下哦,认真填写将获得1-50积分";

    lbTip = [[UILabel alloc]init];
    lbTip.font = [UIFont systemFontOfSize:12];
    lbTip.textColor = [UIColor lightGrayColor];
    lbTip.textAlignment = NSTextAlignmentRight;
    lbTip.text = @"您还可输入135字";
    [stack addView:lbTip margin:UIEdgeInsetsMake(8, 8, 8, 8)];

    [stack addRowButtonTitle:@"提交评价" click:^(id value) {
        if ([NSString isEmpty:self.tfContent.text]) {
            [self showToast:@"请输入评价内容"];
        } else {
            [self commonJson];
        }
    }];

    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
}

- (void)initData {
    self.isLockPage = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 135) {
        textView.text = [textView.text substringToIndex:135];
    }

    lbTip.text = [NSString stringWithFormat:@"您还可输入%@字", @(135 - self.tfContent.text.length)];

    if (self.tfContent.text.length >= self.tfContent.limitNum) {
        lbTip.text = [NSString stringWithFormat:@"您还可输入0字"];
    }
}

#pragma mark - json
- (void)commonJson {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"order_no"] = self.orderID;
    dic[@"service_star"] = item1.value;
    dic[@"goods_star"] = item2.value;
    dic[@"pay_star"] = item3.value;
    dic[@"comment"] = self.tfContent.text;

    [service post:@"pgoods_comment" data:dic complete:^(NSDictionary *value) {
        [self hideHUD];
        NOTICE_POST(NOTICEORDER);

        DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"" message:@"评价成功"];

        [alert addActionWithTitle:@"继续兑换" handler:^(CKAlertAction *action) {
            [self toMallHome];
        }];

        [alert addActionWithTitle:@"立即投资" handler:^(CKAlertAction *action) {
            [self toInvest];
        }];

        [alert show];
    }];
}

@end
