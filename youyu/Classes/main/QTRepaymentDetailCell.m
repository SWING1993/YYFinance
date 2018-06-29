//
//  QTRepaymentDetailCell.m
//  qtyd
//
//  Created by stephendsw on 16/5/9.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTRepaymentDetailCell.h"
#import "QTCirlceView.h"
#import "QTRepaymentDetailRowView.h"
#import "NSString+model.h"

@interface QTRepaymentDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel        *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel        *lbNum;
@property (weak, nonatomic) IBOutlet UILabel        *lbCode;
@property (weak, nonatomic) IBOutlet QTCirlceView   *viewCircle;
@property (weak, nonatomic) IBOutlet UILabel        *lbState;
@property (weak, nonatomic) IBOutlet UIImageView    *image;
@property (weak, nonatomic) IBOutlet UIView         *viewHead;

@end

@implementation QTRepaymentDetailCell
{
    DStackView *stack;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    stack = [[DStackView alloc]initWidth:APP_WIDTH];

    stack.top = self.viewHead.bottom;

    [self.contentView addSubview:stack];

    self.viewCircle.ringWidth = 2;
    self.viewCircle.showInnerRing = YES;

    self.image.image = [[UIImage imageNamed:@"up_03"] imageWithColor:[UIColor grayColor]];
    self.viewHead.width = APP_WIDTH;
    [self.viewHead setBottomLine:[Theme borderColor]];

    self.contentView.backgroundColor = [Theme backgroundColor];

    for (int i = 0; i < 10; i++) {
        QTRepaymentDetailRowView *row = [QTRepaymentDetailRowView viewNib];
        [stack addView:row];
    }

    self.contentView.clipsToBounds = YES;
}

- (void)bind:(NSDictionary *)obj {
    self.lbTitle.text = [obj.str(@"borrow_name") firstBorrowName];
    self.lbNum.text = [NSString stringWithFormat:@"(%ld/%@期)", obj.i(@"total_stage") - obj.i(@"wait_pay_stage"), obj.str(@"total_stage")];
    self.lbCode.text = [NSString stringWithFormat:@"合同编号: %@", obj.str(@"protocol_no")];

    for (int i = 0; i < obj.arr(@"collection_list").count; i++) {
        QTRepaymentDetailRowView *row = (QTRepaymentDetailRowView *)[stack indexForView:i + 1];

        if (!row) {
            QTRepaymentDetailRowView *row = [QTRepaymentDetailRowView viewNib];
            [stack addView:row];
        }

        NSDictionary *item = obj.arr(@"collection_list")[i];
        [row bind:item.dic(@"collection_info")];
    }

    float   total_stage = obj.i(@"total_stage");
    float   wait_pay_stage = obj.i(@"wait_pay_stage");

    if (0 == wait_pay_stage) {
        self.lbState.text = @"已回款";
        self.lbState.textColor = [Theme greenColor];
        self.viewCircle.ringColor = [Theme greenColor];
        self.viewCircle.rate = 1;
    } else if (wait_pay_stage == total_stage) {
        self.lbState.text = @"待还款";
        self.lbState.textColor = [Theme grayColor];
        self.viewCircle.ringColor = [Theme grayColor];
        self.viewCircle.rate = 1;
    } else if (wait_pay_stage > 0) {
        self.lbState.text = @"还款中";
        self.lbState.textColor = [Theme darkOrangeColor];
        self.viewCircle.ringColor = [Theme darkOrangeColor];
        self.viewCircle.rate = (total_stage - wait_pay_stage) / total_stage;
    }
}

@end
