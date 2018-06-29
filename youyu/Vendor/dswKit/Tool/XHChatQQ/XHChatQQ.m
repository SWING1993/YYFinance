//
//  XHChatQQ.m
//  XHChatQQExample
//
//  Created by xiaohui on 16/6/7.
//  Copyright © 2016年 qiantou. All rights reserved.
//  https://github.com/CoderZhuXH/XHChatQQ

#import "XHChatQQ.h"


@implementation XHChatQQ

+(BOOL)haveQQ
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
}
+(void)chatWithQQ:(NSString *)QQ
{
    NSString *url = [NSString stringWithFormat:@"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=%@",QQ];
    
    //http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=4007201188
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
