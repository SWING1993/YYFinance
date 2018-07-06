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

static GVUserDefaults *sharedInstance = nil;
@implementation GVUserDefaults

- (instancetype)init {
    self = [super init];
    if (self) {
        GVUserDefaults *temp = [NSKeyedUnarchiver unarchiveObjectWithFile:DATA_FILE_PATH];
        if (temp.mj_keyValues) {
            [self mj_setKeyValues:temp.mj_keyValues];
        }
    }
    return self;
}

+ (instancetype)shareInstance {
    if (!sharedInstance) {
        sharedInstance = [[GVUserDefaults alloc] init];
    }
    return sharedInstance;
}

- (void)clear {
    NSString *phone = self.phone;
    NSString *pwd = self.pswDes;
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:DATA_FILE_PATH error:nil];
    sharedInstance = [[GVUserDefaults alloc] init];
    sharedInstance.phone = phone;
    sharedInstance.pswDes = pwd;
    [self saveLocal];
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

- (NSString *)getNickName {
    return kStringIsEmpty(self.nick_name) ? [self.phone phoneFormat] : [GVUserDefaults  shareInstance].nick_name;
}

MJCodingImplementation
- (void)saveLocal {
    [NSKeyedArchiver archiveRootObject:self toFile:DATA_FILE_PATH];
}

@end
