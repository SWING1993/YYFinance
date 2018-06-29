//
//  QTInvestRecordDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 15/8/5.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestRecordDetailViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTRecordDetailCell.h"
#import "QTInvestDetailViewController.h"
#import "QTBookViewController.h"
#import "HRYHTWebViewController.h"


@interface QTInvestRecordDetailViewController ()

@property (strong, nonatomic) IBOutlet UIControl    *shead;
@property (strong, nonatomic) IBOutlet UILabel      *lbtitle;
@end

@implementation QTInvestRecordDetailViewController
{
    NSDictionary *dataSource;
    NSArray *protocolArray;
}

- (void)viewDidLoad {
    self.titleView.title = @"投资详情";
    self.navigationItem.rightBarButtonItem = nil;
    [super viewDidLoad];
    TABLEReg(QTRecordDetailCell, @"QTRecordDetailCell");
    self.tableView.allowsSelection = NO;
    
    protocolArray = @[@"借款电子协议",@"有余金服服务协议"];
    

//    UIBarButtonItem *baritem = [[UIBarButtonItem alloc]initWithTitle:@"协议书" style:UIBarButtonItemStyleDone target:self action:@selector(loadPdf)];
//
//    self.navigationItem.rightBarButtonItem = baritem;
}

- (void)initUI {
    [self initTable];

    [self firstGetData];
}

- (void)loadPdf {
    [self commonJsonPdf];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section ==0) {
        static NSString     *Identifier = @"QTRecordDetailCell";
        QTRecordDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
        NSDictionary        *dic = self.tableDataArray[indexPath.row][@"plan_info"];
        
        [cell bind:dic];
        return  cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"pro"];
        cell.textLabel.text = protocolArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(APP_WIDTH -100, 7, 80, 30)];
        [btn setTitle:@"点击查看" forState:UIControlStateNormal];
        [QTTheme btnWhiteStyle:btn];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        cell.accessoryView = btn;
        if (indexPath.row == 0) {
            [btn addTapGesture:^{
             [self loadPdf];
        }];
            
        }else{
            [btn addTapGesture:^{
                QTWebViewController *controller = [QTWebViewController controllerFromXib];
                NSString *protocolUrl = [NSString stringWithFormat:@"/account/anewprotocol?borrow_id=%@&tender_id=%@",self.dic[@"borrow_id"],self.tender_id];
                controller.url = WEB_URL(protocolUrl);
                controller.isNeedLogin = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc]init];
    if (section ==0){
        if (self.tableDataArray.count > 0) {
            if ([dataSource.str(@"borrow_type") isEqualToString:@"840"] || [dataSource.str(@"borrow_type") isEqualToString:@"900"] ) {
                title.text = @" 还款计划(预计)";
            } else {
                title.text = @" 还款计划";
            }
        }
    }else{
    
        title.text = @" 协议";
    }
   
    [title sizeToFit];
    title.backgroundColor = Theme.backgroundColor;
    title.height = 30;
    title.width = APP_WIDTH;
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

#pragma  mark - json

- (NSString *)listKey {
    return @"repay_plan_list";
}

- (void)commonJsonPdf {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"tender_id"] = self.tender_id;

    [service post:@"borrow_contractDownloading" data:dic complete:^(NSDictionary *value) {

//        NSLog(@"YHTPDF---%@",value);
        NSString *message = value.str(@"result.messageYun");
        if ([message isEqualToString:@"成功"]) {
            [self hideHUD];
            HRYHTWebViewController *YHTWebView = [HRYHTWebViewController controllerFromXib];
            NSMutableString *__urlStr = [NSMutableString stringWithString:value.str(@"result.url")];
            YHTWebView.url =__urlStr;
            [self.navigationController pushViewController:YHTWebView animated:YES];

        }else if ([message isEqualToString:@"合同不存在"]) {
            NSLog(@"");
            [self commonJsonYHT];
        }
        else{
         [self hideHUD];
        [self showToast:message done:^{
            
        [self toInvest];
            
        }];
        }
           }];
}
-(void)commonJsonYHT{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"borrow_id"] = self.dic[@"borrow_id"];
    dict[@"tender_id"] =self.tender_id;
    [service post:@"borrow_yunHeTong" data:dict complete:^(NSDictionary *value) {
        if (!value) {
            return ;
        }
        NSString *message = value.str(@"messageYun");
        if ([message isEqualToString:@"成功"]) {
            QTWebViewController *webView = [QTWebViewController new];
            NSMutableString *__urlStr = [NSMutableString stringWithString:value.str(@"IOSURL")];
            [__urlStr appendFormat:@"?contractId=%@", value.str(@"contractId")];
            [__urlStr appendFormat:@"&token=%@",value[@"lastToken"]];
            [__urlStr appendFormat:@"&noticeParams=%@",self.tender_id];
            
            webView.url = __urlStr;
            webView.isScale = YES;
            [self.navigationController pushViewController:webView animated:YES];
        }else if (message ){
            [self showToast:message done:^{
                [self toInvestRecord];
            }];
            
        }
        [self hideHUD];
    }];
}


