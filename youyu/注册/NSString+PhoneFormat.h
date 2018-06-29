//
//  NSString+PhoneFormat.h
//  hr
//
//  Created by 慧融 on 20/09/17.
//  Copyright © 2017年 qtyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PhoneFormat)

/**
 *  手机111-2222-3333显示
 */
+ (NSString*) phoneFormat:(NSString*)str;

@end
