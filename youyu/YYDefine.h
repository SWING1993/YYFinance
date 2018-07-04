//
//  YYDefine.h
//  youyu
//
//  Created by 宋国华 on 2018/6/25.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHelpDeskAppKey  @"1461180619068259#kefuchannelapp55499"
#define kHelpDeskTenantId  @"55499"
#define kHelpDeskConversationChatter  @"kefuchannelimid_863071"
#define kHelpDeskUserName  [GVUserDefaults shareInstance].phone
#define kHelpDeskPassword  @"password123456"

// **************************************服务端******************************************
#pragma mark -  服务端

#define kBaseUrl             @"http://www.uyujf.com:8888"
#define WEB_URL(url)         [@"https://www.uyujf.com/mobile" stringByAppendingString:url]
#define RETURN_URL(url)      [@"https://www.uyujf.com/appSina/iosPageH5/" stringByAppendingString:url]

//#define kBaseUrl             @"http://47.96.130.132:8080"
//#define WEB_URL(url)         [@"http://test.uyujf.com/mobile" stringByAppendingString:url]
//#define RETURN_URL(url)      [@"http://test.uyujf.com/appSina/iosPageH5/" stringByAppendingString:url]

//弱引用/强引用
#define YYWeakSelf(type)  __weak typeof(type) weak##type = type;
#define YYStrongSelf(type)  __strong typeof(type) type = weak##type;

//设置 view 圆角和边框
#define YYViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//由角度转换弧度 由弧度转换角度
#define YYDegreesToRadian(x) (M_PI * (x) / 180.0)
#define YYRadianToDegrees(radian) (radian*180.0)/(M_PI)

//获取view的frame
#define kGetViewWidth(view)  view.frame.size.width
#define kGetViewHeight(view) view.frame.size.height
#define kGetViewX(view)      view.frame.origin.x
#define kGetViewY(view)      view.frame.origin.y
//获取图片资源的frame
//#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//沙盒目录文件
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);

// alertView
//#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

#define kKeyWindow [[[UIApplication sharedApplication] delegate] window]

#pragma mark - 系统版本  屏幕尺寸
/**
 *  系统版本
 */
#define kDeviceType  [[UIDevice currentDevice] model]
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#define kDeviceId [HKTools getDeviceIDInKeychain]
#define kVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define KIdentifier [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

#pragma mark - ios系统版本
/**
 *  设备
 */
#define ios11x [kSystemVersion floatValue] >= 11.0f
#define ios10x [kSystemVersion floatValue] >= 10.0f
#define ios9x [kSystemVersion floatValue] >= 9.0f
#define ios8x [kSystemVersion floatValue] >= 8.0f
#define ios7x ([kSystemVersion floatValue] >= 7.0f) && ([kSystemVersion floatValue] < 8.0f)
#define ios6x [kSystemVersion floatValue] < 7.0f
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarHeight 44
#define kNaviHeigh (kNavigationBarHeight+kStatusBarHeight)
#define kTabBarHeight (kDevice_Is_iPhoneX ? 83.0f : 49.0f)

#pragma mark - 屏幕宽高

#define kScaleFrom_iPhone6_Desgin(_X_) (_X_ * (kScreenW/375))
#define kDevice_Is_iPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 屏幕frame,bounds,size
#define kScreenFrame [UIScreen mainScreen].bounds
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScale [UIScreen mainScreen].scale
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

#define kScreenWidthRatio       (kScreenW < 375 ? kScreenW / 375.0 : 1)
#define kScreenHeightRatio      (kScreenW < 667 ? kScreenH / 667.0 : 1)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)

#pragma mark - Methods
#define YYURLWithStr(urlString)    [NSURL URLWithString:urlString]
#define YYNotificationCenter [NSNotificationCenter defaultCenter]
#define YYFileManager        [NSFileManager defaultManager]

