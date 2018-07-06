//
//  QTInvestDetailViewController.m
//  qtyd
//
//  Created by stephendsw on 15/7/30.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTInvestDetailViewController.h"
#import "QTInvestGetViewController.h"
#import "QTWebViewController.h"
#import "QTBaseViewController+Table.h"
#import "QTPayResetPwdViewController.h"
#import "QTPayViewController.h"
#import "InvestDetailView.h"
#import "QTOpenSinaViewController.h"
#import "QTBorrowTenderLogViewController.h"
#import "WMPageController.h"
#import "CAShapeLayer+qtlayer.h"
#import "QTPageViewController.h"
#import "QTRewardView.h"
#import "HRBindBankViewController.h"
#import "HRSetPayPwdViewController.h"

@interface QTInvestDetailViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbtip;
@property (strong, nonatomic)  UILabel *lbtbmoney;
@property (strong, nonatomic)  UILabel *lbtbrate;
@property (strong, nonatomic)  UILabel *lbtbdate;
@property (strong, nonatomic)  UILabel *lbtbreturn;
@property (strong, nonatomic) IBOutlet UIView *viewbottom;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton   *btnCal;
@property (strong, nonatomic) IBOutlet UIControl *tipview;

@end

@implementation QTInvestDetailViewController
{
    QTRewardView    *rewardFirstView;
    QTRewardView    *rewardMostView;
    QTRewardView    *rewardLastView;

    InvestDetailView *investDetailView;

    WMPageController *pageVC;

    UIView *imageTipView;

    UILabel *timelLable;

    //
    QTWebViewController             *webController;
    QTBorrowTenderLogViewController *logController;
    QTInvestGetViewController       *investGetViewController;

    NSTimer *timer;
}

- (void)viewDidLoad {
    self.scrollview.delegate = self;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [MobClick beginLogPageView:@"investDetailView"];
    [super viewWillAppear:animated];
    [QTTheme btnRedStyle:self.btn];
    [self setBackButton];

    [self commonJson];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"investDetailView"];
}

- (void)initUI {
    self.scrollview.delegate = self;

    DStackView *stack = [[DStackView  alloc]initWidth:APP_WIDTH];

    investDetailView = [InvestDetailView  viewNib];

    investDetailView.height = 210;
    [stack addView:investDetailView];

    [stack addLineForHeight:6 color:[Theme backgroundColor]];

    DGridView *grid = [[DGridView alloc]initWidth:APP_WIDTH];
    [grid setColumn:16 height:23];
    grid.isShowLine = NO;

    self.lbtbmoney = [grid addRowLabel:@"项目总额:" text:@""];
    self.lbtbrate = [grid addRowLabel:@"计息方式:" text:@""];
    self.lbtbdate = [grid addRowLabel:@"起止日期:" text:@""];
    self.lbtbreturn = [grid addRowLabel:@"还款方式:" text:@""];

    [stack addLineForHeight:10 color:[UIColor whiteColor]];
    [stack addView:grid];
    [stack addLineForHeight:10 color:[UIColor whiteColor]];
    [stack addLineForHeight:6 color:[Theme backgroundColor]];

    timelLable = [[UILabel alloc] init];
    timelLable.textAlignment = NSTextAlignmentLeft;
    timelLable.font = [UIFont systemFontOfSize:12];
    timelLable.textColor = [Theme redColor];
    timelLable.height = 0;
    timelLable.width = APP_WIDTH;

    [stack addView:timelLable margin:UIEdgeInsetsMake(0, 16, 0, 16)];
    
///TODO:========针对湖商贷不需要【首投，尾投，最高投】所做的UI展示处理！！！===========
    [stack addView:self.tipview margin:UIEdgeInsetsMake(APP_HEIGHT - APP_NAVHEIGHT - 160 - 275, 0, 0, 0)];

//    rewardFirstView = [QTRewardView viewNib];
////    rewardFirstView.image.image = [UIImage imageNamed:@"icon_first_invest"];
//    rewardFirstView.lbTitle.text = @"";//@"首投";
////    rewardFirstView.lbName.text = @"虚位以待";
////    rewardFirstView.lbContent.text = @"首投红包";
//
//    rewardMostView = [QTRewardView viewNib];
////    rewardMostView.image.image = [UIImage imageNamed:@"icon_height_invest"];
////    rewardMostView.lbTitle.text = @"最高";
////    rewardMostView.lbName.text = @"虚位以待";
////    rewardMostView.lbContent.text = @"最高投红包";
//
//    rewardLastView = [QTRewardView viewNib];
////    rewardLastView.image.image = [UIImage imageNamed:@"icon_tail_invest"];
////    rewardLastView.lbTitle.text = @"尾投";
////    rewardLastView.lbName.text = @"虚位以待";
////    rewardLastView.lbContent.text = @"收官红包";
//
//    [stack addView:rewardFirstView margin:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [stack addView:rewardMostView margin:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [stack addView:rewardLastView margin:UIEdgeInsetsMake(0, 0, 0, 0)];

    [stack addLineForHeight:10];//10
//    [stack addView:self.tipview margin:UIEdgeInsetsZero];
    
    
    [stack addLineForHeight:0];
    [self initPageController];
    [stack addView:pageVC.view];
    [self.scrollview addSubview:stack];
    [self.scrollview autoContentSize];
    if (!IPHONE4) {
        self.scrollview.pagingEnabled = YES;
    }
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.width = APP_WIDTH;
    
    if (IPHONEX) {
        [self addBottomView:self.viewbottom padding:UIEdgeInsetsMake(0, 0, 10, 0)];
    } else {
        [self addBottomView:self.viewbottom];
    }
    
    [self.btnCal click:^(id value) {
        [self toCalc];
    }];
}

