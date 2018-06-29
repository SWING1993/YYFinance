//
//  QTHomeViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/14.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTHomeViewController.h"
#import "QTInvestDetailViewController.h"
#import "QTPayViewController.h"
#import "InvestDetailView.h"
#import "AdView.h"
#import "QTWebViewController.h"
#import "CreditWebViewController.h"
#import "QTHomeCardView.h"
#import "QTBaseViewController+Table.h"
#import "QTInvestCell.h"
#import "HRHomeTableViewCell.h"
//#import "QTOpenSinaViewController.h"
#import "QTWebViewController.h"

#import "QTHomeViewController+Recash.h"
#import "HRLoginViewController.h"
#import "HRRegisterViewController.h"
#import "HRSetPayPwdViewController.h"
#import "HRBindBankViewController.h"
#import "HSDActiveView.h"
#import "NSString+date.h"

#import "HSDHomeNewHandView.h"
#import "HSDInvestmentModel.h"
#import "MJExtension.h"

#import "YYInvestListNarmalTableViewCell.h"
#import "HSDInvestmentModel.h"
#import "GYChangeTextView.h"
#import "YYHomeArticleModel.h"

static CGFloat const margin     = 10;
static CGFloat const activeBtnW = 85;
static CGFloat const activeBtnH = 66;

static CGFloat const oneDayTime = 60 * 60 * 24;

@interface QTHomeViewController ()<UIScrollViewDelegate,GYChangeTextViewDelegate>

//广告位
@property (strong, nonatomic) IBOutlet UIView   *lbTipView;
@property (weak, nonatomic) IBOutlet UIImageView *lbAdImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbAdTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *lbAdTimeLable;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIView *jxView; //精选
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIButton *investBt;
@property (strong, nonatomic) NSArray *iconUrlArray;

@property (nonatomic, strong) HSDHomeNewHandView *myNewHandView;

//活动相关
@property (nonatomic, weak) HSDActiveView *activeView;
@property (nonatomic, strong) NSMutableDictionary *activeDic;

//最下面的累计投资(临时)
@property (strong, nonatomic) IBOutlet UIView *bottom_1View;
@property (weak, nonatomic) IBOutlet UILabel *allInvestLable;

//累计投资label(便于调整居中显示)
@property (strong, nonatomic) UILabel *tableFooterLabel;

//注册人数label(便于调整居中显示)
@property (strong, nonatomic) UILabel *memberLabel;

@property (nonatomic, strong) NSMutableArray *dataArr;



@property (nonatomic, copy) NSString *noobActivity;

@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) NSMutableArray *advertisingArray;
//@property (nonatomic, strong) UILabel *announcementLabel;
//@property (nonatomic, copy) NSString *announcementURL;
//@property (nonatomic, copy) NSString *announcontent;//公告内容
@property (nonatomic, strong) GYChangeTextView *tView;

@end

@implementation QTHomeViewController
{
    AdView *_adView;
    
    UIImageView *lbInsign;
    
    NSArray *dataSource;
    
    UIImageView *imageview;
    
    DWrapView *wrap;
    
    CALayer *lineLayer;
    
    QTWebViewController *projectWebController;
    
    BOOL isFirstRequest;
    
    BOOL isFirstRun;
}

-(NSMutableArray *)advertisingArray{
    if(!_advertisingArray){
        _advertisingArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _advertisingArray;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstRequest = YES;
    
    self.view.backgroundColor = [UIColor colorHex:@"E0E0E0"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstGetData) name:NOTICEHOME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showActiveView) name:@"showHomeActiveView" object:nil];
    self.arr = [NSMutableArray arrayWithCapacity:1];
}

#pragma mark -notification
-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    if (dict.str(@"aps.aps")) {
        QTWebViewController *webController = [[QTWebViewController alloc]init];
        webController.url = dict.str(@"aps.aps");
        webController.isScale = YES;
        webController.isNeedLogin = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}

-(void)showActiveView{
    [self isShowActive];
}

