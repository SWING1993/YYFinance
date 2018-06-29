//
//  QTJsonUtil.h
//  qtyd
//
//  Created by stephendsw on 15/7/15.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ JsonBlock)(id value);

@protocol JsonUtilDelegate<NSObject>

- (void)jsonFailure:(NSDictionary *)dic;
- (void)jsonFailureTimeout;
- (void)netFailure;

@end

@interface QTJsonUtil : NSObject

@property (nonatomic, weak) id<JsonUtilDelegate> delegate;

- (void)post:(NSString *)address data:(NSMutableDictionary *)data complete:(JsonBlock)block;
- (void)post:(NSString *)action fileUpload:(NSData *)imageData complete:(JsonBlock)block;
- (void)get:(NSString *)url complete:(JsonBlock)block;
- (void)checkAppUpdate;
- (void)sendIDFAToServer;

@end
