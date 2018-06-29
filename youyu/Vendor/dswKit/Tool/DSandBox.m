//
//  DSandBox.m
//  qtyd
//
//  Pathd by stephendsw on 2017/1/10.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import "DSandBox.h"

NSString *pathDocumentsFile(NSString *fileName) {
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *path = [paths objectAtIndex:0];

    return [path stringByAppendingPathComponent:fileName];
}

NSString *pathTmpFile(NSString *fileName) {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

NSString *pathLibraryFile(NSString *fileName) {
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString    *path = [paths objectAtIndex:0];

    return [path stringByAppendingPathComponent:fileName];
}

NSString *pathPreferencesFile(NSString *fileName) {
    return [[pathLibraryFile(@"") stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:fileName];
}

NSString *pathCachesFile(NSString *fileName) {
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString    *path = [paths objectAtIndex:0];

    return [path stringByAppendingPathComponent:fileName];
}