#pragma mark - 广告
-(GYChangeTextView *)tView{
    if(!_tView){
        _tView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(40, 0, APP_WIDTH - 80, 26)];
        _tView.delegate = self;
    }
    return _tView;
}
- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
    YYHomeArticleModel *model = self.advertisingArray[index];
    NSString *url = WEB_URL(@"/article/article_detail_app/news/").add([NSString stringWithFormat:@"%ld",model.article_id]);
    QTWebViewController *webController = [[QTWebViewController alloc]init];
    webController.url = url;
    webController.isScale = YES;
    webController.isNeedLogin = YES;
    [self.navigationController pushViewController:webController animated:YES];
//    if ([model.jumpurl length] > 0) {
//        QTWebViewController *webController = [[QTWebViewController alloc]init];
//        webController.url = url;
//        webController.isScale = YES;
//        webController.isNeedLogin = YES;
//        [self.navigationController pushViewController:webController animated:YES];
//    }else if ([model.content length] > 0){
//        QTWebViewController *webVC = [QTWebViewController controllerFromXib];
////        webVC.htmlContent = model.content;
//        webVC.url = url;
//        webVC.isScale = YES;
//        webVC.isNeedLogin = YES;
//        [self.navigationController pushViewController:webVC animated:YES];
//    }
}

#pragma mark - 公告跳转
//- (void)clickAnnouncement{
//    if ([self.announcementURL length] > 0) {
//        QTWebViewController *webController = [[QTWebViewController alloc]init];
//        webController.url = self.announcementURL;
//        webController.isScale = YES;
//        webController.isNeedLogin = YES;
//        [self.navigationController pushViewController:webController animated:YES];
//    }else if ([self.announcontent length] > 0){
//        QTWebViewController *webVC = [QTWebViewController controllerFromXib];
//        webVC.htmlContent = self.announcontent;
//        [self.navigationController pushViewController:webVC animated:YES];
//    }
//}

- (void)initUI {
    float heightAd = APP_WIDTH / 375 * 200;
    
    //Banner图
    _adView = [[AdView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, heightAd)];
    _adView.placeHoldImage = [UIImage imageNamed:@"mall_default"];
    [_adView setPageControlShowStyle:UIPageControlShowStyleCenter];
    [QTTheme pageControlStyle:_adView.pageControl];
    
    DStackView *stack = [[DStackView  alloc]initWidth:APP_WIDTH];
    [stack addView:_adView];
    
    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    [grid setColumn:16 height:26];
    grid.backgroundColor = Theme.backgroundColor;
    [stack addView:grid];
    
    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 26)];
    [grid addView:gridView margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 16, 16)];
    imgV.image = IMG(@"yy_公告");
    [gridView addSubview:imgV];
    [gridView addSubview:self.tView];
    
    
    
    //邀请好友 精选投资 安全保障 积分商城
    wrap = [[DWrapView alloc]initWidth:APP_WIDTH columns:2];
    wrap.backgroundColor = Theme.backgroundColor;
    wrap.subHeight = 80;
    
    NSArray *textArray = @[@"新手福利", @"更多活动"];
    NSArray *imageArray = @[@"yy_新手福利", @"yy_更多活动"];
    
    NSArray *pages =@[@"toGift",
                      @"toMore",
                      ];
    for (int i = 0; i < textArray.count; i++) {
        QTHomeCardView *item = [[QTHomeCardView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH/2.0, 80)];
        [item setText:textArray[i] img:imageArray[i]];
        [item addTapGesture:^(id value) {
            if (i == 0 ) {
                [self loginedAction:^{
                    if ([self.noobActivity length] > 0) {
                        QTWebViewController *webController = [[QTWebViewController alloc]init];
                        webController.url = self.noobActivity;
                        webController.isScale = YES;
                        webController.isNeedLogin = YES;
                        [self.navigationController pushViewController:webController animated:YES];
                    }else
                        [self performSelector:NSSelectorFromString(pages[i])];
                }];
            } else {
                self.navigationController.tabBarController.selectedIndex = MORE_TAG;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        [wrap addView:item margin:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [stack addView:wrap];
    
    /* 暂时隐藏
     
     //广告位
     [stack addView:self.lbTipView];
     
     self.lbTipView.width = APP_WIDTH;
     [self.lbTipView setTopLine:[Theme borderColor]];
     
     
     */
    [stack addLineForHeight:10 color:[Theme backgroundColor]];
    
    /*
     //精选
     //    self.jxView.width = APP_WIDTH;
     //    [stack addView:self.jxView];
     
     //    lineLayer = [[CALayer alloc]init];
     //    lineLayer.frame = CGRectMake(0, 75 + wrap.top, APP_WIDTH, 20);
     //
     //    [stack addLineForHeight:1 color:[Theme backgroundColor]];
     */
    self.myNewHandView = [HSDHomeNewHandView creatNewHandView];
//    _myNewHandView.layer.contents = (__bridge id _Nullable)(IMG(@"homeTopBgView")).CGImage;
//    _myNewHandView.layer.contentsGravity = kCAGravityResizeAspect;
    UITapGestureRecognizer *toptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopInvest)];
    [self.myNewHandView addGestureRecognizer:toptap];
    [stack addView:self.myNewHandView];
    _myNewHandView.layer.shadowColor = LightGrayColor.CGColor;
    _myNewHandView.layer.shadowOpacity = 0.1;
    _myNewHandView.layer.shadowOffset = CGSizeMake(0, 0);
    [stack addView:self.myNewHandView margin:UIEdgeInsetsMake(0, 10, 5, 10)];
    
    [self initTable];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = stack;
    
    //    self.bottom_1View.width = APP_WIDTH;
    //    self.tableView.tableFooterView = self.bottom_1View;
    //累计投资
    DStackView *bottomStack = [[DStackView  alloc]initWidth:APP_WIDTH];
    [bottomStack addLineForHeight:10 color:[UIColor clearColor]];
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 60)];
    [bottomStack addView:footer];
//    footer.backgroundColor = [UIColor whiteColor];
    UILabel *invsetLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH/2.0, 60)];
    invsetLabel.textAlignment = NSTextAlignmentCenter;
    invsetLabel.font = [UIFont systemFontOfSize:16];
    invsetLabel.numberOfLines = 2;
    invsetLabel.textColor = [UIColor lightGrayColor];
    [footer addSubview:invsetLabel];
    
    UILabel *menberCount = [[UILabel alloc]initWithFrame:CGRectMake(APP_WIDTH/2.0, 0, APP_WIDTH/2.0, 60)];
    menberCount.textAlignment = NSTextAlignmentCenter;
    menberCount.font = [UIFont systemFontOfSize:16];
    menberCount.textColor = [UIColor lightGrayColor];
    menberCount.numberOfLines = 2;
    [footer addSubview:menberCount];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(APP_WIDTH/2.0, 15, 0.5, 30)];