#pragma mark - Colors
#define kColorBackGround    UIColorMake(246.0, 246.0, 246.0)
#define kColorClear         [UIColor clearColor]
#define kColorRandom        [UIColor randomColor]
#define kColorBlack         [UIColor blackColor]
#define kColorWhite         [UIColor whiteColor]
#define kColorTextGray      UIColorMake(102.0, 102.0, 102.0)
#define kColorTextBlack     UIColorMake(51.0, 51.0, 51.0)
#define kColorRed           UIColorMake(249.0, 35.0, 29.0)

#define kPlaceholderImage UIImageMake(@"placeholderImage")

#pragma mark - 通知处理
#define DDAddNotification(_selector,_name)\
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])

#define DDRemoveNotificationWithName(_name)\
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])

#define DDRemoveNotificationObserver() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#define DDPostNotification(_name)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])

#define DDPostNotificationWithObj(_name,_obj)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:nil])

#define DDPostNotificationWithInfos(_name,_obj,_infos)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:_infos])

// 字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
// 数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
// 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#ifdef DEBUG
//    #define NSLog(...)      NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define NSLog(format, ...) printf("TIME:%s FILE:%s(%d行) FUNCTION:%s \n %s\n\n",__TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#define debugMethod()
#endif

extern float const bankTipTime;

#define IMAGE_DEFAULT @"mall_default"

#pragma mark - TAG

// tab controller 顺序
extern NSInteger const HOME_TAG;

extern NSInteger const TENDER_TAG;

extern NSInteger const BRAND_TAG;

extern NSInteger const MY_TAG;

extern NSInteger const MORE_TAG;

// ******************************************tarck **************************************
#pragma mark - tacrkid

#define TRACKID [@"iOS" stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

// ******************************************tip**************************************

#pragma mark - tip

extern NSString *const MSGTIP;

extern NSString *const NETTIP;

extern NSString *const NETERROR;

extern NSString *const UNLOGINTIP;

extern NSString *const LOGINOTHERTIP;

extern NSString *const LOGIN_TIP;

#pragma mark - notic

extern NSString *const NOTICEHOME;

extern NSString *const NOTICEBANK;

extern NSString *const NOTICEORDER;

extern NSString *const NOTICEWEB;

// ========================================= key =======================================
#pragma mark - key

/**
 *  appid数字串
 */
extern NSString *const kStoreAppId;

/**
 *  友盟key
 */
extern NSString *const KEY_UM;

/**
 *  微信appid
 */
extern NSString *const KEY_WXAppId;

/**
 *  微信 Secret key
 */
extern NSString *const KEY_WXSecret;

/**
 *  QQ appid
 */
extern NSString *const KEY_QQAPPId;

/**
 *  QQ appkey
 */
extern NSString *const KEY_QQSecret;

/**
 *  Sina appid
 */
extern NSString *const KEY_SinaAPPId;

/**
 *  Sina Secret key
 */
extern NSString *const KEY_SinaSecret;

// 注册协议
extern NSString *const URL_REG_PROTOCOL;

extern NSString *const ACCESS_ID;

extern NSString *const ACCESS_KEY;

extern NSString *const deskey;

#pragma mark - 操作

#define TABLEReg(className, id) [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([className class]) bundle:nil] forCellReuseIdentifier: id]

#define NOTICE_POST(name) [[NSNotificationCenter defaultCenter] postNotificationName: name object: nil]

// ***************************************路劲*****************************************
#pragma mark -  路径

#define CITY_FILE_PATH  pathCachesFile(@"city.plist")

#define DATA_FILE_PATH  pathCachesFile(@"data.dic")

#define RSS(point) APP_WIDTH/375*point
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define IMG(name)  [UIImage imageNamed:name]
#define FONT(f) [UIFont systemFontOfSize:f]
#define MainTitleColor RGBA(51, 51, 51, 1)
#define SecondaryTitleColor RGBA(102, 102, 102, 1)
#define LightGrayColor RGBA(153, 153, 153, 1)
#define MainColor RGBA(244, 58, 70, 1)

