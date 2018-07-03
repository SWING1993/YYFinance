//
//  YYIndexViewController.m
//  youyu
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYIndexViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "HSDSafeViewController.h"
#import "YYMediaController.h"
#import "YYMessageController.h"
#import "YYBorrowModel.h"
#import "YYIndexCell.h"
#import "QTInvestDetailViewController.h"

#define NAVBAR_CHANGE_POINT 50

@interface YYIndexViewController ()<SDCycleScrollViewDelegate,QMUITableViewDelegate,QMUITableViewDataSource>

@property(nonatomic, strong) SDCycleScrollView *banner;
@property(nonatomic, strong) QMUITableView *tableView;
@property(nonatomic, copy) NSArray *dataSource;
@property(nonatomic, copy) NSArray<NSDictionary*> *bannerObjcs;
@property(nonatomic, strong) QMUIButton *messageBtn;
@property(nonatomic, assign) NSInteger unread_messes;
@end

@implementation YYIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dataSource.count<= 0) {
        [self startApi];
    }
}

- (void)initSubviews {
    [super initSubviews];
    self.titleView.title = @"有余金服";
    self.titleView.alpha = 0;
    [self initTableView];
    self.messageBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    [self.messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self setMessageBtnImageWhitAlpha:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageBtn];
}

- (void)initTableView {
    self.tableView = [[QMUITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = [YYIndexCell rowHeight];
    self.tableView.showsVerticalScrollIndicator = NO;
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(startApi)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    self.tableView.backgroundColor = kColorBackGround;
    [self.tableView registerClass:[YYIndexCell class] forCellReuseIdentifier:[YYIndexCell cellIdentifier]];

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleFrom_iPhone6_Desgin(307.5))];
    tableHeaderView.backgroundColor = kColorWhite;
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW,kScaleFrom_iPhone6_Desgin(225)) delegate:self placeholderImage:kPlaceholderImage];
    self.banner = banner;
    [tableHeaderView addSubview:banner];
    
    // HeaderView
    QMUIGridView *gridView = [[QMUIGridView alloc] init];
    gridView.frame = CGRectMake(0, kScaleFrom_iPhone6_Desgin(225), kScreenW, kScaleFrom_iPhone6_Desgin(82.5));
    gridView.columnCount = 4;
    gridView.rowHeight = kGetViewHeight(gridView);
    gridView.separatorDashed = NO;
    
    NSArray *btnTitles = @[@"新手福利",@"邀请有奖",@"在线客服",@"了解平台"];
    for (NSInteger i = 0; i < btnTitles.count; i++) {
        QMUIButton *btn = [[QMUIButton alloc] init];
        btn.imagePosition = QMUIButtonImagePositionTop;// 将图片位置改为在文字上方
        btn.spacingBetweenImageAndTitle = 8;
        NSString *imageName = [NSString stringWithFormat:@"home_index_%zi",i];
        [btn setImage:UIImageMake(imageName) forState:UIControlStateNormal];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:kColorTextGray forState:UIControlStateNormal];
        btn.tag = i;
        btn.titleLabel.font = UIFontMake(12);
        btn.qmui_borderPosition = QMUIBorderViewPositionTop | QMUIBorderViewPositionBottom;
        [btn addTarget:self action:@selector(clickedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [gridView addSubview:btn];
    }
    [tableHeaderView addSubview:gridView];
    
    self.tableView.tableHeaderView = tableHeaderView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kNaviHeigh);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)startApi {
    @weakify(self);
    YYRequestApi *api = [[YYRequestApi alloc] initWithPostTaskUrl:@"apphome_info2" requestArgument:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        //获取已注册人数
        [[NSUserDefaults standardUserDefaults] setInteger:resultDict.content.i(@"register_total") forKey:@"register_total"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (resultDict.code == 100000) {
            self.unread_messes = [resultDict.content[@"unread_messes"] integerValue];
            [self setMessageBtnImageWhitAlpha:0];
            NSArray *borrow_list = resultDict.content[@"borrows_list"];
            self.dataSource = [[borrow_list.rac_sequence map:^id _Nullable(id  _Nullable value) {
                return [YYBorrowModel mj_objectWithKeyValues:value];
            }] array];
            self.bannerObjcs = resultDict.content[@"pic_list"];
            self.banner.imageURLStringsGroup = [[self.bannerObjcs.rac_sequence map:^id _Nullable(NSDictionary * _Nullable value) {
                return value[@"url"];
            }] array];
            [self initTableViewFooterWithFooterObjcs:resultDict.content[@"pic_fooler_list"]];
            [self.tableView reloadData];
        } else {
            [resultDict handleError];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSDictionary *resultDict = (NSDictionary *)request.responseObject;
        [resultDict handleError];
    }];
}

#pragma mark tableview footer
- (void)initTableViewFooterWithFooterObjcs:(NSArray <NSDictionary*>*)footerObjcs {
    if (footerObjcs.count <= 0) {
        return;
    }
    // FooterView
    CGFloat footerScrHeight = kScaleFrom_iPhone6_Desgin(132);
    CGFloat footerScrWidth = kScaleFrom_iPhone6_Desgin(225);
    CGFloat footerTagHeight = kScaleFrom_iPhone6_Desgin(57);
    
    UIScrollView *footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, footerScrHeight)];
    footerScrollView.contentSize = CGSizeMake(footerScrWidth*footerObjcs.count, footerScrHeight);
    footerScrollView.directionalLockEnabled = YES;
    footerScrollView.showsHorizontalScrollIndicator = NO;
 
    for (NSInteger i = 0; i < footerObjcs.count; i++) {
        NSDictionary *footerObjc = footerObjcs[i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(footerScrWidth*i, 0, footerScrWidth, footerScrHeight)];
        UIImageView *contentView = [[UIImageView alloc] init];
        contentView.userInteractionEnabled = YES;
        contentView.contentMode = UIViewContentModeScaleAspectFill;
        contentView.clipsToBounds = YES;
        [contentView sd_setImageWithURL:YYURLWithStr(footerObjc[@"url"]) placeholderImage:kPlaceholderImage];
        [view addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-15);
        }];
        [footerScrollView addSubview:view];
        @weakify(self)
        [contentView bk_whenTapped:^{
            @strongify(self)
            [self webViewActionWithHref:footerObjc[@"href"]];
        }];
    }
    
    UIImageView *footerTagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, footerScrHeight, kScreenW, footerTagHeight)];
    footerTagView.image = UIImageMake(@"home_bottom_tag");
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, footerScrHeight + footerTagHeight)];
    footerView.backgroundColor = kColorWhite;
    [footerView addSubview:footerScrollView];
    [footerView addSubview:footerTagView];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark Btns