//    line.backgroundColor = LightGrayColor;
//    [footer addSubview:line];
    self.tableView.tableFooterView = bottomStack;
    self.tableFooterLabel = invsetLabel;
    self.memberLabel = menberCount;
    self.tabBarController.edgesForExtendedLayout = UIRectEdgeTop;
    
}

- (void)clickTopInvest{
    QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
    controller.borrow_id = self.myNewHandView.model.typeID;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initData {
    [self firstGetData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"homeView"];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithImage:IMG(@"newTelService_icon") style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    
    self.navigationItem.rightBarButtonItem = itembar;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"homeView"];
    
//    self.tabBarController.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"有余金服";
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithImage:IMG(@"newTelService_icon") style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    
    self.navigationItem.rightBarButtonItem = itembar;

}

- (void)rightClick {
    [self toLoan];
}

// 立即投资按钮
- (void) investBtnClick: (NSDictionary *) dic {
    QTInvestDetailViewController *controller = [QTInvestDetailViewController controllerFromXib];
    
    controller.borrow_id = dic[@"id"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma  mark - table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0) ? 0 : 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (section == self.dataArray.count) ? 0.1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"HRHomeTableViewCell";
    
    YYInvestListNarmalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[YYInvestListNarmalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.normalView.model = self.dataArr[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RSS(135);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ///TODO:业务逻辑调整，此处直接return.
    [MobClick event:@"home_investBt"];
    [self investBtnClick:self.arr[indexPath.section]];
    return;
    
}

- (NSString *)listKey {
    return @"borrows_list";
}


#pragma  mark - json

- (void)puser_insign {
    [self showHUD];
    [service post:@"puser_insign" data:nil complete:^(NSDictionary *value) {
        [self hideHUD];
        [GVUserDefaults  shareInstance].insign_flg = @"1";
        NSString *tip = [NSString stringWithFormat:@"成长值+%@，您连续签到%@天，明日签到即可获得%@", value.str(@"growth_value"), value.str(@"insign_days"), value.str(@"tomorrow_growth")];
        [self showToast:tip duration:3 done:^{
            [self toSignIn];
        }];
    }];
}

- (void)commonJson {
    [service post:@"apphome_info" data:nil complete:^(NSDictionary *value) {
        [super commonJson];
        
        //获取已注册人数
        [[NSUserDefaults standardUserDefaults]setInteger:value.i(@"register_total") forKey:@"register_total"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([value[@"article_list"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:1];
            
            [value[@"article_list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YYHomeArticleModel *model = [YYHomeArticleModel yy_modelWithJSON:obj[@"article_info"]];
                [self.advertisingArray addObject:model];
                [titleArr addObject:model.name];
            }];
            if (titleArr.count > 0) {
                [self.tView animationWithTexts:titleArr];
            }
        }
        if (value[@"new_page"]) {
            self.noobActivity = value[@"new_page"][@"href"];
        }
        
        //累计投资
        NSString *allMoneyStr = [NSString stringWithFormat:@"%ld",(long)value.i(@"tender_total")];
        NSString *showAllMoneyStr = allMoneyStr.add(@"元").add(@"\n累计成交金额");
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:showAllMoneyStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[Theme mainOrangeColor] range:NSMakeRange(0, showAllMoneyStr.length - 6)];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(showAllMoneyStr.length - 6, 6)];
        self.tableFooterLabel.attributedText = attributedStr;
        //注册人数
        NSString *memberCount = [NSString stringWithFormat:@"%ld",(long)value.i(@"register_total")];
        NSString *countStr = memberCount.add(@"人").add(@"\n注册人数");
        //        self.allInvestLable.text = allMoneyStr.add(@"元");
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:countStr];
        [str addAttribute:NSForegroundColorAttributeName value:[Theme mainOrangeColor] range:NSMakeRange(0, countStr.length - 5)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(countStr.length - 5, 5)];
        self.memberLabel.attributedText = str;
        
        
        //热门推荐标
        NSDictionary *dic = [value[@"borrows_list"] firstObject];
        HSDInvestmentModel *model = [HSDInvestmentModel mj_objectWithKeyValues:dic];
        self.myNewHandView.model = model;
        NSArray *data = value[@"borrow_list"];
        [self.dataArr removeAllObjects];
        [self.arr removeAllObjects];
        for (NSDictionary *dic in data) {
            if ([dic[@"borrow_info"][@"new_hand"] isEqualToString:@"2"] && [dic[@"borrow_info"][@"real_state"] isEqualToString:@"2"]) {   //新手标
                model = [HSDInvestmentModel mj_objectWithKeyValues:dic];
                self.myNewHandView.model = model;
            }else{
                if (self.dataArr.count > 1) {
                    break;
                }
                [self.arr addObject:dic];
                HSDInvestmentModel *model = [HSDInvestmentModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
        }
        
        // 轮播
        NSArray *picList = [value.arr(@"pic_list") getArrayForKey:@"url"];
        
        if (picList.count > 0) {
            [_adView setimageLinkURL:picList];
            [QTTheme pageControlStyle:_adView.pageControl];
            [_adView click:^(NSInteger index, NSString *imageURL) {
                NSDictionary *picInfo = (NSDictionary *)value.arr(@"pic_list")[index];
                NSString *href = picInfo.str(@"href");
                NSString *shareContent = picInfo.str(@"remind_name");
                if ([href containsString:@"duiba"]) {
                    [self loginedAction:^{
                        NSMutableDictionary *dicPara = [NSMutableDictionary new];
                        dicPara[@"device_port"] = @"ios";
                        dicPara[@"redis_key"] = [GVUserDefaults  shareInstance].redis_key;
                        CreditWebViewController *controller = [[CreditWebViewController alloc]initWithUrl:[href urlAddParameter:dicPara]];
                        [self.navigationController pushViewController:controller animated:YES];
                    }];
                } else if (href.length > 0) {
                    QTWebViewController *webController = [[QTWebViewController alloc]init];
                    webController.url = href;
                    webController.isScale = YES;
                    webController.isNeedLogin = YES;
                    webController.showShareBtn = [href containsString:@"SharingActivities"];
                    webController.shareContent = shareContent;
                    [self.navigationController pushViewController:webController animated:YES];
                }
            }];
            
        }
        
        // 图标
        NSArray *iconPicList = [value.arr(@"iconset_list") getArrayForKey:@"icon_url"];
        NSArray *iconName = [value.arr(@"iconset_list")getArrayForKey:@"name"];
        NSArray *iconUrl = [value.arr(@"iconset_list")getArrayForKey:@"direct_url"];
        self.iconUrlArray = [iconUrl copy];
        
        if (iconPicList.count >= 2) {
            for (int i = 0; i < iconPicList.count; i++) {
                if (i == 4) {
                    [lineLayer imageWithURLString:iconPicList[4]];
                } else if (i < 4) {
                    [((QTHomeCardView *)wrap.subviews[i]).image setImageWithURLString:iconPicList[i]];
                    ((QTHomeCardView *)wrap.subviews[i]).lbTitle.text = iconName[i];
                    [((QTHomeCardView *)wrap.subviews[i]) addTapGesture:^{
                        QTWebViewController *webController = [[QTWebViewController alloc]init];
                        webController.url = iconUrl[i];
                        webController.isScale = YES;
                        webController.isNeedLogin = YES;
                        [self.navigationController pushViewController:webController animated:YES];
                    }];
                }
            }
        } else {
#pragma mark - 此处再修改一次(首页四个按钮)！！！
            NSArray *imageArray = @[@"yy_新手福利", @"yy_更多活动"];
            lineLayer.contents = nil;
            
            for (int i = 0; i < 2; i++) {
                ((QTHomeCardView *)wrap.subviews[i]).image.image = [UIImage imageNamed:imageArray[i]];
            }
        }
        [self tableHandleValue:value];
        
        [self hideHUD];
        isFirstRequest = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirst"];
        [self.tableView reloadData];
    }];
}

#pragma mark -双11活动
// 是否在指定的时间段内
-(void)isShowActive{
    
    CGFloat start = [self.activeDic[@"startTime"] floatValue];
    CGFloat end = [self.activeDic[@"endTime"] floatValue];
    NSString *endTime1 = [NSString stringWithFormat:@"%.0f",start +  oneDayTime * 3];
    NSString *startTime2 = [NSString stringWithFormat:@"%.0f",end - oneDayTime * 2];
    
    BOOL isIndate1 = [NSString validateWithStartTime:self.activeDic[@"startTime"] withExpireTime:endTime1];
    BOOL isIndate2 = [NSString validateWithStartTime:startTime2 withExpireTime:self.activeDic[@"endTime"]];
    
    if (isIndate1 || isIndate2) {
        [self initActiceView];
    }else{
        return;
    }
}

// 加载活动View
-(void)initActiceView{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.activeView = [HSDActiveView creatActiveView];
    [self.activeView.closeBtn addTapGesture:^{
        [self.activeView removeFromSuperview];
        
        [self initActiveBtn];
    }];
    [self.activeView.detailBtn addTapGesture:^{
        [self.activeView removeFromSuperview];
        [self activeJump];
        [self initActiveBtn];
    }];
    [self.activeView.imageView addTapGesture:^{
        [self.activeView removeFromSuperview];
        [self activeJump];
        [self initActiveBtn];
    }];
    [self performSelector:@selector(removeActiveView) withObject:nil afterDelay:10.0f];
    [window addSubview:self.activeView];
}

// 5秒自动关闭
-(void)removeActiveView{
    if (self.activeView) {
        [self.activeView removeFromSuperview];
        [self initActiveBtn];
    }
}

// 蒙版消失 加载活动按钮
-(void)initActiveBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(APP_WIDTH - margin - activeBtnW, (APP_HEIGHT - APP_TABBARHEIGHT - activeBtnH - margin - (APP_NAVHEIGHT)), activeBtnW, activeBtnH);
    [btn setImage:[UIImage imageNamed:@"small_banner"] forState:UIControlStateNormal];
    [btn click:^(id value) {
        [self activeJump];
    }];
    [self.view addSubview:btn];
}

// 活动跳转
-(void)activeJump{
    QTWebViewController *webController = [[QTWebViewController alloc]init];
    webController.url = self.activeDic[@"url"];
    webController.isScale = YES;
    webController.isNeedLogin = YES;
    [self.navigationController pushViewController:webController animated:YES];
}

@end

