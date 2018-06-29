//
//  QTJsonUtil.m
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "QTJsonUtil.h"
#import "GVUserDefaults.h"
#import "GVUserDefaults.h"
#import "SystemConfigDefaults.h"

#define TIMEOUT 30

static NSURLSession *urlSession;

@implementation QTJsonUtil


- (void)taskWithRequest:(NSURLRequest *)request data:(NSDictionary *)data complete:(JsonBlock)block {
    //    NSLog(@"baseUrl:%@",request.URL);
    //    NSLog(@"requestHTTPBody:%@",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    // 检验网络状态
    if (![AppUtil isConnectedToNetwork]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(netFailure)]) {
            [self.delegate netFailure];
        }
        return;
    }
    
    if (!urlSession) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 30;
        urlSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    
    NSURLSession *session = urlSession;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *responseObject, NSURLResponse *response, NSError *error) {
                                          NSInteger statusCode = 0;
                                          
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^(void) {
                                              if (error || (statusCode != 200)) {
                                                  NSDictionary *dic = [NSDictionary dictionaryWithJsonData:responseObject];
                                                  if (!dic) {
                                                      if (self.delegate && [self.delegate respondsToSelector:@selector(jsonFailure:)]) {
                                                          [self.delegate jsonFailure:(NSDictionary *)NETERROR];
                                                      }
                                                  } else {
                                                      [SystemConfigDefaults  sharedInstance].server_time = [dic  info].str(@"server_time");
                                                      if (self.delegate && [self.delegate respondsToSelector:@selector(jsonFailure:)]) {
                                                          [self.delegate jsonFailure:dic];
                                                      }
                                                  }
                                              } else {
                                                  NSDictionary *dic = [NSDictionary dictionaryWithJsonData:responseObject];
                                                  
                                                  if (data && data[@"data"]) {
                                                      block(responseObject);
                                                      return;
                                                  }
                                                  if (dic) {
                                                      [SystemConfigDefaults  sharedInstance].server_time = [dic  info].str(@"server_time");
                                                      if (![dic content]) {
                                                          dic = [dic  info];
                                                      } else {
                                                          dic = [dic content];
                                                      }
                                                      block(dic);
                                                  } else {
                                                      if (self.delegate && [self.delegate respondsToSelector:@selector(jsonFailureTimeout)]) {
                                                          [self.delegate jsonFailureTimeout];
                                                      }
                                                  }
                                              }
                                          });
                                      }];
    [dataTask resume];
}

#pragma  mark - get
- (void)get:(NSString *)url complete:(JsonBlock)block {
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self taskWithRequest:request data:nil complete:block];
}

#pragma mark - post
- (void)post:(NSString *)address data:(NSMutableDictionary *)data complete:(JsonBlock)block {
    NSMutableURLRequest *request = [self getRequestWithrequestUrl:address requestArgument:data];
    [self taskWithRequest:request data:data complete:block];
}

