//
//  YYRequestApi.h
//  youyu
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork/YTKNetwork.h>

@interface YYRequestApi : YTKRequest

- (id)initWithPostTaskUrl:(NSString *)url requestArgument:(NSDictionary *)argument;

@end