- (void)webViewActionWithHref:(NSString *)href {
    if (!href.isEmptyString) {
        QTWebViewController *webVC = [[QTWebViewController alloc] init];
        webVC.url = [href hasPrefix:@"http"] ? href : WEB_URL(href);
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)messageAction {
    YYMessageController *controller = [[YYMessageController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickedIndex:(UIButton *)btn {
    switch (btn.tag) {
        case 0:{
            [self webViewActionWithHref:WEB_URL(@"/finance/new_welfare")];
        }
            break;
            
        case 1:{
            QTWebViewController *webVC = [[QTWebViewController alloc] init];
            webVC.url = WEB_URL(@"/user_center/invite");
            webVC.isNeedLogin = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            
        case 2:{
            // 客服
            HChatClient *client = [HChatClient sharedClient];
            if (client.isLoggedInBefore != YES) {
                HError *error = [client loginWithUsername:kHelpDeskUserName password:kHelpDeskPassword];
                if (!error) { //登录成功
                } else { //登录失败
                    return;
                }
            }
            // 进入会话页面
            HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:kHelpDeskConversationChatter];
            // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
            break;
            
        case 3:{
            YYMediaController *vc = [[YYMediaController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark SDCycleScrollView
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *bannerObjc = self.bannerObjcs[index];
    NSString *href = bannerObjc[@"href"];
    [self webViewActionWithHref:href];
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:[YYIndexCell cellIdentifier]];
    if (!cell) {
        cell = [[YYIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[YYIndexCell cellIdentifier]];
    }
    [cell configCellWithModel:self.dataSource[indexPath.section]];
    cell.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    @weakify(self)
    [cell.delegateSignal subscribeNext:^(YYBorrowModel * model) {
        @strongify(self)
        NSLog(@"点击了通知按钮");
        QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
        controller.borrow_id = model.id;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataSource.count - 1 ? 10.0f : CGFLOAT_MIN;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = kColorWhite;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + kNaviHeigh - offsetY) / kNaviHeigh));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.titleView.alpha = alpha;
        [self setMessageBtnImageWhitAlpha:alpha];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.titleView.alpha = 0;
        [self setMessageBtnImageWhitAlpha:0];
    }
}

- (void)setMessageBtnImageWhitAlpha:(CGFloat)alpha {
    if (alpha > 0.5) {
        [self.messageBtn setImage:self.unread_messes > 0 ? UIImageMake(@"nav_btn_new_message") : UIImageMake(@"nav_btn_message") forState:UIControlStateNormal];
    } else {
        [self.messageBtn setImage:self.unread_messes > 0 ? UIImageMake(@"nav_btn_white_new_message") : UIImageMake(@"nav_btn_white_message") forState:UIControlStateNormal];
    }
}

#pragma mark - QMUINavigationControllerDelegate

- (UIImage *)navigationBarBackgroundImage {
    return [UIImage new];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [UIImage new];
}

@end
