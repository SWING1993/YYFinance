//
//  UIViewController+Share.h
//  qtyd
//
//  Created by stephendsw on 16/2/19.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSArray *type;

@end

@interface UIViewController (Share)

/**
 实例化分享对象实体
 
 @param title 分享标题
 @param content 分享内容
 @param url 分享链接
 @param img 分享图标
 @return 待分享的对象
 */
+ (instancetype)shareModelWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url img:(NSString *)img;

/**
 *
 *   qzone,
 *   qq,
 *   wxtimeline,
 *   wxsession,
 *   sms,
 *   sina,
 *   tencent,
 *   renren
 *
 *
 */
- (void)share:(id)obj;

/**
 基于友盟平台的微信，QQ，微博分享
 
 @param obj 待分享的对象实体
 */
- (void)umShare:(id)obj;

@end