- (void)commonJson {
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"tender_id"] = self.tender_id;

    [service post:@"borrow_tenderdetail" data:dic complete:^(NSDictionary *value) {
        dataSource = value;

        DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];

        grid.backgroundColor = Theme.backgroundColor;
        [grid setColumn:4 height:30];

        [grid addView:self.shead margin:UIEdgeInsetsZero];
        self.shead.backgroundColor = Theme.backgroundColor;
        self.lbtitle.text = self.dic.str(@"borrow_name").add(@"项目详情");

        [self.shead click:^(id value) {
            QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
            controller.borrow_id = self.dic[@"borrow_id"];
            [self.navigationController pushViewController:controller animated:YES];
        }];

        NSArray *text;

        if ([self.dic.str(@"borrow_name") containsString:@"VIP"]) {
            text = @[@"投资时间", @"年利率", @"收益期限", @"投资金额", @"利息", @"还款方式"];
        } else {
            text = @[@"投资时间", @"年利率", @"收益期限", @"投资金额", @"利息", @"还款方式", @"夺标红包"];
        }

        if ([value.str(@"borrow_type") isEqualToString:@"840"] || [value.str(@"borrow_type") isEqualToString:@"900"] ) {
            text = @[@"投资时间", @"年利率", @"收益期限", @"投资金额", @"利息(预计)", @"还款方式", @"夺标红包"];
        }

        for (int i = 0; i < text.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
            label.text = text[i];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12];
            [grid addView:label];
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
            label2.font = [UIFont systemFontOfSize:12];

            if (i == 0) {
                label2.text = [value.str(@"tender_time") timeValue];
            }

            if (i == 1) {
                label2.text = [NSString stringWithFormat:@"%.2f%%", value.fl(@"tender_apr") + value.fl(@"apr_add")];
            }

            if (i == 2) {
                if ([value.str(@"borrow_type") isEqualToString:@"840"] ||[value.str(@"borrow_type") isEqualToString:@"900"] ) {
                    label2.text = @"≤".add(value[@"interest_period"]).add(@"天");
                } else {
                    label2.text = value.str(@"interest_period").add(@"天");
                }
            }

            if (i == 3) {
                label2.text = [value.str(@"invest_money") moneyFormatShow].add(@"元");
            }

            if (i == 4) {
                label2.text = [value.str(@"invest_interest") moneyFormatShow].add(@"元");
            }

            if (i == 5) {
                label2.text = value.str(@"repay_style");
            }

            if (i == 6) {
                NSString *money1 = value.str(@"sanyang_first");
                NSString *money2 = value.str(@"sanyang_max");
                NSString *money3 = value.str(@"sanyang_last");

                NSString *temp = @"";

                if (![money1 isEqualToString:@"0"]) {
                    temp = [money1 moneyFormatShow].add(@"元");
                }

                if (![money2 isEqualToString:@"0"]) {
                    temp = temp.add(@" ").add([money2 moneyFormatShow].add(@"元"));
                }

                if (![money3 isEqualToString:@"0"]) {
                    temp = temp.add(@" ").add([money3 moneyFormatShow].add(@"元"));
                }

                if ([temp isEqualToString:@""]) {
                    temp = @"- -";
                }

                label2.text = temp;
            }
            
            [grid addView:label2 crossColumn:3];
            label2.textColor = [UIColor colorHex:@"FF4304"];
            label2.textAlignment = NSTextAlignmentRight;
            
        }
        
        

        self.tableView.tableHeaderView = grid;
        
        UIView *bottomView = [[UIView alloc]initWidth:APP_WIDTH Height:100];
        bottomView.backgroundColor = Theme.backgroundColor;
        UILabel  *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, APP_WIDTH, 40)];
        bottomLabel.backgroundColor = [UIColor whiteColor];
        bottomLabel.text = @"理财有风险,投资需谨慎";
        bottomLabel.font = [UIFont systemFontOfSize:14];
        bottomLabel.textColor = [UIColor colorHex:@"FF4304"];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:bottomLabel];
        self.tableView.tableFooterView = bottomView;

        if (value.i(@"real_state") == 4) {
            self.navigationItem.rightBarButtonItem = nil;
        }

        [self hideHUD];
        [self tableHandleValue:value];
    }];
}

@end
