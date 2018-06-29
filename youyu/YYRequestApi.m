//
//  YYRequestApi.m
//  youyu
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import "YYRequestApi.h"
#import "QTloginViewController.h"

@implementation YYRequestApi {
    NSURLRequest * _request;
}

static NSURLSession *urlSession;

- (id)initWithPostTaskUrl:(NSString *)url requestArgument:(NSDictionary *)argument {
    self = [super init];
    if (self) {
        _request = [self getRequestWithrequestUrl:url requestArgument:argument];
    }
    return self;
}

- (NSURLRequest *)getRequestWithrequestUrl:(NSString *)url requestArgument:(NSDictionary *)argument {
//    NSString *serverURL = [[NSString stringWithFormat:@"%@", SERVER_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *serverURL = [NSString stringWithFormat: @"%@/http/HttpService",[YTKNetworkConfig sharedConfig].baseUrl];
    NSMutableDictionary *argumentDict = [NSMutableDictionary dictionaryWithDictionary:argument];
    argumentDict[@"accessid"] = [GVUserDefaults shareInstance].isLogin ? [GVUserDefaults shareInstance].access_id : ACCESS_ID;
    
    // common
    NSMutableDictionary *commomDict = [NSMutableDictionary dictionary];
    commomDict[@"action"] = url;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStr = [formatter stringFromDate:[NSDate systemDate]];
    commomDict[@"reqtime"] = timeStr;
    commomDict[@"version"] = [AppUtil getAPPVersion];
    commomDict[@"idfa"] = [AppUtil getAPPIDFA];
    commomDict[@"ip"] = [IPHelper deviceIPAdress];
    commomDict[@"trackid"] = TRACKID;
    commomDict[@"device_port"] = @"ios";
    
    NSString *postDataString  = [@{@"request":@{@"content":argumentDict,@"common":commomDict}} mj_JSONString];
    
    NSURL *URL = [NSURL URLWithString:serverURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    [request setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    // HTTPHeaderField
    [request addValue:@"JSON" forHTTPHeaderField:@"format"];
    [request addValue:[NSString stringWithFormat:@"%zi",[postDataString dataUsingEncoding:NSUTF8StringEncoding].length] forHTTPHeaderField:@"reqlength"];
    NSString *access_key = [GVUserDefaults shareInstance].isLogin ? [GVUserDefaults shareInstance].access_key : ACCESS_KEY;
    NSString *sign = [[postDataString md5HexDigest].add(access_key) md5HexDigest];
    [request addValue:sign forHTTPHeaderField:@"sign"];
    
    return [request copy];
}

- (NSURLRequest *)buildCustomUrlRequest {
    return _request;
}

- (void)requestCompletePreprocessor {
}


- (void)requestFailedPreprocessor {
//    NSDictionary *resultDict = (NSDictionary *)self.responseObject;
//    if ((resultDict.code == 110025) || (resultDict.code == 110026) || (resultDict.code == 110019)) {
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            USER_DATA.isLogin = NO;
//            QTloginViewController *controller = [QTloginViewController controllerFromXib];
//            controller.isBackHome = YES;
//            [AppDelegate presentVC:controller];
//        });
//    }
}


@end
