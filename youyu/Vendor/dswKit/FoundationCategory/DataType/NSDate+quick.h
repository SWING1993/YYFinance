//
//  NSDate+quick.h
//  qtyd
//
//  Created by stephendsw on 15/9/24.
//  Copyright © 2015年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (quick)

@property (nonatomic, readonly)  NSDateComponents *components;

/**
 *  yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, readonly) NSString *longTimeString;

/**
 *  yyyy-MM-dd
 */
@property (nonatomic, readonly) NSString *shortTimeString;

- (NSString *)stringWithFormat:(NSString *)format;

@end