- (NSMutableURLRequest *)getRequestWithrequestUrl:(NSString *)requestUrl requestArgument:(NSMutableDictionary *)requestArgument {
//    NSString *serverURL = [[NSString stringWithFormat:@"%@", SERVER_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *serverURL = [NSString stringWithFormat: @"%@/http/HttpService",[YTKNetworkConfig sharedConfig].baseUrl];
    // content
    if (!requestArgument) {
        requestArgument = [NSMutableDictionary new];
    }
    requestArgument[@"accessid"] = [GVUserDefaults shareInstance].isLogin ? [GVUserDefaults shareInstance].access_id : ACCESS_ID;
    
    // common
    NSMutableDictionary *commomDict = [NSMutableDictionary new];
    commomDict[@"action"] = requestUrl;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStr = [formatter stringFromDate:[NSDate systemDate]];
    commomDict[@"reqtime"] = timeStr;
    commomDict[@"version"] = [AppUtil getAPPVersion];
    commomDict[@"idfa"] = [AppUtil getAPPIDFA];
    commomDict[@"ip"] = [IPHelper deviceIPAdress];
    commomDict[@"trackid"] = TRACKID;
    commomDict[@"device_port"] = @"ios";
    
    NSString *postDataString  = [@{@"request":@{@"content":requestArgument,@"common":commomDict}} mj_JSONString];
    
    NSURL *URL = [NSURL URLWithString:serverURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:TIMEOUT];
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

- (void)post:(NSString *)action fileUpload:(NSData *)imageData complete:(JsonBlock)block {
    NSMutableURLRequest *request = [self uploadRequest:action imageData:imageData];
    [self taskWithRequest:request data:nil complete:block];
}

#pragma mark -idfa
-(void)sendIDFAToServer {
    NSMutableDictionary *dic =[NSMutableDictionary new];
    dic[@"idfa"] = [AppUtil getAPPIDFA];
    dic[@"type"] = @"0";
    [self post:@"syscfg_oMyGreen" data:dic complete:^(id value) {
    }];
}
#pragma mark - 检查更新
- (void)checkAppUpdate {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"app_type"] = @"1";
    [self post:@"syscfg_appversion" data:dic complete:^(NSDictionary *value) {
        NSArray<NSDictionary *> *version_list = value.arr(@"version_list");
        if (version_list.count == 0) {
            return;
        }
        NSString *version = [AppUtil getAPPVersion];
        NSString *appId = kStoreAppId;
        BOOL containVersion = [version_list any:@"self.version_info.version_no > '".add(version).add(@"'").add(@"and").add(@" self.version_info.version_code=").add(appId)];
        if (containVersion) {
            DAlertViewController *alert = [DAlertViewController alertControllerWithTitle:@"有余金服APP有新版本啦" message:@"请更新至新版本"];
            [alert addActionWithTitle:@"立即更新" handler:^(CKAlertAction *action) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?ls=1&mt=8", kStoreAppId]];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alert addActionWithTitle:@"再看看" handler:nil];
            [alert show];
        }
    }];
}


#pragma  mark - request
- (NSMutableURLRequest *)uploadRequest:(NSString *)action imageData:(NSData *)imageData {
    //
//    NSString *serverURL = [NSString stringWithFormat:@"%@", SERVER_URL];
//    serverURL = [serverURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *serverURL = [NSString stringWithFormat: @"%@/http/HttpService",[YTKNetworkConfig sharedConfig].baseUrl];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString    *reqtime = [formatter stringFromDate:[NSDate systemDate]];
    NSString    *accessid;

    if ([GVUserDefaults shareInstance].isLogin) {
        accessid = [GVUserDefaults shareInstance].access_id;
    } else {
        accessid = ACCESS_ID;
    }

    //
    NSURL               *URL = [NSURL URLWithString:serverURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIMEOUT];

    // 头部
    [request addValue:accessid forHTTPHeaderField:@"accessid"];
    [request addValue:action forHTTPHeaderField:@"action"];
    [request addValue:@"1.0" forHTTPHeaderField:@"version"];
    [request addValue:@"ios" forHTTPHeaderField:@"device_port"];
    [request addValue:TRACKID forHTTPHeaderField:@"trackid"];
    [request addValue:[IPHelper deviceIPAdress] forHTTPHeaderField:@"ip"];
    [request addValue:reqtime forHTTPHeaderField:@"reqtime"];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)imageData.length]   forHTTPHeaderField:@"reqlength"];

    NSString *reqcontentmd5 = [NSString getMD5WithData:imageData];
    [request addValue:reqcontentmd5 forHTTPHeaderField:@"reqcontentmd5"];

    NSString *fileurl = [NSString getMD5WithData:imageData].add(@".png");
    [request addValue:fileurl forHTTPHeaderField:@"fileurl"];

    NSString *reqcontentStr = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",
        action,
        accessid,
        reqtime,
        [NSString stringFormValue:imageData.length],
        reqcontentmd5,
        fileurl];

    NSString *access_key;

    if ([GVUserDefaults shareInstance].isLogin) {
        access_key = [GVUserDefaults shareInstance].access_key;
    } else {
        access_key = ACCESS_KEY;
    }

    NSString *sign = [[reqcontentStr md5HexDigest].add(access_key) md5HexDigest];
    [request addValue:@"JSON" forHTTPHeaderField:@"format"];
    [request addValue:sign forHTTPHeaderField:@"sign"];
    //
    [request setHTTPBody:imageData];
    //
    [request setHTTPMethod:@"POST"];

    return request;
}

@end
