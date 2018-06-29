//
//  QTFriendViewController.m
//  qtyd
//
//  Created by stephendsw on 15/8/3.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTFriendViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTFriendCell.h"
#import "UIViewController+Share.h"

@interface QTFriendViewController ()

@property (strong, nonatomic) IBOutlet UIView *headview;

@property (strong, nonatomic) IBOutlet UIView   *theadview;
@property (strong, nonatomic) IBOutlet UIView   *secondview;
@property (weak, nonatomic) IBOutlet UILabel    *lbmoney;
@property (weak, nonatomic) IBOutlet UILabel    *lbnum;
@property (strong, nonatomic) IBOutlet UIView   *contentView;

@property (strong, nonatomic) IBOutlet UIImageView  *image;
@property (weak, nonatomic) IBOutlet UILabel        *lbTip;

@property (strong, nonatomic) IBOutlet UILabel *lburl;
@end

@implementation QTFriendViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"邀请有礼";
    [super viewDidLoad];

    TABLEReg(QTFriendCell, @"QTFriendCell");
}

- (void)initUI {
    if (self.type == 1) {
        [self initTable];
        self.tableView.tableHeaderView = self.headview;
    } else {
        [self initScrollView];

        DStackView *stack = [[DStackView alloc]initWidth:APP_WIDTH];
        self.contentView.backgroundColor = Theme.backgroundColor;
        [stack addView:self.headview];
        [stack addView:self.contentView];

        [stack addView:self.lbTip margin:UIEdgeInsetsMake(10, 16, 20, 16)];

        [self.scrollview addSubview:stack];
        [self.scrollview autoContentSize];
    }

    self.headview.backgroundColor = Theme.backgroundColor;
}

- (void)initData {
    self.isLockPage = YES;
    self.lburl.text = WEB_URL(@"/phone/user/reg/").add([GVUserDefaults  shareInstance].card_type);
    self.image.image = [DCodeGenerator qrImageForString:self.lburl.text imageSize:200];

    NSMutableAttributedString *attsrt = [[NSMutableAttributedString alloc]initWithString:@"邀请规则：\n1、活动时间：2016年9月1日—2016年12月31日，排行榜每月为一轮；\n2、邀请人数越多奖励越大，邀请好友累计投资额越高奖励越大，详情见活动规则；\n3、红包券有效期15天，红包有效期1个月；\n4、邀请好友注册并实名认证得200积分（最多领取4000积分），好友首次投资再得 500积分（最多领取10000积分）。"];

    [attsrt setFont:[UIFont systemFontOfSize:12]];
    [attsrt setFont:[UIFont systemFontOfSize:14] string:@"温馨提示"];
    [attsrt setParagraphStyle:^(NSMutableParagraphStyle *Paragraph) {
        Paragraph.lineSpacing = 8;
    }];

    self.lbTip.attributedText = attsrt;

    [self commonJsonData];

    if (self.type == 1) {
        [self tableRrefresh];
    }
}

- (IBAction)shareClick:(id)sender {
    ShareModel *dic = [ShareModel new];

    dic.title = @"快来抢祺天优贷红包，注册立送588元！";
    dic.content = @"我向你推荐祺天优贷，100元起投，12-15%的收益率，赛过股市，安全透明！点击理财";
    dic.url = self.lburl.text;
    dic.img = @"shareimage";
    [self share:dic];
}

#pragma  mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"QTFriendCell";
    QTFriendCell    *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    NSDictionary    *dic = self.tableDataArray[indexPath.row][@"invite_info"];

    [cell bind:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.theadview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark -json

- (NSString *)listKey {
    return @"invite_list";
}

- (void)commonJson {
    // 好友列表
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"cur_page"] = self.current_page;
    dic[@"page_size"] = pageSize;

    [service post:@"user_invitelist" data:dic complete:^(NSDictionary *value) {
        [self tableHandleValue:value];
    }];
}

- (void)commonJsonData {
    // 邀请数
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [service post:@"user_inviteinfo" data:dic complete:^(NSDictionary *value) {
        self.lbmoney.text = [value.str(@"total_reward") moneyFormatShow];
        self.lbnum.text = value.str(@"user_num");
    }];
}

@end
