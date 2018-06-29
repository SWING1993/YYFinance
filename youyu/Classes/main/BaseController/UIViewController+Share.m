//
//  UIViewController+Share.m
//  qtyd
//
//  Created by stephendsw on 16/2/19.
//  Copyright © 2016年 qtyd. All rights reserved.
//

#import "UIViewController+Share.h"

#import "QTWebViewController.h"

#import "WXApi.h"

#import <UShareUI/UShareUI.h>

@implementation ShareModel

- (NSArray *)type {
    if (!_type) {
        return @[@"qzone", @"qq", @"wxtimeline", @"wxsession", @"sms", @"sina", @"tencent", @"renren"];
    }
    
    return _type;
}

- (NSString *)img {
    if (!_img) {
        return @"";
    }
    
    return _img;
}

- (NSString *)content {
    if (!_content) {
        return @"";
    }
    
    return _content;
}

+ (instancetype)shareModelWithTitle:(NSString *)title content:(NSString *)content url:(NSString *)url img:(NSString *)img {
    ShareModel *shareModel = [ShareModel new];
    shareModel.title = title;
    shareModel.content = content;
    shareModel.url = url;
    shareModel.img = img;
    return shareModel;
}

@end

@implementation UIViewController (Share)

#pragma  mark - share

- (void)share:(id)obj {
    DAlertViewController *alertController = [DAlertViewController alertControllerWithTitle:@"分享" message:@"请选择分享的平台"];
    
    [alertController addActionWithTitle:@"微信好友" handler:^(CKAlertAction *action) {
        [self shareWiXin:obj type:0];
    }];
    [alertController addActionWithTitle:@"微信朋友圈" handler:^(CKAlertAction *action) {
        [self shareWiXin:obj type:1];
    }];
    [alertController addActionWithTitle:@"取消" handler:^(CKAlertAction *action) {}];
    
    [alertController show];
}

- (void)shareWiXin:(id)obj type:(int)type {
    NSString    *shareTitle = @"";
    NSString    *sharetext = @"";
    NSString    *shareurl = @"";
    NSString    *shareImg = @"";
    NSArray     *sns = @[];
    
    if ([obj isKindOfClass:[ShareModel class]]) {
        ShareModel *item = (ShareModel *)obj;
        shareTitle = item.title;
        sharetext = item.content;
        shareurl = item.url;
        shareImg = item.img;
        sns = item.type;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *item = (NSDictionary *)obj;
        shareTitle = item.str(@"title");
        sharetext = item.str(@"content");
        shareurl = item.str(@"url");
        shareImg = item.str(@"img");
        
        sns = item.arr(@"type");
        
        if (sns.count == 0) {
            sns = @[@"qzone", @"qq", @"wxtimeline", @"wxsession", @"sms", @"sina", @"tencent", @"renren"];
        }
    }
    
    NSData  *data;
    UIImage *image;
    
    if ([shareImg containsString:@"http"]) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImg]];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:shareImg];
    }
    
    // 创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;     //不使用文本信息
    sendReq.scene = type;   // 0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    // 创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = shareTitle;      // 分享标题
    urlMessage.description = sharetext; // 分享描述
    [urlMessage setThumbImage:image];   // 分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    // 创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = shareurl;// 分享链接
    
    // 完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    // 发送分享信息
    [WXApi sendReq:sendReq];
}


/**
 基于友盟平台的微信，QQ，微博分享
 
 @param obj 待分享的对象实体
 */
- (void)umShare:(id)obj {
    
    //分享面板加入自定义图标事件
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                     withPlatformIcon:[UIImage imageNamed:@"umsocial_copy"]
                                     withPlatformName:@"复制链接"];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    
    //预设置分享平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)/**,@(UMSocialPlatformType_Sina)*/]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"userInfo:%@",userInfo);
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            NSLog(@"do your operation for copy");
            //复制链接操作
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            ShareModel *sm = (ShareModel *)obj;
            pasteboard.string = sm.url;
            [self showToast:@"链接已复制" duration:1 done:nil];
        } else {
            [self shareWebPageToPlatformType:platformType content:obj];
        }
    }];
}

//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType content:(ShareModel *)content
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //image处理
    NSData  *data;
    UIImage *image;
    
    if ([content.img containsString:@"http"]) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:content.img]];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:content.img];
    }
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:content.title descr:content.content thumImage:image];
    //设置网页地址
    shareObject.webpageUrl =content.url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        } else {
            message = [NSString stringWithFormat:@"分享失败Code: %d\n",(int)error.code];
            
        }
        [self showToast:message duration:1 done:nil];
    }];
}

@end

