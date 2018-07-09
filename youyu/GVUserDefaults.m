//
//  GVUserDefaults.m
//  qtyd
//
//  Created by stephendsw on 15/7/16.
//  Copyright (c) 2015年 qtyd. All rights reserved.
//

#import "GVUserDefaults.h"
#import "NSObject+quick.h"
#import "MJExtension.h"
#import "NSString+model.h"
#import "CoreArchive.h"
#import "CoreLockConst.h"

#define kUserStoreDB @"user.db"
#define kUserStoreTable @"user_table"
#define kUserStoreKey @"user_key"

@interface GVUserDefaults ()

@end

static GVUserDefaults *sharedInstance = nil;
@implementation GVUserDefaults

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:kUserStoreDB];
        GVUserDefaults *user = [GVUserDefaults mj_objectWithKeyValues:[store getObjectById:kUserStoreKey fromTable:kUserStoreTable]];
        if (!user) {
            user = [[self alloc] init];
        }
        sharedInstance = user;
    });
    return sharedInstance;
}



- (BOOL)isLogin {
    return !kStringIsEmpty(self.user_id);
}

- (BOOL)isSetPayPassword {
    if ([GVUserDefaults shareInstance].paypwd_status == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)email {
    if (kStringIsEmpty(_email)) {
        return @"";
    }
    return [_email dnValue];
}

- (NSString *)card_id {
    if (kStringIsEmpty(_card_id)) {
        return @"";
    }
    return [_card_id dnValue];
}

- (NSString *)nick_name {
    if (kStringIsEmpty(_nick_name)) {
        return [self.phone phoneFormat];
    }
    return _nick_name;
}

- (void)saveDataWithJson:(NSDictionary *)json {
    [self mj_setKeyValues:json];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:kUserStoreDB];
    [store putObject:json withId:kUserStoreKey intoTable:kUserStoreTable];
}

- (void)clear {
    sharedInstance = [[GVUserDefaults alloc] init];
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:kUserStoreDB];
    [store deleteObjectById:kUserStoreKey fromTable:kUserStoreTable];
}

@end