#pragma  mark - 分页
- (void)initPageController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];

    NSArray *titleList = @[@"项目详情", @"投资记录"];

    webController = [QTWebViewController new];
    webController.isNeedLogin = NO;
    webController.isScale = NO;
    webController.cutHeight = 100;
    //
    logController = [QTBorrowTenderLogViewController new];
    logController.borrow_id = self.borrow_id;

    [viewControllers addObject:webController];
    [viewControllers addObject:logController];

    pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titleList];
    pageVC.menuItemWidth = APP_WIDTH / 2;
    pageVC.menuHeight = 44;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.cutHeight = 50.0f;
    pageVC.titleColorNormal = [UIColor blackColor];
    pageVC.titleColorSelected = Theme.redColor;
    pageVC.menuBGColor = [UIColor whiteColor];
    pageVC.view.height = APP_HEIGHT - 44 - 66;
    pageVC.selectIndex = 1;
}

#pragma  mark - back
- (void)setBackButton {
    __weak QTInvestDetailViewController *weakSelf = self;

    imageTipView = [[UIView alloc]initWithFrame:CGRectMake(APP_WIDTH - 50, APP_HEIGHT - 68 - 44 - 44 - 20, 50, 50)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 24, 24)];
    image.contentMode = UIViewContentModeScaleAspectFit;
    imageTipView.tag = 100000;
    image.image = [UIImage imageNamed:@"icon_backtop2"];
    imageTipView.hidden = YES;
    [imageTipView addTapGesture:^{
        [weakSelf.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    [imageTipView addSubview:image];

    [self.view addSubview:imageTipView];
}
#warning 上滑操作在iPhone5(iPhoneSE)系列，iPhoneX上UI展示有bug.
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat height = sender.frame.size.height;
    CGFloat contentYoffset = sender.contentOffset.y;
    CGFloat distanceFromBottom = sender.contentSize.height - contentYoffset;
    //TODO:临时修正iPhone5系列机型上滑的问题----鸡肋！！！
    if (IPHONE5) {
         [rewardLastView removeFromSuperview];
    }
   
    CGFloat ScreenOffset = 30;
    if(IPHONE5){
        ScreenOffset = 50;
    }
    if (distanceFromBottom < height + ScreenOffset) {
        imageTipView.hidden = NO;
        sender.scrollEnabled = NO;

        webController.url = [NSString stringWithFormat:@"%@%@", WEB_URL(@"/amaze/detail/"), self.borrow_id].add(@".html");
        [webController loadData];
    } else {
        imageTipView.hidden = YES;
        sender.scrollEnabled = YES;
    }
    NSLog(@"----  %@",sender);
}

#pragma  mark - json

- (void)commonJson {
    [self showHUD];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"borrow_id"] = self.borrow_id;
    [service post:@"borrow_detail" data:dic complete:^(NSDictionary *value) {
        self.borrowInfo = value;
        investGetViewController = [QTInvestGetViewController controllerFromXib];
        investGetViewController.borrowInfro = value;
        
        if ([value[@"borrow_name"] containsString:@"】"] && [value[@"borrow_name"] containsString:@"【"]) {
            self.titleView.title = [NSString stringWithFormat:@"%@", [value[@"borrow_name"] firstBorrowNameNoFormat]];
        }else{
            self.titleView.title = [NSString stringWithFormat:@"%@", value[@"borrow_name"]];
        }
        
        NSDictionary *sanyang_reward = value.dic(@"sanyang_reward");

        //TODO:加入类型判断----临时处理！！！
        if ([sanyang_reward isKindOfClass:[NSDictionary class]]) {
            //三羊
            // 首投
            if (sanyang_reward.i(@"first_info.obtain_status") == 0) {
                rewardFirstView.lbContent.text = sanyang_reward.str(@"first_info.reward_money").add(@"元首投红包券");
            } else {
                rewardFirstView.lbName.text = sanyang_reward.str(@"first_info.user");
                rewardFirstView.lbContent.text = @"获 ".add(sanyang_reward.str(@"first_info.reward_money")).add(@"元首投红包券");
            }
            
            // 最高投
            if (sanyang_reward.i(@"max_info.obtain_status") == 0) {
                if (sanyang_reward.fl(@"max_info.tender_money") > 0) {
                    rewardMostView.lbContent.text = [NSString stringWithFormat:@"目前榜首%@元\n超过TA抢%ld元最高投红包券", sanyang_reward.str(@"max_info.tender_money"), (long)sanyang_reward.i(@"max_info.reward_money")];
                    
                    rewardMostView.lbName.text = sanyang_reward.str(@"max_info.user");
                } else {
                    rewardMostView.lbContent.text = sanyang_reward.str(@"max_info.reward_money").add(@"元最高投红包券");
                }
            } else {
                rewardMostView.lbName.text = sanyang_reward.str(@"max_info.user");
                rewardMostView.lbContent.text = @"获 ".add(sanyang_reward.str(@"max_info.reward_money")).add(@"元最高投红包券");
            }
            
            if (sanyang_reward.i(@"second_max_status") == 1) {
                // 次高投
                rewardLastView.lbTitle.text = @"次高";
                
                if (sanyang_reward.i(@"second_max_info.obtain_status") == 0) {
                    if (sanyang_reward.fl(@"second_max_info.tender_money") > 0) {
                        rewardLastView.lbContent.text = [NSString stringWithFormat:@"次席已投%@元, %ld元次投红包券等你来夺!", sanyang_reward.str(@"second_max_info.tender_money"), (long)sanyang_reward.i(@"second_max_info.reward_money")];
                        
                        rewardLastView.lbName.text = sanyang_reward.str(@"second_max_info.user");
                    } else {
                        rewardLastView.lbContent.text = sanyang_reward.str(@"second_max_info.reward_money").add(@"元次高投红包券");
                    }
                } else {
                    rewardLastView.lbName.text = sanyang_reward.str(@"second_max_info.user");
                    rewardLastView.lbContent.text = @"获 ".add(sanyang_reward.str(@"last_info.reward_money")).add(@"元次高投红包券");
                }
            } else {
                // 尾投
                rewardLastView.lbTitle.text = @"尾投";
                
                if (sanyang_reward.i(@"last_info.obtain_status") == 0) {
                    rewardLastView.lbContent.text = sanyang_reward.str(@"last_info.reward_money").add(@"元尾投红包券");
                } else {
                    rewardLastView.lbName.text = sanyang_reward.str(@"last_info.user");
                    rewardLastView.lbContent.text = @"获 ".add(sanyang_reward.str(@"last_info.reward_money")).add(@"元尾投红包券");
                }
            }
        }
       

        NSDictionary *borrowDic = value;
        //
        [investDetailView bindDetailPage:value];

        self.lbtbmoney.text = value.str(@"loan_amount").add(@"元");

        self.lbtbrate.text = @"满标计息";

        NSString *time1 = [value.str(@"publish_time") .dateTypeValue stringWithFormat:@"yyyy.MM.dd"];
        NSString *time2 = [value.str(@"repay_time")  .dateTypeValue stringWithFormat:@"yyyy.MM.dd"];

        if ([value.str(@"borrow_type") isEqualToString:@"840"] || [value.str(@"borrow_type") isEqualToString:@"900"] ) {
            self.lbtbdate.text = time1.add(@"—").add(time2).add(@"(之前)");
        } else {
            self.lbtbdate.text = time1.add(@"—").add(time2);
        }

        self.lbtbreturn.text = value.str(@"repayment_style");

        //

        if (self.lbtbreturn.numberOfLines == 0) {
            self.lbtbreturn.text = value.str(@"repayment_style");
        }

        if ([borrowDic[@"operate"] isEqualToString:@"已回款"] || [borrowDic[@"operate"] isEqualToString:@"已满标"] || [borrowDic.str(@"operate") containsString:@"流标"]) {
            [self.btn setTitle:borrowDic[@"operate"] forState:UIControlStateNormal];
            [QTTheme btnGrayStyle:self.btn];

            [self hideHUD];
        } else if (![GVUserDefaults  shareInstance].isLogin) {
            [self.btn setTitle:@"登录" forState:UIControlStateNormal];
            [self.btn click:^(id value) {
//                [self loginBack];
                //新调整！！！
                HRLoginViewController *controller = [HRLoginViewController controllerFromXib];
                [self.navigationController  pushViewController:controller animated:YES];
            }];
            [self hideHUD];
        } else if ([GVUserDefaults  shareInstance].real_status != 1) {
            [self.btn setTitle:@"请您先实名认证" forState:UIControlStateNormal];
            [self.btn click:^(id value) {
              
//                QTOpenSinaViewController *controller = [QTOpenSinaViewController controllerFromXib];
//                controller.isGoBack = YES;
//                [self.navigationController pushViewController:controller animated:YES];
                
                // 跳转到实名认证----新调整！！！
                HRBindBankViewController *controller = [HRBindBankViewController controllerFromXib];
                [self.navigationController pushViewController:controller animated:YES];
            }];
            [self hideHUD];
        } else if (([borrowDic[@"new_hand"] integerValue] == 2) && ![[GVUserDefaults  shareInstance].first_tender_time isEqualToString:@"0"]) {
            [self.btn setTitle:@"仅限新手投资" forState:UIControlStateNormal];
            [self.btn click:^(id value) {
                [self showMeg:@"仅限新手投资，去看看其他项目"];
            }];
            [QTTheme btnGrayStyle:self.btn];
            [self hideHUD];
        } else {
            [self showHUD];
           
                if (![[GVUserDefaults shareInstance] isSetPayPassword]) {
                    [self.btn setTitle:@"设置支付密码" forState:UIControlStateNormal];

                    [self.btn click:^(id value) {

//                        [self toPayPwd];
                        
                        ///新调整！！！ HRSetPayPwdViewController
//                        HRSetPayPwdViewController *controller = [HRSetPayPwdViewController controllerFromXib];
                        QTPayResetPwdViewController *controller = [QTPayResetPwdViewController controllerFromXib];
                        [self.navigationController pushViewController:controller animated:YES];
                    }];
                    [self hideHUD];
                    return;
                }
                // 计算可用余额,包括红包
                NSMutableDictionary *param = [NSMutableDictionary new];
                param[@"borrow_id"] = self.borrow_id;

                [service post:@"borrow_userinfo" data:param complete:^(NSDictionary *value) {
                    if (value.i(@"unpay_order_nums") > 0) {
                        [self.btn setTitle:@"您有未支付订单" forState:UIControlStateNormal];
                        [self.btn click:^(id value) {
                            [self toTrendOrder];
                        }];
                        [QTTheme btnRedStyle:self.btn];
                        [self hideHUD];
                        return;
                    }

                    if ([borrowDic[@"operate"] isEqualToString:@"满标待审"]) {
                        [self.btn setTitle:borrowDic[@"operate"] forState:UIControlStateNormal];
                        [QTTheme btnGrayStyle:self.btn];
                        [self hideHUD];
                        return;
                    }

                    [self.btn setTitle:@"立即投资" forState:UIControlStateNormal];
                    [self.btn click:^(id value) {
                        [MobClick event:@"projectDetailBt"];
                        investGetViewController.titleView.title = self.titleView.title;

                        [self.navigationController pushViewController:investGetViewController animated:YES];
                    }];

                    [self hideHUD];
                }];
          
        }

        if (value.str(@"invest_user_ids").length > 0) {
            rewardFirstView.alpha = 0;
            rewardMostView.alpha = 0;
            rewardLastView.alpha = 0;
            self.lbtbrate.text = @"T(满标日)+1";

            // ================倒计时========================================================
            if (value[@"borrow_addtime"] && ![value.str(@"operate") isEqualToString:@"已满标"]) {
                __block NSTimeInterval offtime = (48 * 60 * 60 + value.i(@"borrow_addtime")) - value.i(@"server_time");

                timelLable.height = 30;
                [timer invalidate];

                if (offtime > 0) {
                    timer = [NSTimer timerExecuteCountPerSecond:offtime done:^(NSInteger vlaue) {
                        if (vlaue == 0) {
                            [timelLable removeFromSuperview];
                            [self.btn setTitle:@"流标" forState:UIControlStateNormal];
                            [timer invalidate];
                        } else {
                            timelLable.text = [NSString stringWithFormat:@"剩余募集时间:%@", [[@(vlaue)stringValue] secondToTimeFormatChinese]];
                        }
                    }];
                } else {
                    [timelLable removeFromSuperview];
                    [self.btn setTitle:@"已流标" forState:UIControlStateNormal];
                    [QTTheme btnGrayStyle:self.btn];
                }
            }
        }
    }];
}

@end
