//
//  NSString+IDCardFormat.h
//  hr
//
//  Created by 慧融 on 21/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IDCardFormat)

/**
 *  身份证334444显示
 */
+ (NSString*) IdCardFormat:(NSString*)str;
@end
