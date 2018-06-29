//
//  QTSelectRedPacketViewController.m
//  qtyd
//
//  Created by stephendsw on 16/4/5.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "QTSelectCouponViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTSelectRedPacketCell.h"
#import "QTTicketCell.h"

@interface QTSelectCouponViewController ()

@property (strong, nonatomic) IBOutlet UIView *headview;
@end

@implementation QTSelectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TABLEReg(QTSelectRedPacketCell, @"QTSelectRedPacketCell");
    TABLEReg(QTTicketCell, @"ticketcell");
    self.navigationItem.rightBarButtonItem = nil;
    self.titleView.title = @"选择优惠券";
}

- (void)initUI {
    self.canRefresh = NO;
    [self initTable];

    [self addHeadView:self.headview];
    self.headview.width = APP_WIDTH;
    [self.headview setBottomLine:[Theme borderColor]];
}

- (void)initData {
    [self commonJson];
}

- (IBAction)click:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectCoupon:)]) {
        [self.delegate didselectCoupon:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.tableDataArray[indexPath.row];

    if ([data containsKey:@"reward_info"]) {
        static NSString *Identifier = @"QTSelectRedPacketCell";

        QTSelectRedPacketCell   *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        NSMutableDictionary     *obj = [[NSMutableDictionary alloc]initWithDictionary:self.tableDataArray[indexPath.row] [@"reward_info"]];

        cell.money = self.money;
        [cell bind:obj];
        return cell;
    } else {
        static NSString *Identifier = @"ticketcell";
        QTTicketCell    *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

        NSDictionary *dic = self.tableDataArray[indexPath.row][@"user_coupon_info"];

        cell.money = self.money;
        [cell bindSelect:dic];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellH > 0) {
        return self.cellH;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.tableDataArray[indexPath.row];

    if ([data containsKey:@"reward_info"]) {
        NSMutableDictionary *obj = data[@"reward_info"];

        NSInteger limitMoney = obj.i(@"tender_money");

        if ([self.money floatValue] + obj.i(@"money") < limitMoney) {
            [self showToast:@"投资额不足"];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didselectCoupon:)]) {
                [self.delegate didselectCoupon:data];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } else {
        NSMutableDictionary *obj = data[@"user_coupon_info"];
        NSInteger limitMoney = obj.i(@"tender_money");
        if (([self.money floatValue] > limitMoney) && (limitMoney != 0)) {
            [self showToast:@"投资额超出限额"];
        } else if(obj[@"money_minimun_limit"] > 0 && [self.money floatValue] < [obj[@"money_minimun_limit"] floatValue]){
            [self showToast:@"投资额不足"];
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didselectCoupon:)]) {
                [self.delegate didselectCoupon:data];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

#pragma  mark - emptydelegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"\n\n无可用优惠券!!!";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];

    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - json

- (NSString *)listKey {
    return @"coupon_list";
}

- (void)commonJson {
    NSLog(@"%@",self.value);
    [self tableHandleValueNotHub:self.value];
}

@end
