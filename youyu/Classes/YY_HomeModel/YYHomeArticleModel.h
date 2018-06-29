//
//  YYHomeArticleModel.h
//  youyu
//
//  Created by LimboDemon on 2017/11/22.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYHomeArticleModel : NSObject

@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, assign) NSInteger addtime;
@property (nonatomic, assign) NSInteger bulletin_type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger hits;
@property (nonatomic, assign) NSInteger article_id;
@property (nonatomic, copy) NSString *jumpurl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *summary;


@end
